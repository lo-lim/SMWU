#터틀그래픽으로 그림 그리기
#문제: 길이를 입력받아 변수 length에 대입하고, 45도 회전하면서 length에서 1, 2, 4, 8
#16배하는 것을 터틀 그래프로 그림 그리기

length=int(input("길이를 입력하시오:"))

import turtle
t= turtle.Turtle()
t.shape("turtle")


t.right(45)
t.forward(length)
t.right(45)
t.forward(length*2)
t.right(45)
t.forward(length*4)
t.right(45)
t.forward(length*8)
t.right(45)
t.forward(length*16)
turtle.exitonclick()

