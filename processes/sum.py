import sys

# Check if two arguments are passed
if len(sys.argv) != 3:
    print("Usage: python sum.py <number1> <number2>")
    sys.exit()

number_1 = int(sys.argv[1])
print("First number is: ", number_1)

number_2 = int(sys.argv[2])
print("Second number is: ", number_2)

print("Sum of two numbers is: ", number_1 + number_2)
