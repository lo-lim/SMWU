#연습문제 1

class Calculator:
    def __init__(self):
        # value=0
        self.value=0
    def add(self, val):
            self.value+=val  #self.value=self.value+val

class UpgradeCalculator(Calculator):
    def minus(self, val):
        self.value-=val

cal=UpgradeCalculator()
cal.add(10)
cal.minus(7)
print(cal.value)  #초기값 0+10에서 -7을 한 값인 3이 나옴


#연습문제 2
class MaxLimitCalculator(Calculator):
    def add(self,val):
        self.value+=val
        if self.value>100:
            print(self.value)
            self.value=100 #계속해서 더한 결과값이 100이상이 되지 않기 위해 100을 넘으면 100 출력
        else:
            return   #100이상이 아닐 경우에는 그냥 더한 값을 반환


cal=MaxLimitCalculator()
cal.add(50)
cal.add(70) #이 값은 그대로 120이 나옴, 위에 print(self.value)에 의해서
print("MaxLimit:%d" %cal.value)  #100이 넘는 170이라 100을 출력(위에 조건문에 의해서)
