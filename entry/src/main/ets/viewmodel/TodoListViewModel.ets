import { Type } from '@kit.ArkUI';
import { TodoListModel } from '../model/TodoListModel';
import { TodoModel } from '../model/TodoModel';
import { TodoViewModel } from './TodoViewModel';

@ObservedV2
export class TodoListViewModel {
  @Trace todoList: TodoViewModel[] = [];
  private _todoListModel?: TodoListModel

  constructor(context?: Context) {
    this._todoListModel = new TodoListModel(context);
  }

  async loadTodoList() {
    console.log('>>>>TodoListViewModel > loadTodoList')
    if (!this._todoListModel) {
      throw new Error('TodoListModel is not initialized');
    }


    await this._todoListModel.loadTodoList();
    console.log('>>>>TodoListViewModel > loadTodoList', this._todoListModel?.todos?.length);

    for (let todo of this._todoListModel.todos) {
      let todoViewModel = new TodoViewModel(todo);
      this.todoList.push(todoViewModel);
    }
  }

  async addTodo(title: string, description: string = '') {
    // TODO: refactor to deal with sqlite
    try {
      const todo: TodoModel = new TodoModel({ title, description });
      await this._todoListModel?.addTodo(todo);
      this.todoList.push(new TodoViewModel(todo));
    } catch (err) {

    }
  }

  removeTodo(todo: TodoViewModel) {
    // TODO: refactor to deal with sqlite
    try {
      this._todoListModel?.deleteTodo(todo.toModel());
      this.todoList.splice(this.todoList.indexOf(todo), 1);
    } catch (err) {

    }
  }
}
