a=[-8, 2,7,5,-3,5,0,1]
print(max(a)+min(a))

numbers=[1,2,3,4,5,6]
print(list(filter(lambda x:x%2, numbers)))

for i in range(3): #0~2
    try:
        print(i, 3//i)
    except ZeroDivisionError:
        print("Not divided by 0")


print(divmod(4,3))
print(eval('divmod(4,3)'))


