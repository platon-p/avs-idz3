from random import randint

n = int(input('Digits count: '))
name = input('Out file name: ')
data = [randint(0, 9) for _ in range(n)]
with open(name, 'w') as f:
    f.write(''.join(str(i) for i in data))
print(sum(data))

