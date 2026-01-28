import { CommonConstants } from '../libs/Constants'

export interface TodoInfoType {
  id: number
  title: string
  description: string
  completed: number
  version: number;
}

export class TodoInfo {
  private id?: number
  private title: string
  private description: string
  private completed: number
  private version: number;

  constructor() {
    this.id = undefined;
    this.title = CommonConstants.EMPTY_STRING;
    this.description = CommonConstants.EMPTY_STRING;
    this.completed = 0;
    this.version = 0;
  }

  init(id: number, title: string, description: string, completed: number, version: number) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.completed = completed;
    this.version = version;

    return this;
  }

  public getID(): number | undefined {
    return this.id;
  }

  public setID(id: number) {
    this.id = id;
  }

  public getTitle(): string {
    return this.title;
  }

  public setTitle(title: string) {
    this.title = title;
  }

  public getDescription(): string {
    return this.description;
  }

  public setDescription(description: string) {
    this.description = description;
  }

  public getCompleted(): boolean {
    return this.completed === 1;
  }

  public setCompleted(completed: boolean | number) {
    if (typeof completed === 'number') {
      this.completed = completed
    } else {
      this.completed = !completed ? 0 : 1;
    }
  }

  public getVersion(): number {
    return this.version;
  }

  public setVersion(version: number) {
    this.version = version;
  }
}