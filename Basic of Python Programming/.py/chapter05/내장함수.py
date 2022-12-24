#내장함수 학습
#abs() 절대값을 돌려주는 함수

print(abs(-3))

#all(x): 모두 참--> True, 하나라도 거짓--->False

print(all([1,2,3]))  #안에 자료가 존재하니까 참으로 출력

#chr(i):아스키 코드
print(chr(97))

#ord(): 아스키 코드를 십진수, 즉 숫자로 바꿔줌
print(ord('a'))

#dir()
print(dir([1,2,3]))  #안에 숫자 값이 없어도 큰 의미가 없음 즉 dir([])과 동일

#divmod
print(divmod(7,3))   #a/b를 나눈 몫과 나머지를 둘 다 출력

####....강의안 참고


#filter
def positive(k):
    result=[]
    for i in k:
        if i>0:
            result.append(i)  #위에 조건에 해당하는 i를 위에 result 리스트에 하나씩 추가
    print(result)

print(positive([1,-3,2,0,-5,6]))

def positive(k):
    return k>0

print(tuple(filter(positive,[1,-3,2,0,-5,6])))  #list면 list 형식으로 출력
print(list(filter(lambda x: x>0, [1,-3,2,0,-5,6])))  #람다를 사용해서 원하는 조건에 해당하는 값만 출력

