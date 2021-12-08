def day1a():
    with open("day1.txt", "r") as day1:
        prev_line = 0
        increases = -1
        
        for line in day1:
            reading = int(line.rstrip())
            #print(reading)
            if reading > prev_line:
                increases += 1
            prev_line = reading
    print(increases)

def integerize(mystring):
    return int(mystring.rstrip())

def day1b():
    with open("day1.txt", "r") as day1:
        line1 = 0
        line2 = integerize(day1.readline())
        line3 = integerize(day1.readline())

        prev_sum = 0
        increases = -1

        for line in day1:
            line1, line2, line3 = line2, line3, integerize(line)
            #print(line1, " ", line2, " ", line3)
            reading = line1 + line2 + line3
            if reading > prev_sum:
                increases += 1
            prev_sum = reading
    print(increases)
        

