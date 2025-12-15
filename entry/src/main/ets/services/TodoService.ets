import { DatabaseFactory } from '../database/DatabaseFactory'
import { TodoInfo } from '../models/TodoInfo'
import { ValueType } from '@kit.ArkData'

export class TodoService {
  private static instance: TodoService | null = null
  private database = DatabaseFactory.getDatabase()

  constructor() {
    console.log('===>>>>TodoService: constructor, database start initializing')
    this.database = DatabaseFactory.getDatabase()
    // console.log('====>>>>TodoService: constructor, database initialized', this.database!.version)
  }

  static getInstance(): TodoService {
    console.log('===>>>TodoService: getInstance')
    if (TodoService.instance === null) {
      console.log('===>>>TodoService: getInstance > initializing')
      TodoService.instance = new TodoService()
    }
    return TodoService.instance
  }

  async createTodo(title: string, description: string): Promise<TodoInfo> {
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

      console.log('===>>>>db: create todo ret value: ', ret);

      const newTodo = new TodoInfo();
      newTodo.init(newId, title, description, 0)

      return newTodo
    } catch (error) {
      console.error('====>>>>db: create todo error: ', error)
      throw new Error(error.message)
    }
  }

  async getTodo(id: number): Promise<TodoInfo | null> {
    // return await this.database.read(id)
    return null;
  }

  async updateTodo(id: number, title?: string, description?: string, completed?: boolean): Promise<void> {
    // await this.database.update(id, title, description, completed)
  }

  async deleteTodo(id: number): Promise<void> {
    // await this.database.delete(id)
  }

  async getAllTodos(): Promise<TodoInfo[]> {
    console.log('>>>>>TodoService: getAllTodos')
    if (!this.database) {
      console.log('=====>>>>>TodoService: getAllTodos > database is null')
      return [];
    }

    try {
      const ret = await this.database!.querySql('select * from todo;')
      const todos: TodoInfo[] = []

      if (!ret) {
        return todos;
      }

      while (ret.goToNextRow()) {
        let id = ret.getValue(0) as number
        let title = ret.getValue(1) as string
        let description = ret.getValue(2) as string
        let completed = ret.getValue(3) as number

        // console.log('>>>>ROW: query todo > ', id, title, description, completed)
        const newTodo = new TodoInfo();
        newTodo.init(id, title, description, completed)
        todos.push(newTodo)
      }

      console.log('>>>>>TodoService: getAllTodos', todos)

      return todos;
    } catch (error) {
      console.error('>>>>db: get all todo error: ', error)
      throw new Error('Query todo list failed')
    }
  }
}