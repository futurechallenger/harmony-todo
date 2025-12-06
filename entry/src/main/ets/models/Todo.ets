export class Todo {
  private id: number;
  private title: string;
  private  description: string;
  private completed: boolean;

  constructor(id: number, title: string, description: string, completed: boolean) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.completed = completed;
  }

  public getID(): number {
    return this.id;
  }

  public getTitle(): string {
    return this.title;
  }

  public getDescription(): string {
    return this.description;
  }

  public getCompleted(): boolean {
    return this.completed;
  }
}