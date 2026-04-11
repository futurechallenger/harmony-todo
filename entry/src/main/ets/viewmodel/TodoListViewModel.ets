import { Type } from '@kit.ArkUI';
import { TodoListModel } from '../model/TodoListModel';
import { TodoViewModel } from './TodoViewModel';

@ObservedV2
export class TodoListViewModel {
  @Type(TodoViewModel)
  @Trace private _todoList: TodoViewModel[] = [];

  public get todoList(): TodoViewModel[] {
    return this._todoList;
  }

  public set todoList(value: TodoViewModel[]) {
    this._todoList = value;
  }

  async loadTodoList() {
    const todoListModel = new TodoListModel();
    todoListModel.loadTodoList();

    for (let todo of todoListModel.todos) {
      let todoViewModel = new TodoViewModel();
      todoViewModel.updateTodo(todo);
      this._todoList.push(todoViewModel);
    }
  }

  addTodo(todo: TodoViewModel) {
    // TODO: refactor to deal with sqlite
    this._todoList.push(todo);
  }

  removeTodo(todo: TodoViewModel) {
    // TODO: refactor to deal with sqlite
    this._todoList.splice(this._todoList.indexOf(todo), 1);
  }
}
