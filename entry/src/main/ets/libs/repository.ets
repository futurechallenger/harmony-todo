import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit' // 明确导入 Context 类型
import { TodoModel } from '../model/TodoModel'

export const DB_NAME = 'todo_db.db'

export const DB_VERSION = 1

export const CREATE_TABLE_SQL = `
  CREATE TABLE IF NOT EXISTS todo_info (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    completed INTEGER DEFAULT 0,
    version INTEGER DEFAULT 1,
    createdAt INTEGER,
    updatedAt INTEGER
  )
`

export const STORE_CONFIG: relationalStore.StoreConfig = {
  name: DB_NAME,
  securityLevel: relationalStore.SecurityLevel.S1
}

export class TodoRepository {
  private static instance: TodoRepository
  private rdbStore: relationalStore.RdbStore | null = null
  private context: Context | null = null

  // 修改：要求传入 Context
  static async getInstance(context?: Context): Promise<TodoRepository> {
    if (!TodoRepository.instance) {
      if (!context) {
        throw new Error('Context must be provided for first initialization')
      }
      TodoRepository.instance = new TodoRepository()
      await TodoRepository.instance.init(context)
    }
    return TodoRepository.instance
  }

  // 修改：通过参数接收，不再调用 getContext()
  private async init(context: Context): Promise<void> {
    this.context = context
    this.rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG)
    await this.rdbStore.executeSql(CREATE_TABLE_SQL)
  }

  // ... 其他 CRUD 方法保持不变，使用 this.rdbStore
  async queryAll(): Promise<TodoModel[]> {
    if (!this.rdbStore) {
      this.rdbStore = await relationalStore.getRdbStore(this.context!, STORE_CONFIG)
    }

    // ... 查询逻辑
    const resultSet = await this.rdbStore.querySql('SELECT * FROM todo_info ORDER BY createdAt DESC')
    const list: TodoModel[] = []
    while (resultSet.goToNextRow()) {
      const todo = new TodoModel()
      todo.id = resultSet.getLong(resultSet.getColumnIndex('id'))
      todo.title = resultSet.getString(resultSet.getColumnIndex('title'))
      todo.description = resultSet.getString(resultSet.getColumnIndex('description'))
      todo.completed = resultSet.getLong(resultSet.getColumnIndex('completed')) === 1
      todo.createdAt = resultSet.getDouble(resultSet.getColumnIndex('createdAt'))
      todo.updatedAt = resultSet.getDouble(resultSet.getColumnIndex('updatedAt'))

      list.push(todo)
    }
    resultSet.close()
    return list
  }

  async getTodoById(id: number): Promise<TodoModel | null> {
    if (!this.rdbStore) {
      this.rdbStore = await relationalStore.getRdbStore(this.context!, STORE_CONFIG)
    }

    const predicates = new relationalStore.RdbPredicates('todo');
    predicates.equalTo('id', id);

    const columns = ['id', 'title', 'description', 'completed', 'version', 'createdAt', 'updatedAt'];
    const result = await this.rdbStore.query(predicates, columns);

    if (result.goToNextRow()) {
      const todo = TodoModel.fromDatabase({
        id: result.getDouble(result.getColumnIndex('id')),
        title: result.getString(result.getColumnIndex('title')),
        description: result.getString(result.getColumnIndex('description')),
        completed: result.getDouble(result.getColumnIndex('completed')),
        version: result.getDouble(result.getColumnIndex('version')),
        createdAt: result.getDouble(result.getColumnIndex('createdAt')),
        updatedAt: result.getDouble(result.getColumnIndex('updatedAt'))
      });
      result.close();
      return todo;
    }

    result.close();
    return null;
  }

  async insert(todo: TodoModel): Promise<void> {
    if (!this.rdbStore) {
      this.rdbStore = await relationalStore.getRdbStore(this.context!, STORE_CONFIG)
    }

    const valueBucket: ValuesBucket = {
      // id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed ? 1 : 0,
      createdAt: todo.createdAt
    }
    await this.rdbStore.insert('todo_info', valueBucket)
  }

  async updateStatus(todo: TodoModel): Promise<void> {
    const updateStatement = 'UPDATE todo_info SET ' + todo.toKeyValuePairs() + ` WHERE id = ${todo.id}}`

    if (!this.rdbStore) {
      this.rdbStore = await relationalStore.getRdbStore(this.context!, STORE_CONFIG)
    }

    await this.rdbStore.executeSql(updateStatement)
  }

  async deleteTodo(id: number): Promise<boolean> {
    if (!this.rdbStore) {
      throw new Error('数据库未初始化');
    }

    const predicates = new relationalStore.RdbPredicates('todo_info');
    predicates.equalTo('id', id);

    const affectedRows = await this.rdbStore.delete(predicates);
    return affectedRows > 0;
  }
}