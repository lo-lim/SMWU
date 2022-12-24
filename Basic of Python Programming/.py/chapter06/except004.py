#예외처리기법

class MyError(Exception):
    def __str__(self):
        return '허용되지 않은 별병입니다.'

def say_nick(nick):
    if nick=='바보':
        raise MyError()
    print(nick)



try:
    say_nick('천사')
    say_nick('바보')

except MyError as e:
    print(e)



for i in range(3):
    try:
        print(i, 3//i)
    except ZeroDivisionError:
        print("Not divided by o")