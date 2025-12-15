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

/**
 * Common constants for all features.
 */
export class CommonConstants {
  /**
   * SQL statement for creating a todo table.
   */
  static readonly SQL_CREATE_TODO_TABLE: string = 'CREATE TABLE IF NOT EXISTS todo_info (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, completed INTEGER)';
  /**
   * SQL statement for initializing todo tables.
   */
  static readonly SQL_INSERT_TODO_TABLE: string = 'INSERT INTO todo_info VALUES (?, ?, ?, ?)';
  /**
   * SQL statement for querying todo tables.
   */
  static readonly SQL_QUERY_TODO_TABLE: string = 'SELECT * FROM todo_info WHERE id = ?';
  /**
   * SQL statement for querying all todo info .
   */
  static readonly SQL_QUERY_ALL_TODO_TABLE: string = 'SELECT * FROM todo_info';
  /**
   * String that empty.
   */
  static readonly EMPTY_STRING: string = '';
  /**
   * Maximum value of the progress bar.
   */
  static readonly PROGRESS_MAX: number = 100;
  /**
   * Progress bar step.
   */
  static readonly PROGRESS_STEP: number = 20;
  /**
   * String that 100%.
   */
  static readonly PERCENT_WIDTH: string = '100%';
  /**
   * String that 90%.
   */
  static readonly PERCENT_NINETY_WIDTH: string = '90%';
  /**
   * Number for 100.
   */
  static readonly NUMBER_100: number = 100;
  /**
   * Number for 400.
   */
  static readonly NUMBER_400: number = 400;
  /**
   * Number for 500.
   */
  static readonly NUMBER_500: number = 500;
  /**
   * String for init name.
   */
  static readonly INIT_NAME: string = 'developer1';
}