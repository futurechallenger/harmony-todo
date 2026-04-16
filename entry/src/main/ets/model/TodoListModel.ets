import { TodoModel } from './TodoModel';
import { TodoRepository } from '../libs/repository';

export class TodoListModel {
  private _todos: TodoModel[] = [];
  private _repo?: TodoRepository;
  private _context?: Context;

  constructor(context?: Context) {
    this._context = context;
  }

  get todos(): TodoModel[] {
    return this._todos;
  }

  set todos(todos: TodoModel[]) {
    this._todos = todos;
  }

  async loadTodoList() {
    if (!this._repo) {
      this._repo = await TodoRepository.getInstance(this._context)
    }

    const todoList = await this._repo?.queryAll()
    this._todos = todoList ?? []
  }

  async addTodo(todo: TodoModel) {
    // TODO: load data from sqlite
    if (!this._repo) {
      this._repo = await TodoRepository.getInstance(this._context)
    }
    this._repo?.insert(todo)
  }

  async updateTodo(todo: TodoModel) {
    if (!this._repo) {
      this._repo = await TodoRepository.getInstance(this._context)
    }
    this._repo?.updateStatus(todo)
  }

  async deleteTodo(todo: TodoModel) {
    if (!this._repo) {
      this._repo = await TodoRepository.getInstance(this._context)
    }
    this._repo?.deleteTodo(todo.id)
  }
}