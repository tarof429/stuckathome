# Part 6: Generators

Generators are functions that carry state, so that repeated calls to the function can yield different results. 

The example below generates a key similar to docker IDs.

```python
import random

# Generate a value for a key. Subsequent calls will return a new value for the
# key. If dups is set to False, then subsequent calls will return a unique
# value.
def key_generator(size, dups=True):
    alpha_list = ['a', 'b', 'c', 'd', 'e', 'f']
    num_list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    key_value_list = alpha_list + num_list

    # If the key size is greater than the length of the key value list, 
    # and we request that there be no duplicate values in the key, then
    # raise an exception
    if dups == False and size > len(key_value_list):
        raise Exception('Not allowed')

    for i in range(size):
        index = random.randint(0, len(key_value_list) - 1)
        if not dups:
            yield key_value_list.pop(index)
        else:
            yield(key_value_list[index])

key = ''

for item in key_generator(16, True):
    key += str(item)

print(key)
```