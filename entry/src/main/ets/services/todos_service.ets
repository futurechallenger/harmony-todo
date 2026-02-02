import axios, { AxiosResponse } from '@ohos/axios'
import { ResponseData } from '../libs/create_request';
import { TodoInfo, TodoInfoType } from '../models/TodoInfo';

export async function fetchData(): Promise<TodoInfo[] | undefined> {
  const response: AxiosResponse<ResponseData<TodoInfoType[] | null>> =
    await axios.get<ResponseData<TodoInfoType[] | null>, AxiosResponse<ResponseData<TodoInfoType[] | null>>, null>('http://192.168.31.109:17788/list/all')
  const todos: TodoInfo[] = [] as TodoInfo[]
  (response.data?.data || [] as TodoInfoType[]).forEach((item: TodoInfoType) => {
    const todo =
      new TodoInfo().init(item?.id || 0, item.title, item.description, item?.completed || 0, item?.version || 0);
    todos.push(todo)
  })

  return todos;
}