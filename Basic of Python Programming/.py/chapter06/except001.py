# 오류처리

'''
try:
    a=[1,2,3]
    print(a[3])

except IndexError as e:
    print(e) '''

try:
    f=open("C:/doit/try001.txt", "w")
    data=("우리는 try~finally 문을 학습 중 입니다.")
    f.write(data)
    a=[1,2]
    f.close()

except ZeroDivisionError as e:
    print(e)

finally:
    f=open("C:/doit/try001.txt", "r")
    data=f.read()
    print(data)