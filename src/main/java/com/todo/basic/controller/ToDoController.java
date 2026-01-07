package com.todo.basic.controller;

import com.todo.basic.entity.Todo;
import com.todo.basic.service.ToDoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/todos")
public class ToDoController {

  private final ToDoService toDoService;

  public ToDoController(ToDoService toDoService) {
    this.toDoService = toDoService;
  }

  @GetMapping
  public ResponseEntity<List<Todo>> getTodos() {
    return new ResponseEntity<>(toDoService.getAllTodos(), HttpStatus.OK);
  }

  @PostMapping
  public ResponseEntity<Todo> createTodo(@RequestParam String title) {
    return new ResponseEntity<>(toDoService.createTodo(title), HttpStatus.CREATED);
  }

  @PutMapping("/{id}/update")
  public ResponseEntity<Object> updateTodo(@PathVariable("id") long id,
                                           @RequestParam(name = "title") String updatedTitle) {
    return toDoService.updateTodo(id, updatedTitle);
  }

  @DeleteMapping("/{id}/delete")
  public ResponseEntity<Object> deleteTodo(@PathVariable("id") long id) {
    return toDoService.deleteTodo(id);
  }

  @PutMapping("/{id}/isCompleted")
  public ResponseEntity<Object> updateTodoStatus(@PathVariable("id") long id) {
    return toDoService.updateTodoStatus(id);
  }
}
