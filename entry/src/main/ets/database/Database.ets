import { TodoInfo as Todo } from "../models/TodoInfo";

export interface Database {
  create(id: number, title: string, description: string, completed: boolean): Promise<void>
  read(id: number): Promise<Todo | null>
  update(id: number, title?: string, description?: string, completed?: boolean): Promise<void>
  delete(id: number): Promise<void>
  getAll(): Promise<Todo[]>
}