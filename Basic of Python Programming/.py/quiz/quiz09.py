def get_sum(start,end):
    result=0
    for i in range(start,end+1):
        result+=i
    return result
print("start에서 end까지의 합:", get_sum(1,10))
print("start에서 end까지의 합:", get_sum(1,9999))