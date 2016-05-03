import re

m = re.search('(?<=abc)def', 'abcdef')
print(m.group(0))

print("###### Example 1 ###########")
example_1 = """
    1916-1918 subscales for a subject
    1998-1914 subscales for a subject
    subscales for a subject 1998-1920
    """

r = re.sub('(\d{2})(\d{2})', '20\\2', example_1)
print(r)

print("###### Example 2 ###########")
example_2 = """
    1234
    23
      
    14a
    1a3

     234
    1.39
    """
# m = re.match('\\d', 'abcdef')
# print(m.group(0))

print("###### Example 3 ###########")


print("###### Example 4 ###########")


print("###### Example 5 ###########")
