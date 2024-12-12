import random

lines = []
for i in range(50):
    # Generate content for the file with 50 random integers, 10 per line
    lines.append("50")
    random_numbers = [random.randint(-100, 100) for _ in range(50)]

    # Split the random numbers into lines of 10 numbers each
    for i in range(0, 50, 10):
        line = ", ".join(map(str, random_numbers[i:i+10]))
        lines.append(".word " + line)

# Write the content to a text file
with open("random_numbers_50.txt", "w") as file:
    file.write("\n".join(lines))
