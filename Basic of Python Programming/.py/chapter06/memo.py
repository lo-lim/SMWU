#memo.py--> 간단한 메모장 만들기

import sys
option= sys.argv[1]
if option == "-a":
    memo= sys.argv[2]
    f= open("C:/doit/memo.txt", 'a')
    f.write(memo)
    f.write('\n')
    f.close()
    
elif option=="-v":
    f=open("C:/doit/memo.txt", 'r')
    memo=f.read()
    f.close()
    print(memo)


