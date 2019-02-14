import os, csv

month_count = 0
total_net = 0
change_list = []
numbers_list = []
numbers_list_offset = [0,]
total_change = 0

file = os.path.join('Data','budget_data.csv')

with open(file, newline ='', encoding = "UTF-8") as budget_data:
    reader = csv.reader(budget_data, delimiter = ',')
    header = next(reader)

    for row in reader:
        number = int(row[1])
        numbers_list.append(number)
        numbers_list_offset.append(number)
        month_count += 1
        total_net += number

    zipped_list = zip(numbers_list, numbers_list_offset)
    budget_data.seek(0)
    header = next(reader)

    for numbers in zipped_list:
        difference = numbers[0] - numbers[1]
        change_list.append(difference)
    
    change_list.pop(0)

    for change in change_list:
        total_change += change
    
    average_change = (total_change / len(change_list))
    max_change = max(change_list)
    min_change = min(change_list)
    max_change_position = change_list.index(max_change)
    min_change_position = change_list.index(min_change)
    max_change_line = numbers_list[max_change_position]
    min_change_line = numbers_list[min_change_position]
    
    for row in reader:
        date = str(row[0])
        number = int(row[1])
        if number == max_change_line:
            max_change_month = date
        elif number == min_change_line:
            min_change_month = date
        
    print("Financial Analysis")
    print("-------------------------------")

    print(f"Total Months: {month_count}")
    print(f"Total: {total_net}")
    print(f"Average Change: {average_change}")
    print(f"Greatest Increase in Profits: {max_change_month} {max_change}")
    print(f"Greatest Decrease in Profits: {min_change_month} {min_change}")
        