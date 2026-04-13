import localUnitTest from './LocalUnit.test';
import todoModelTest from './TodoModel.test';

export default function testsuite() {
  localUnitTest();
  todoModelTest();
}