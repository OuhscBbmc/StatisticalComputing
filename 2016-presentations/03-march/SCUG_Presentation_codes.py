# This is a comment

print('Hello World')

print(type("string"))

# `=` is an assignment statement

x, y, z = 1, 3.1415, 'python'
print(type(x)); print(type(y)); print(type(z))


# Variable names -- Python is case-sensitive
76value = 'big parade'
more@ = 100
class = 'Biostat'

import keyword 
print(keyword.kwlist)

x=5 ; print(x+7)

print(x % 2) # % modulus operator

first = 10 ; second = 15 ; print( first+second )
firstString = str( first ); secondString = str( second )
print( type( firstString ) )
print(firstString + secondString)

User input 
whatCourse = input("what course is this?\n")  # "\n" is newline character
print(whatCourse)

# Conditional execution

# ## Boolean expressions

print(5 == 5) ; print(5 == 6) ; type(True)

# ## Comparison operators

x = 5; y = 6; x != y; x > y; x >= y; x is y; x is not y

# ## Logical operators

x > 0 and x < 10
print(not (x > y))   # Is x not greater than y?
x%2 == 0 or  x%3 == 0
17 and True          # any non-zero number is treated as `True`

# ## Conditional execution contd

x = -1; y =6
if x < 0:
    print("x is positive")
else:
    pass

if x < y:
    print(x, "is less than", y)
elif x > y :
    print(x, "is greater than", y)
else:
    print("x and y are equal")

# Standard data types

import math
lst = [2,3,4,1, 'spam', 3.24, math.pi]; print(x)

listWithinList = ['hello', 2.0, 3, [3,6,5]]

empty = []
print(lst, listWithinList, empty)

# Lists are mutable
listWithinList[0] = "Hi Som"; print(listWithinList)

# `in` operator
"Hi Som" in listWithinList

# looping through a list
for i in lst:
    print(i)

# Data types contd 

# Traversing a list
numbers = [3,5,2]
for i in range(len(numbers)):
    numbers[i] = numbers[i] * 2
print(numbers)

# List operations
a = [1,2,3,5,4,[2,5,1]]; b = [4,5,9]
print(a + b)
print([0]*4)

# Data types contd

# List slices
print(a[:])
print(a[:3])  # non-inclusive end-point, this gives 0,1,2 elements
print(a[2:])

a[1:3] = [777, 999];  print(a)

# Slice a list within a list
print(a[5][1])

# List methods
c = a[:4]
c.append(888); print(c)
c.insert(2, 2222222); print(c)  # select a index where you want to insert

# sort lists
c.sort(reverse=True); print(c)
sorted(c, reverse=True)

# Data types contd

# Delete elements
del c[1]; print(c)       # del c[1:3] for multiple elements
c.remove(999); print(c)

# List and functions
print(len(c)); print(max(c)); print(sum(c))

# Lists and strings
s = 'Python is a magical'
t = list(s); print(t)
split_str = s.split() ; print(split_str); # default separator is ' '

delimiter = ' '
print(delimiter.join(split_str))

# Tuples </h1>

t = ('a', 'b', 'c', 'd','e')  # t = 'a', 'b', 'c', 'd', 'e'  
#  tuple() Although it is not necessary, it is common to enclose tuples in parentheses to

# To create a tuple with a single element
t2 = ('a',)  # t2 = ('a') is  a string

t3 = tuple()
print(t[1:])

# t[0] = 'A'          # Cannot modify it

# You cannot modify the elements of a tuple, but you can replace one tuple with another
t4 = ('A',) + t[1:]
print(t4)

t = tuple('Hello'); print(t)

# Clever application of tuple is: Swap values between two variables
a = 2; b = 3
a, b = b, a

# Tuples contd </h1>

# Comparing tuples
print((0, 1, 2) < (0, 3, 4))
print((0, 1, 2000000) < (0, 3, 4))

# Tuple assignment
m = [ 'have', 'fun' ]
x,y = m
(x, y) = m
print(x,y)

# Dictionaries

# Create a dictionary
eng2sp = dict()

# Add an item to dictionary
eng2sp['one'] = 'uno'

eng2sp = {'one':'uno', 'two':'dos', 'three':'tres'}

# Add an item in dictionary
eng2sp['four'] = 'cuatro'

# Delete item from dictionary
del eng2sp['four'] ; print(eng2sp)

print(eng2sp['two']); print(len(eng2sp))

print('one' in eng2sp)  # default loop up is `keys`

# To see whether something appears as value
print('uno' in eng2sp.values())

# Dictionaries contd </h1>

# Looping through dictionaries
for key,value in eng2sp.items():
    print(key, value)

vals1 =eng2sp.keys()       # Similarly .value() gives values
# g = list(vals1) # change to list
print(vals1)

# Another dictinary example
d = {'a':10, 'b':1, 'c':22}
t =d.items(); print(t) ; print(sorted(t))   # items() returns a list of tuples

for key in d:
    if d[key] > 10:
        print(key, d[key])

# sort by value
l = list()
for key, value in d.items():
    l.append( (value, key) )
    l.sort(reverse=True)
print(l)

