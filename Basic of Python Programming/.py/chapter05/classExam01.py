#class 만들기


class FourCal:
    def __init__(self, first, second):
        self.first=first
        self.second=second
                            #setdata는 초기값을 설정하는 메서드
    def add(self):
        result=self.first+self.second
        return result

    def sub(self):
        result=self.first-self.second
        return  result

    def mul(self):
        result=self.first*self.second
        return result

    def div(self):
        result=self.first/self.second
        return result


# a=FourCal(4,2)
# print(a.add())
# print(a.first)
# print(a.second)
#
# b=FourCal(3,7)
# print("div:%.1f" %b.div())


class MoreFourCal(FourCal):
    pass
a=MoreFourCal(4,2)
print(a.add())


class MoreFourCal(FourCal):
    def pow(self):
        result=self.first**self.second
        return result

class SafeFourCal(FourCal):
    def div(self):
        if self.second==0:
            return 0
        else:
            return self.first/self.second
#만약에 second가 0이면 그냥 0으로 돌려주고 0이 아니면 div(나누기) 그대로 간다.
#fourcal에 있는 기존 div함수를 덮어쓰기함 = '메서드 오버라이딩'

a=SafeFourCal(4,0)
print(a.div())
print(a.add())  #FourCal클래스에 있는 함수들 다 사용 가능

a=MoreFourCal(4,0)
print(a.add())
print(a.sub())
print("pow:",a.pow())
# print(a.div()) #4/0을 하니 오류가 발생 따라서 위애 safefourcal 클래스를 새로 만듦


class FailFourCal(FourCal):
    def mul(self):
        if self.second==0:
            return "Fail"
        else:
            return self.first*self.second

b=FailFourCal(4,0)
print(b.mul())



'''
a=FourCal(4,2)

print("add:", a.add())
print("sub:", a.sub())
print("mul:", a.mul())
print("div", a.div())

b=FourCal(4,7)

print("add:", b.add())
print("sub:", b.sub())
print("mul:", b.mul())
print("div:%.1f" %b.div()) '''

