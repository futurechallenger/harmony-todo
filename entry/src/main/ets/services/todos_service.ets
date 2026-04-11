import axios, { AxiosResponse } from '@ohos/axios'
import { ResponseData } from '../libs/create_request';
import { TodoModel, TodoModelType } from '../model/TodoModel';

export async function fetchData(): Promise<TodoModel[] | undefined> {
  const response: AxiosResponse<ResponseData<TodoModelType[] | null>> =
    await axios.get<ResponseData<TodoModelType[] | null>, AxiosResponse<ResponseData<TodoModelType[] | null>>, null>('http://192.168.31.109:17788/list/all')
  const todos: TodoModel[] = [] as TodoModel[]
  (response.data?.data || [] as TodoModelType[]).forEach((item: TodoModelType) => {
    const todo =
      new TodoModel().init(item?.id || 0, item.title, item.description, item?.completed || 0, item?.version || 0);
    todos.push(todo)
  })

  return todos;
}