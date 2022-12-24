#강제로 오류 발생 시키기

class Bird:
    def fly(self):
        raise NotImplementedError

class Eagle(Bird): #Bird 클래스를 상속 받은 Eagle 클래스 만들기
    pass
    #def fly(self):
        #print("very fast")

eagle=Eagle()
eagle.fly()  #Bird의 함수 fly가 호출되어 raise 명령어로 인해 위에 오류기가 출력됨



