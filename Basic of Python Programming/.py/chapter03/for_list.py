#리스트 내포\
a=[1,2,3,4]
result=[] #비어있는 리스트
for num in a:
    result.append(num*3)
print("result1:", result)

#간단하게 표현
result=[num*3 for num in a]
print("result2:", result)

#짝수에만 3곱해서 리스트에 넣기
result=[num*3 for num in a if num%2==0]
print("result3:", result)

#리스트 내포를 이용한 구구단
result=[x*y for x in range(2,10) for y in range(1,10)]
print("result4:", result)

