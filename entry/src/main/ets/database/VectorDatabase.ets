// import { Database } from './Database'
// import { Todo } from '../models/Todo'
//
// export class VectorDatabase implements Database {
//   private todos: Map<number, Todo> = new Map()
//   private nextId: number = 1
//
//   async create(title: string, description: string, completed: boolean): Promise<void> {
//     const id = this.nextId++
//     const todo = new Todo(id, title, description, completed)
//     this.todos.set(id, todo)
//     console.log(`VectorDatabase: Created todo with id ${id}`)
//   }
//
//   async read(id: number): Promise<Todo | null> {
//     const todo = this.todos.get(id)
//     return todo || null
//   }
//
//   async update(id: number, title?: string, description?: string, completed?: boolean): Promise<void> {
//     const todo = this.todos.get(id)
//     if (todo) {
//       if (title !== undefined) todo.title = title
//       if (description !== undefined) todo.description = description
//       if (completed !== undefined) todo.completed = completed
//       console.log(`VectorDatabase: Updated todo with id ${id}`)
//     }
//   }
//
//   async delete(id: number): Promise<void> {
//     const deleted = this.todos.delete(id)
//     if (deleted) {
//       console.log(`VectorDatabase: Deleted todo with id ${id}`)
//     }
//   }
//
//   async getAll(): Promise<Todo[]> {
//     return Array.from(this.todos.values())
//   }
// }