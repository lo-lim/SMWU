'''
import turtle
t= turtle.Turtle()
t.shape("turtle")
color_list=["yellow", "red", "blue", "green"]
t.fillcolor(color_list[0])
t.begin_fill()
t.circle(100)
t.end_fill()
t.forward(50)

t.fillcolor(color_list[1])
t.begin_fill()
t.circle(100)
t.end_fill()
t.forward(50)

t.fillcolor(color_list[2])
t.begin_fill()
t.circle(100)
t.end_fill()
t.forward(50)

t.fillcolor(color_list[3])
t.begin_fill()
t.circle(100)
t.end_fill()

turtle.exitonclick() '''

import turtle
t= turtle.Turtle()
t.shape("turtle")

color_list=["yellow", "red", "blue", "green"]
for i in color_list:
    t.fillcolor(i)
    t.begin_fill()
    t.circle(100)
    t.end_fill()
    if i !="green":
        t.forward(50)

turtle.exitonclick()





