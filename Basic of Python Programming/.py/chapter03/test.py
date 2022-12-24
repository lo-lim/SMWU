#실습:예제4

myage= int(input("Tell me your age?"))

if myage <=30:
    print("welcome to the Club")
else:
    print("Oh! No. You are not accepted")

#실습:예제 5

num=int(input("정수를 입력하시오:"))
num= "짝수 입니다." if num %2 ==0 else "홀수 입니다."
print(num)

#실습:예제 6

price=int(input("정가를 입력하시오:"))
cut=price*(1-0.1)
cut1=price*(1-0.15)

if price <100:
    print("상품의 가격 =", cut)
else:
    print("10층에서 사은품을 받아가세요")
    print("상품의 가격 =", cut1)
#실습:예제 7

price=int(input("가격을 입력하시오:"))
kind=input("카드의 종류를 입력하시오:")

if price >=20000 and kind== 'python':
    print("배송료가 없습니다.")
else:
    print("배송료는 3000원입니다.")

#실습:예제 8

score=int(input("Enter score>"))

if score >=90:
    print("Your grade is A")
    print("You passed.")

elif score >=80:
    print("Your grad is B")
    print("You passed.")

elif score >=70:
    print("Your grad is C")
    print("You passed.")

elif score >=60:
    print("Your grad is D")
    print("You passed")

else:
    print("Your grad is F")
    print("Sorry, you failed.")