# changing value of an element of a list
x = [5, None, 10] ; print(x)
for idx, i in enumerate(x):
    if i == 5:
        x[idx] =1000
print(x)

# Functions </h1>
# ## try and except

def divide(a,b):
    try:
        return True, a/b
    except:
        return "Non divisible", None
divide(2,0)

# Writing a function
def addTwo(a,b):
    added = a + b
    return added
print(addTwo(2,3))

# Functions contd </h1>

# ## Built-in and new functions

text = "Hello world"
print(max(text)); print(min(text)) ;len(text)

# Adding new functions
def print_lines():
    print("Hi, I am Som.")
print_lines()

def repeat_lines():
    print("Here begins new function")
    print_lines(); print_lines()
repeat_lines()

# Iteration </h1>

x = 0
x = x + 1; print(x)

# For loops
for i in range(4):      # end is non-inclusive
    print("The value is:", i)
print("Done")

for letter in "python":
    print("The letter is,", letter)

friends = ['Binod', 'Achyut', 'Bikram']
for friend in friends:
    print(friend, 'has', len(friend), 'letters.')
    
for i in range(0,2):
    for j in "Hi":
        print(i,j)

# Iteration contd

# While loops
n = 5
while (n > 0):                 # while n > 0, display, and reduce by 1
    print(n)
    n = n - 1
print('Done')

# Take user input until they type `done`
while True:
    line = input('> ')
    if line[0] == '#':
        continue
    if line == 'done' or line == 'Done':
        break
    print(line)
print('Done')

# Strings </h1>

# Strings are immutable
fruit = 'apple'   # [0] = 'a', [1] = 'p', [2] = 'p', [3] = 'l',[4] = 'e',
print(fruit[1], len(fruit))
  
length = len(fruit)
# print(fruit[length])   # 0:5, but asking out of range
print(fruit[length-1])

# Traversing through a string
for char in fruit:
    print(char)

# Traversing through a string with index
for idx, val in enumerate(fruit): # getting index of loops
    print(idx, val)
    
# `in` operator
'a' in 'Anaconda'

# String methods
print(type(program))
print(dir(program))

# Strings contd </h1>

# String slices
s = 'Jython in Java'
print(s[0:5]); print(s[6:12]); print(s[:]); print(s[:3]); print(s[3:])

# Strings are immutable
greeting = 'Hello friends!'

# greeting[0] = 'M'; print(greeting)     # DOES NOT WORK

# Slice and concatenate
new_greeting = 'M' + greeting[1:] ; print(new_greeting)

# Looping and counting
program = 'Anaconda'
count = 0
for letter in program:
    if letter == 'a':
        count += 1
print(count)

# Change case
print(program.upper()) ; print(program.find('a'))   # finds first occurence

# remove space at the begining and end of the string 
print('  here we go   '.strip())
print(program.startswith('b'))  # logical
print(program.upper()[program.upper().startswith('A')-1])   #  get the letter
# print(True - 1)

# Parsing the strings
data = 'From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008'
at_position = data.find('@')
space_position = data.find(' ', at_position)
host = data[at_position+1:space_position] ; print(host)

# Format operator `%`
value = 99
print('There are %d pythons.' %value)
print('The value of %s i.e. %g can be rounded to %d.' % ('pi', 3.14, 3))

# Files </h1>

# * Opening, reading, and searching through `.txt` files

# reading from a text file

print("Opening file")
text_file = open("test.txt", "r")   # or open("test.txt").read()
print(text_file)
#print(dir(text_file))

#print(text_file.read(1))       # reads first character
#print(text_file.read(5))       # reads fifth character (skips first character as you already read it)

#wholeFile = text_file.read()     # reads whole file (skips already read character)
#print(wholeFile.split())         # splits by space


# print(text_file.readline())    # reads first line
# print(text_file.readline(5))    # reads 4 characters from first line


# <h1 style ="background-color:gold;color:blue;font-family:calibri;font-size:250%;text-align:left"> 
# Contd Files </h1>

# In[9]:

lines = text_file.readlines()    # reads all lines and results in  a list with newline character
# print(lines)

for i in lines:     # there is a carriage return ('\n' character)
    #i = i.rstrip()
    print(i)

# Searching through a file
for line in text_file:
    line = line.rstrip()                      # lstrip removes spaces from left
    if not line.startswith("Man"):
        continue   # if line.startswith('From '):
    words = line.split()
    print(words)                          

# Another try
for line in text_file:
    line = line.rstrip()                           
    if not line.startswith('Man'):        
        words = line.split()                          
        print(words)                                   

text_file.close()

# References and resources </h1>

# <h1 style="text-align:left;font-family:calibri;color:black;font-size:175%;font-weight:normal">
# * Python documentation http://python.org/ 
# * Books include:
#     * Python for Informatics by Charles Severance
#     * Learning Python by Mark Lutz
#     * Python Essential Reference by David Beazley
#     * Python Cookbook, ed. by Martelli, Ravenscroft and Ascher
#     * http://wiki.python.org/moin/PythonBooks

# <h1 style ="background-color:gold;color:blue;font-family:calibri;font-size:400%;text-align:center"> 
# Thanks! </h1>
# Coming up -- Python for Data Science with pandas, numpy, and scikit-learn </h1>
