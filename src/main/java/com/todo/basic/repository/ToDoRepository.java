package com.todo.basic.repository;

import com.todo.basic.entity.Todo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ToDoRepository extends JpaRepository<Todo, Long> {
}
