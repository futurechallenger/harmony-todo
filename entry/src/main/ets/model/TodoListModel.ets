import {TodoModel} from './TodoModel';

export class TodoListModel {
  private _todos: TodoModel[] = [];

  get todos(): TodoModel[] {
    return this._todos;
  }

  set todos(todos: TodoModel[]) {
    this._todos = todos;
  }

  async loadTodoList() {
    // TODO: load data from sqlite
    this._todos = []
  }
}