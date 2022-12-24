#문제 5: 거스름돈 구하기

price= int(input("물건가격:"))
buy= int(input("구매개수:"))
pay= int(input("지불금액:"))
change= pay-price*buy

print("물건가격:", price, "원")
print("구매개수:", buy, "개")
print("지불금액:", pay, "원")
print("거스름돈:", change, "원")