import { relationalStore } from '@kit.ArkData'
import { Database } from './Database'
// import { VectorDatabase } from './VectorDatabase'
// import { RelationalDatabase } from './RelationalDatabase'
import { deviceInfo } from '@kit.BasicServicesKit'

/**
 * TODO:
 * 1. REFACTOR: Support vector db first, then support relational db
 * 2. Take advantage of the new vector properties of the db
 */
export class DatabaseFactory {
  private static instance: relationalStore.RdbStore | null = null

  static getDatabase(): relationalStore.RdbStore | null {
    return DatabaseFactory.instance
  }

  static async init(context: Context): Promise<relationalStore.RdbStore | null> {
    return new Promise((resolve, reject) => {
      if (DatabaseFactory.instance === null) {
        if (relationalStore.isVectorSupported()) {
          console.log('Vector database is supported, using VectorDatabase')
          let store: relationalStore.RdbStore | undefined = undefined
          const STORE_CONFIG: relationalStore.StoreConfig = {
            name: 'TodoDb.db',
            securityLevel: relationalStore.SecurityLevel.S1,
            vector: true,
          }
          relationalStore.getRdbStore(context, STORE_CONFIG).then(async (rdbStore: relationalStore.RdbStore) => {
            DatabaseFactory.instance = rdbStore;
            console.log('========>>>db is initialized=======')

            // 建表语句，floatvector(2)代表repr的维度是2
            const SQL_CREATE_TABLE =
              'CREATE TABLE IF NOT EXISTS todo (id INTEGER PRIMARY KEY, title TEXT, description TEXT, completed INTEGER);';
            // 第二个入参表示不开启显示事务，第三个参数undefined表示未使用参数绑定
            const ret = await DatabaseFactory.instance!.execute(SQL_CREATE_TABLE, 0, undefined);
            console.log('=====>>>>create table ret: ', ret);

            const queryRet = await DatabaseFactory.instance!.querySql(
              `select count(1) from todo;`);

            let countValue = queryRet.goToRow(0) ? queryRet.getLong(0) : 0;
            console.log('===>>>>query todo count: ', countValue) // JSON.stringify(queryRet))
            queryRet.close()

            // const createTodo = await DatabaseFactory.instance!.execute(
            //   `INSERT INTO todo (id, title, description, completed) VALUES (${countValue === 0 ? 0 :
            //     ++countValue}, '111', '222', 0);`,
            //   0, undefined);

            // console.log('>>>>createTodo: ', createTodo);
            // const createTodo2 = await DatabaseFactory.instance!.execute(
            //   `INSERT INTO todo (id, title, description, completed) VALUES (${countValue === 0 ? 0 :
            //     ++countValue}, '222', '222333', 0);`,
            //   0, undefined);

            // console.log('>>>>createTodo: ', createTodo2);

            // const queryRet2 = await DatabaseFactory.instance!.querySql(
            // `INSERT INTO todo (id, title, description, completed) VALUES (?, ?, ?, ?);`,
            // [1, '111', '222', 0]);
            // `INSERT INTO todo (id, title, description, completed) VALUES (1, '111', '222', 0);`);
            // `select * from todo;`);
            // console.log('>>>>createdTodo: ', createdTodo);
            // while (queryRet2.goToNextRow()) {
            //   let id = queryRet2.getValue(0)
            //   let title = queryRet2.getValue(1)
            //   let description = queryRet2.getValue(2)
            //   let completed = queryRet2.getValue(3)
            //
            //   console.log('>>>>query todo: ', id, title, description, completed)
            // }
            // queryRet2.close()
            //
            // console.log('>>>>query todo count: ', JSON.stringify(queryRet2))
          }).catch((error: BusinessError) => {
            console.log('>>>>SQL Error: ', error)
            console.error(`Get RdbStore failed, code is ${error.code}, message is ${error.message}`);
            reject(error)
          });
        } else {
          // TODO: Refactor to support non-vector database instance
          console.log('Vector database is not supported, using RelationalDatabase')
          // DatabaseFactory.instance = new RelationalDatabase()
        }
      }

      resolve(DatabaseFactory.instance)
    })
  }


  static resetInstance(): void {
    DatabaseFactory.instance = null
  }
}