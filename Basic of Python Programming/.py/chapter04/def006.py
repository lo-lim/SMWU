#지역변수, 전역변수

'''
a=5
def vartest(a):
    a=a+1

vartest(a)
print(a)

# 5가나오는 이유는 함수 바깥에 있는 'a=5'에 의해서 5가 나오기 때문
# 즉 vartest(a)했는데도 아무 값이 안 나오는 이유는 return이 없고 함수 안에서만 작용하는
#지역변수 이기 때문

a=6
def vartest(a):
    a+=1
    return a
a=vartest(a)
print(a)
# 함수 밖에 있는 a를 사용하고 싶으면 함수 안에 return을 꼭 해줘야 함.  '''

a=5
def vartest():
    global a
    a+=1
vartest()
print(a)

