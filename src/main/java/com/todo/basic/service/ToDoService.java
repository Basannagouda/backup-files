package com.todo.basic.service;

import com.todo.basic.entity.Todo;
import com.todo.basic.repository.ToDoRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ToDoService {

  private final ToDoRepository toDoRepository;

  public ToDoService(ToDoRepository toDoRepository) {
    this.toDoRepository = toDoRepository;
  }

  public List<Todo> getAllTodos() {
    return toDoRepository.findAll();
  }

  public Todo createTodo(String title) {
    Todo todo = new Todo();
    todo.setTitle(title);
    todo.setIsCompleted(false);
    return toDoRepository.save(todo);
  }

  public ResponseEntity<Object> updateTodo(long id, String updatedTitle) {
    Optional<Todo> existing = toDoRepository.findById(id);
    if (existing.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    Todo todo = existing.get();
    if (updatedTitle != null && updatedTitle.equals(todo.getTitle())) {
      return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }
    todo.setTitle(updatedTitle);
    toDoRepository.save(todo);
    return new ResponseEntity<>(HttpStatus.OK);
  }

  public ResponseEntity<Object> deleteTodo(long id) {
    Optional<Todo> existing = toDoRepository.findById(id);
    if (existing.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    toDoRepository.deleteById(id);
    return new ResponseEntity<>(HttpStatus.OK);
  }

  public ResponseEntity<Object> updateTodoStatus(long id) {
    Optional<Todo> existing = toDoRepository.findById(id);
    if (existing.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    Todo todo = existing.get();
    if (Boolean.TRUE.equals(todo.getIsCompleted())) {
      return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }
    todo.setIsCompleted(true);
    toDoRepository.save(todo);
    return new ResponseEntity<>(HttpStatus.OK);
  }
}
