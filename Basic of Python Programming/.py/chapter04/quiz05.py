'''
def get_square(a,b,c):
    return a**2, b**2, c**2
result=get_square(2,5,7)
a_sq=result[0]
b_sq=result[1]
c_sq=result[2]

print("2의제곱:%d 5의제곱:%d 7의제곱:%d" %(a_sq,b_sq,c_sq)) '''

def get_squre(a,b,c):
    return a**2, b**2, c**2

a,b,c=2,5,7
a_sq, b_sq, c_sq=get_squre(a,b,c)
print("2의제곱:%d 5의제곱:%d 7의제곱:%d" %(a_sq,b_sq,c_sq))

