#for문을 이용한 1~10 합 구하기
add=0
for i in range(0,11):  #0~10
    add=add+i
print(add)

#range 함수를 이용해서 60점 이상이면 합격
marks=[90,25,67,45,80]
for number in range(len(marks)): #len(marks)=5니까 0~4
    if marks[number] < 60 :continue
    print("%d번 학생 축하합니다. 합격입니다." %(number+1)) #number가 0부터니까 +1

#for과 range를 이용해서 1~100까지 합 구하기
add=0
for i in range(1,101): #1~100
    add+=i
print("1부터 100까지 총합:", add)

