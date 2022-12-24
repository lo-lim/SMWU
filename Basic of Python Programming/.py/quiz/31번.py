result=0
try:
    # 4/0
    # "a"+1
    [3,4,5,6][4]


except TypeError as e:
    result +=1
    print(e)

except ZeroDivisionError as e:
    result +=2
    print(e)

except IndexError as e:
    result +=3
    print(e)

finally:
    result+=5

print("result=%d" %result)