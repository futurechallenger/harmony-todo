import { TodoModel } from './TodoModel';
import { AppStorageV2 } from '@kit.ArkUI';
import { TodoRepository } from '../libs/repository';

export class TodoListModel {
  private _todos: TodoModel[] = [];
  private _repo = AppStorageV2.connect(TodoRepository);

  get todos(): TodoModel[] {
    return this._todos;
  }

  set todos(todos: TodoModel[]) {
    this._todos = todos;
  }

  async loadTodoList() {
    const todoList  = await this._repo?.queryAll()
    this._todos = todoList ?? []
  }

  async addTodo(todo: TodoModel) {
    // TODO: load data from sqlite
    this._repo?.insert(todo)
  }
}