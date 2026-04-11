import { TodoModel } from '../model/TodoModel'

@ObservedV2
export class TodoViewModel {
  @Trace private title?: string;
  @Trace private description?: string;
  @Trace private isCompleted?: boolean;

  updateTodo(todo: TodoModel) {
    this.title = todo.getTitle();
    this.description = todo.getDescription();
    this.isCompleted = todo.getCompleted();
  }

  updateIsCompleted(completed: boolean) {
    this.isCompleted = completed;
  }
}
