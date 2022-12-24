#다중상속

class Person:
    def sleep(self):
        print('잠을 잡니다.')

class Student(Person):
    def study(self):
        print('공부합니다.')
    def play(self):
        print('친구와 놉니다.')

class Worker(Person):
    def work(self):
        print('일합니다.')
    def play(self):
        print('술을 마십니다.')

class Arbeit(Student, Worker):
    def myjob(self):
        print('나는 아르바이트 학생입니다.')
        self.sleep()    #잠을 잡니다.
        self.play()     #메소드 탐색순서에 따라 Student의 play메소드가 호출됨
        self.study()    #공부합니다.
        self.work()     #일합니다.

a = Arbeit()
a.myjob()
