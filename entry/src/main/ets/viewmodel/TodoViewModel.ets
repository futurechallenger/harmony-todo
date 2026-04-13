import { TodoModel } from '../model/TodoModel'

@ObservedV2
export class TodoViewModel {
  id: number = 0;
  createdAt: number = Date.now();
  updatedAt: number = Date.now();
  @Trace title: string = ''; // 标题
  @Trace description: string = ''; // 描述
  @Trace completed: boolean = false; // 完成状态
  @Trace version: number = 0; // 版本（用于乐观锁）

  constructor(todo: TodoModel) {
    this.fromModel(todo)
  }

  fromModel(todo: TodoModel) {
    this.title = todo.title;
    this.description = todo.description;
    this.completed = todo.completed;
  }

  toModel(): TodoModel {
    return new TodoModel({
      id: this.id,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      title: this.title,
      description: this.description,
      completed: this.completed,
      version: this.version,
    });
  }

  // updateTodo(todo: TodoModel) {
  //   this.title = todo.title;
  //   this.description = todo.description;
  //   this.completed = todo.completed;
  // }

  //
  // updateIsCompleted(completed: boolean) {
  //   this._isCompleted = completed;
  // }
}
