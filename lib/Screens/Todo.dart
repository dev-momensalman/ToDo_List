import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/TodoProvider.dart'; // اتأكد ان المسار ده صح عندك

class TodoScreen
    extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() =>
      _TodoScreenState();
}

class _TodoScreenState
    extends State<TodoScreen> {
  final TextEditingController
  _textFieldController =
      TextEditingController();
  bool isGridView =
      false; // المتغير اللي بيتحكم في العرض (ليست ولا جريد)

  @override
  Widget build(BuildContext context) {
    // استدعاء البروفايدر عشان نسمع أي تغيير في الداتا
    final todoProvider =
        Provider.of<TodoProvider>(
          context,
        );

    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ),
      appBar: AppBar(
        title: const Text(
          "Task Manager",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 26,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            Colors.transparent,
        foregroundColor: const Color(
          0xFF2D3436,
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // الجزء الخاص بإضافة تاسك جديدة
            _buildTaskInput(
              todoProvider,
            ),
            const SizedBox(height: 25),
            // أزرار التبديل بين الليست والجريد
            _buildViewToggle(),
            const SizedBox(height: 25),
            // عرض التاسكات (يا إما فاضية، يا ليست، يا جريد)
            Expanded(
              child:
                  todoProvider
                      .todos
                      .isEmpty
                  ? _buildEmptyState()
                  : isGridView
                  ? _buildGridView(
                      todoProvider,
                    )
                  : _buildListView(
                      todoProvider,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت إدخال النص
  Widget _buildTaskInput(
    TodoProvider provider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller:
                  _textFieldController,
              decoration: const InputDecoration(
                hintText:
                    "What needs to be done?",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                border:
                    InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_textFieldController
                  .text
                  .isNotEmpty) {
                provider.addTodo(
                  _textFieldController
                      .text,
                );
                _textFieldController
                    .clear();
              }
            },
            child: Container(
              margin:
                  const EdgeInsets.all(
                    8,
                  ),
              padding:
                  const EdgeInsets.all(
                    12,
                  ),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF6C5CE7,
                ),
                borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت أزرار التبديل
  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _buildTabButton(
            "List View",
            Icons
                .format_list_bulleted_rounded,
            !isGridView,
          ),
          _buildTabButton(
            "Grid View",
            Icons.grid_view_rounded,
            isGridView,
          ),
        ],
      ),
    );
  }

  // زرار التبديل الواحد
  Widget _buildTabButton(
    String title,
    IconData icon,
    bool isActive,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(
          () => isGridView =
              (title == "Grid View"),
        ),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 300,
          ),
          padding:
              const EdgeInsets.symmetric(
                vertical: 12,
              ),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(
                  12,
                ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors
                          .black
                          .withOpacity(
                            0.05,
                          ),
                      blurRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? const Color(
                        0xFF6C5CE7,
                      )
                    : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  color: isActive
                      ? const Color(
                          0xFF2D3436,
                        )
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بناء الليست
  Widget _buildListView(
    TodoProvider provider,
  ) {
    return ListView.builder(
      itemCount: provider.todos.length,
      itemBuilder: (context, index) =>
          _buildDismissibleItem(
            index,
            false,
            provider,
          ),
    );
  }

  // بناء الجريد
  Widget _buildGridView(
    TodoProvider provider,
  ) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
          ),
      itemCount: provider.todos.length,
      itemBuilder: (context, index) =>
          _buildDismissibleItem(
            index,
            true,
            provider,
          ),
    );
  }

  // العنصر القابل للسحب (المسح)
  Widget _buildDismissibleItem(
    int index,
    bool isGrid,
    TodoProvider provider,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isGrid ? 0 : 15,
      ),
      child: Dismissible(
        key:
            UniqueKey(), // مفتاح فريد لكل عنصر
        onDismissed: (direction) =>
            provider.deleteTodo(index),
        direction:
            DismissDirection.horizontal,
        background: Container(
          decoration: BoxDecoration(
            color: const Color(
              0xFFFF7675,
            ),
            borderRadius:
                BorderRadius.circular(
                  20,
                ),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.delete_sweep_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        child: _buildTodoCard(
          index,
          isGrid,
          provider,
        ),
      ),
    );
  }

  // كارت التاسك نفسه
  Widget _buildTodoCard(
    int index,
    bool isGrid,
    TodoProvider provider,
  ) {
    final item = provider.todos[index];
    return GestureDetector(
      onTap: () =>
          provider.toggleTodo(index),
      child: Container(
        width: double.infinity,
        // في الجريد: الطول لا نهائي عشان يملا المربع
        // في الليست: الطول null عشان ياخد حجم المحتوى
        height: isGrid
            ? double.infinity
            : null,
        padding: const EdgeInsets.all(
          20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          border: item.isDone
              ? Border.all(
                  color: Colors.green,
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(
                0,
                4,
              ),
            ),
          ],
        ),
        child: isGrid
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  Icon(
                    item.isDone
                        ? Icons
                              .check_circle_rounded
                        : Icons
                              .circle_outlined,
                    color: item.isDone
                        ? Colors.green
                        : const Color(
                            0xFF6C5CE7,
                          ),
                    size: 28,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight:
                          FontWeight
                              .w600,
                      fontSize: 16,
                      decoration:
                          item.isDone
                          ? TextDecoration
                                .lineThrough
                          : null,
                    ),
                    textAlign: TextAlign
                        .center,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                  ),
                ],
              )
            : Row(
                children: [
                  Icon(
                    item.isDone
                        ? Icons
                              .check_circle_rounded
                        : Icons
                              .circle_outlined,
                    color: item.isDone
                        ? Colors.green
                        : const Color(
                            0xFF6C5CE7,
                          ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight:
                            FontWeight
                                .w600,
                        fontSize: 17,
                        color:
                            const Color(
                              0xFF2D3436,
                            ),
                        decoration:
                            item.isDone
                            ? TextDecoration
                                  .lineThrough
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // الحالة لما تكون الليست فاضية
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          Icons.auto_awesome_motion,
          size: 80,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 15),
        Text(
          "Your task list is empty",
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}