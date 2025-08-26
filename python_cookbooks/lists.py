import timeit
import dis 

# Using square brackets 
time1 = timeit.timeit("[]", number=1000000)

# Using list() constructor
time2 = timeit.timeit("list()", number=1000000)

print("Using []: ", time1) 
print("Using list(): ", time2)

dis.dis("[]")
dis.dis("list()")

numbers = [1, 2, 3, 4, 5]

print(numbers[0])
print(numbers[~0])
print(numbers[-1])
print(numbers[-0])
print(numbers[-2] == numbers[~1])

numbers = [0, 1, 2, 3, 4, 5, 6]

numbers_copy = numbers[:]
print(numbers_copy)

natural_numbers = numbers[1:]
print(natural_numbers)



