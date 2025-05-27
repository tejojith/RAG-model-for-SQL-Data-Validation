# # digit
# #123 - 6
# #45 - 9
# # 100 - 1
# import pandas as pd
# import math


# df = pd.read_csv('data.csv')

# log_file = open('log_file.csv', 'w')
# log_file.write("Index,Original Value,Updated Value,Status\n")

# def calculate_sum(value):
#   sum = 0
#   value = int(value)
#   while value > 0:
#     num = value%10
#     sum += num
#     value = value//10

#   return sum
    
# ## have to caluculate sum for decimal as well as expenonetial values
# for index,value in df['Value'].items():
    
       
#     try:
      
#       initial = value
    
#       if pd.isna(value):
#          raise ValueError("Missing Value")


#       if value[:3] == 'exp':
#         value = math.exp(int(value[4:-1]))
        
        
    
#       if '.' in str(value):
#         sum = 0
        
#         list = str(value).split('.')
        
#         first = int(list[0])
#         second = int(list[1])
#         sum = calculate_sum(first)
#         sum += calculate_sum(second)


#       else:
#         sum = calculate_sum(value)
      
#       df.at[index,'Result'] = int(sum)
#       log_file.write(f'{index},{initial},{int(sum)},value changed\n')
#     except Exception as e:
#        log_file.write(f'{index},{initial},N/A,Value not applicable due to error: {str(e)}\n')
       

# log_file.close()
# df.to_csv('data.csv', index = False)



import pandas as pd
import math

def calculate_sum(value):
  sum = 0
  while value > 0:
    sum += value % 10
    value //= 10
  return sum

log_file = open('codebase/log_file.csv', 'a')
df = pd.read_csv('codebase/Data.csv')

for index, value in df['Value'].items():

    if pd.isna(value):
        raise ValueError("Missing Value")

    initial = value

    if value[:3] == 'exp':
      value = math.exp(int(value[4:-1]))

    list = str(value).split('.')
    value = int(''.join(list))

    try:
        sum = calculate_sum(value)
    except Exception as e:
       log_file.write(f'{index},{initial},N/A,Value not applicable due to error: {str(e)}\n')
       continue

    if math.isnan(sum):
      status = 'Not a number'
    elif value >= 1 and value <= 9:
      status = f'Value changed ({value} -> {sum})'
    else:
      status = ''

    log_file.write(f'{index},{initial},{int(sum)},{status}\n')

log_file.close()
df.to_csv('data.csv', index = False)