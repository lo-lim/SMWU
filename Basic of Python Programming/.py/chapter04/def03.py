#입력값이 여러개 일 때
def add_many(*args):
    result=0
    for i in args:
        result+=i
    return result


result=add_many(1,2,3,4,5,6,7,8,9,10)
print(result)

def add_mul(choice, *args):
    if choice=="add":
        result=0
        for i in args:
            result +=i
    elif choice =="mul":
        result =1 #mul일 때는 곱하는 거니까 초기값은 0이 아니라 1로 설정
        for i in args:
            result *=i #result=result*i

    else:
        return

    return result

result=add_mul('add', 1,2,3,4,5)
print(result)
result=add_mul('mul', 1,2,3,4,5)
print(result)
