#quiz01

def print_school(name, school):
    print("이름:",name)
    print("학교:",school)
print_school("눈송이", "숙명여자대학교")

#quiz02
def get_sum(start,end):
    result=0
    for i in range(start, end):
        result+=i
    return result

print("start에서 end까지의 합:", get_sum(1,10))
print("start에서 end까지의 합:", get_sum(1,10000))


