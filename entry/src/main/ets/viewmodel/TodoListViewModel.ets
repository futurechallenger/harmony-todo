import { Type } from '@kit.ArkUI';
import { TodoListModel } from '../model/TodoListModel';
import { TodoModel } from '../model/TodoModel';
import { TodoViewModel } from './TodoViewModel';

@ObservedV2
export class TodoListViewModel {
  // @Type(TodoViewModel)
  @Trace todoList: TodoViewModel[] = [];
  private _todoListModel: TodoListModel = new TodoListModel();


  async loadTodoList() {
    this._todoListModel.loadTodoList();

    for (let todo of this._todoListModel.todos) {
      let todoViewModel = new TodoViewModel(todo);
      this.todoList.push(todoViewModel);
    }
  }

  async addTodo(title: string, description: string = '') {
    // TODO: refactor to deal with sqlite
    try {
      const todo: TodoModel = new TodoModel({ title, description });
      this._todoListModel.addTodo(todo);
      this.todoList.push(new TodoViewModel(todo));
    } catch (err) {

    }
  }

  removeTodo(todo: TodoViewModel) {
    // TODO: refactor to deal with sqlite
    try{
      const todoModel = new TodoModel();
      todoModel.delete(todo.id);
      this.todoList.splice(this.todoList.indexOf(todo), 1);
    } catch(err) {

    }
  }
}
