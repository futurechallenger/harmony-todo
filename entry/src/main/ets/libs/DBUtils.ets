/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { relationalStore } from '@kit.ArkData';
import { BusinessError } from "@kit.BasicServicesKit";
import { TodoInfo } from '../models/TodoInfo'
import { CommonConstants } from './Constants'
import Logger from './Logger';

// const uiContext: UIContext | undefined = AppStorage.get('uiContext'); // TODO: do some research about this
const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'TodoDb.db',
  securityLevel: relationalStore.SecurityLevel.S1,
  vector: false,
};

export class DBUtils {
  private store: relationalStore.RdbStore | undefined = undefined;
  private context: UIContext | undefined = undefined;

  constructor(context: UIContext) {
    this.context = context;
  }

  /**
   * Creating a User Table.
   */
  async createDB(): Promise<void> {
    try {
      // STORE_CONFIG.vector = relationalStore.isVectorSupported();
      const database = await relationalStore.getRdbStore(this.context!.getHostContext(), STORE_CONFIG)

      if (!database) {
        // throw new Error('Create store failed')
        return undefined
      }

      this.store = database

      await (database as relationalStore.RdbStore).executeSql(CommonConstants.SQL_CREATE_TODO_TABLE, null)

      Logger.info('====>>>create table done.');
    } catch (error) {
      Logger.error(`=====>>>>ExecuteSql failed, code is: ${error.code},message is: ${error.message}`);
    }
  }

  /**
   * Initializing User Table Data.
   */
  async insertData(title: string, description: string) {
    console.log('=====>>>inserting data')

    try {

      const database = await relationalStore.getRdbStore(this.context!.getHostContext(), STORE_CONFIG)
      if (database) {
        this.store = database
      }

      await (this.store as relationalStore.RdbStore).executeSql(CommonConstants.SQL_INSERT_TODO_TABLE,
        [null, title, description, 0])
      Logger.info('insert data table done.');
    } catch (error) {
      Logger.error(`===>>>ExecuteSql failed, code is ${error.code},message is ${error.message}`);
    }
  }

  /**
   * Querying User Table Information.
   */
  async queryData(): Promise<TodoInfo[]> {
    if (!this.store) {
      console.log('=====>>>store is undefined')
      const database = await relationalStore.getRdbStore(this.context!.getHostContext(), STORE_CONFIG)
      if (database) {
        this.store = database
      }
      console.log('=====>>>store is set')
    }

    const todoList: TodoInfo[] = [];

    try {
      console.log('=====>>>queryData')
      // const database = await relationalStore.getRdbStore(this.context!.getHostContext(), STORE_CONFIG);
      // if (database) {
      //   this.store = database;
      // }

      const resultSet =
        await (this.store as relationalStore.RdbStore).querySql(CommonConstants.SQL_QUERY_ALL_TODO_TABLE)

      Logger.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}, row count: ${resultSet.rowCount}`);

      while (resultSet.goToNextRow()) {
        const todo = new TodoInfo()
        let id = resultSet.getLong(resultSet.getColumnIndex("id"));
        todo.setID(id);
        let title = '';
        let description = ''
        let completed = 0;
        try {
          title = resultSet.getString(resultSet.getColumnIndex('title'));
          todo.setTitle(title);
          description = resultSet.getString(resultSet.getColumnIndex('description'));
          todo.setDescription(description)
          completed = resultSet.getLong(resultSet.getColumnIndex('completed'));
          todo.setCompleted(completed)

          todoList.push(todo)
        } catch (error) {
          Logger.error(`ExecuteSql failed, code is ${error.code},message is ${error.message}`);
          resultSet.close();
        }
      }

      resultSet.close();
      console.log('=====>>>todoList loaded', todoList.length)
      return todoList;
    } catch (error) {
      Logger.error(`Query failed, code is ${error.code},message is ${error.message}`);
      return [];
    }
  }

  /**
   * Modifying the User Table Information.
   */
  updateData(id: number, columnNames: string[], values: string | boolean[]) {
    if (columnNames.length === 0 || values.length === 0) {
      throw new Error('columnNames or values is empty')
    }

    const updateStatement = 'UPDATE todo_info SET ' + columnNames.map((columnName, index) => {
      return `${columnName} = '${values[index]}'`
    }).join(', ') + ` WHERE id = ${id}}`

    if (this.store !== undefined) {
      (this.store as relationalStore.RdbStore).executeSql(updateStatement)
        .then(() => {
          Logger.info('update data done.');
        })
        .catch((err: BusinessError) => {
          Logger.error(`ExecuteSql failed, code is ${err.code},message is ${err.message}`);
        })
    }
  }

  /**
   * Used for database transactional rollback.
   */
  rollback() {
    if (this.store !== undefined) {
      try {
        this.store.rollBack();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error('rollBack failed,' + ` code is ${err.code}, message is ${err.message}`);
      }
    }
  }

  /**
   * Used to commit database transactions.
   */
  commit() {
    if (this.store !== undefined) {
      try {
        this.store.commit();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error('commit failed,' + ` code is ${err.code}, message is ${err.message}`);
      }
    }
  }

  /**
   * Modifying the User Table Structure.
   */
  async updateTable(index: number, content: string) {
    // let updateTableSql = "alter table todo_info add column " +
    // COLUMN_TYPE_MAP[index][0] + " " + COLUMN_TYPE_MAP[index][1];
    // if (store !== undefined) {
    //   try {
    //     store.beginTransaction();
    //   } catch (error) {
    //     let err = error as BusinessError;
    //     Logger.error('beginTransaction failed,' + ` code is ${err.code}, message is ${err.message}`);
    //   }
    //   (store as relationalStore.RdbStore).executeSql(updateTableSql, (err) => {
    //     if (err) {
    //       Logger.error(`ExecuteSql failed, code is ${err.code},message is ${err.message}`);
    //       return;
    //     }
    //     Logger.info('update table done.');
    //     // this.updateData(index, content);
    //   })
    // }
  }

  /**
   * Modifying the User Table Information.
   */
  async backup(callback: () => void) {
    if (this.store !== undefined) {
      (this.store as relationalStore.RdbStore).backup('dbBackup.db', (err) => {
        if (err) {
          Logger.error(`Failed to backup data. Code:${err.code},message:${err.message}`);
          return;
        }
        Logger.info('Succeeded in backing up data.');
        callback();
      })
    }
  }

  /**
   * Modifying the User Table Information.
   */
  async restore(callback: () => void) {
    if (this.store !== undefined) {
      (this.store as relationalStore.RdbStore).restore('dbBackup.db', (err) => {
        if (err) {
          Logger.error(`Failed to restore data. Code:${err.code},message:${err.message}`);
          return;
        }
        Logger.info('Succeeded in restoring data.');
        callback();
      })
    }
  }
}
