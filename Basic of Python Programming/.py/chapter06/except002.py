#여러개 오류 처리


try:
    a=[1,2,3]
    print(a[4])
    print(4/0)

except (ZeroDivisionError, IndexError) as e:
    pass
