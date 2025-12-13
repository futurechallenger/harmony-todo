import { DatabaseFactory } from '../database/DatabaseFactory'
import { Todo } from '../models/Todo'
import { ValueType } from '@kit.ArkData'

export class TodoService {
  private static instance: TodoService | null = null
  private database = DatabaseFactory.getDatabase()

  static getInstance(): TodoService {
    if (TodoService.instance === null) {
      TodoService.instance = new TodoService()
    }
    return TodoService.instance
  }

  async createTodo(title: string, description: string): Promise<Todo> {
    try {
      // 找到最大的ID
      const todoCount = await this.database?.execute(
        `SELECT COUNT(1) AS count FROM todos`, 0, undefined
      )
      let newId = 0
      if (todoCount) {
        newId = todoCount.valueOf() as number + 1
      }

      // const todo = new Todo(newId, title, description, false)
      // await this.database?.insertSync()
      // CREATE TABLE IF NOT EXISTS todo (id INTEGER PRIMARY KEY, title TEXT, description TEXT, completed INTEGER, repr floatvector(2))
      const ret = await this.database?.execute(
        "INSERT INTO todo (id, title, description, completed) VALUES (?, ?, ?, ?);",
        0,
        [newId, title, description, 0]
      )

      console.log('>>>>db: create todo ret value: ', ret);

      return new Todo(newId, title, description, false)
    } catch (error) {
      console.error('>>>>db: create todo error: ', error)
      throw new Error(error.message)
    }
  }

  async getTodo(id: number): Promise<Todo | null> {
    // return await this.database.read(id)
    return null;
  }

  async updateTodo(id: number, title?: string, description?: string, completed?: boolean): Promise<void> {
    // await this.database.update(id, title, description, completed)
  }

  async deleteTodo(id: number): Promise<void> {
    // await this.database.delete(id)
  }

  async getAllTodos(): Promise<Todo[]> {
    const ret = await this.database?.querySql('select * from todo;')
    console.log('>>>db: get all todo ret: ', ret);
    return [];
  }
}