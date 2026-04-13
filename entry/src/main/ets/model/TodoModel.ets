import { AppStorageV2 } from '@kit.ArkUI';
import { TodoRepository } from "../libs/repository";

interface TodoModelType {
  id: number;
  title: string;
  description: string;
  completed: boolean | number;
  version: number;
  createdAt: number;
  updatedAt: number;
}

// model/TodoModel.ets
export class TodoModel {
  private _repo?: TodoRepository = AppStorageV2.connect(TodoRepository);
  id: number = 0; // 主键
  title: string = ''; // 标题
  description: string = ''; // 描述
  completed: boolean = false; // 完成状态
  version: number = 0; // 版本（用于乐观锁）
  createdAt: number = Date.now(); // 创建时间
  updatedAt: number = Date.now(); // 更新时间


  constructor(data?: Partial<TodoModelType>) {
    this.id = data?.id ?? 0;
    this.title = data?.title ?? '';
    this.description = data?.description ?? '';
    this.completed = !!data?.completed;
    this.version = data?.version ?? 0;
    this.createdAt = data?.createdAt ?? Date.now();
    this.updatedAt = data?.updatedAt ?? Date.now();
  }

  // 转换为普通对象（用于存储）
  toPlainObject(): TodoModelType {
    return {
      id: this.id,
      title: this.title,
      description: this.description,
      completed: this.completed ? 1 : 0, // SQLite 存储布尔值为整数
      version: this.version,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }

  // 从数据库记录创建实例
  static fromDatabase(record: TodoModelType): TodoModel {
    return new TodoModel({
      id: record.id,
      title: record.title,
      description: record.description,
      completed: !!record.completed, // 转换回布尔值
      version: record.version,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt
    });
  }

  async save() {
    await this._repo!.insert(this);
  }

  async delete(id: number) {
    await this._repo!.deleteTodo(id)
  }
}