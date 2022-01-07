# Part 7: Iterators

To implement your own iterator, a class must implement __iter__() and __next__(). Below is an example to return a list of prime numbers.

```python
class Prime:

	def __init__(self, max = 0):
		self.primes = [2, 3, 5, 7, 11, 13, 17, 19]

		if max > len(self.primes):
			raise Exception('Over the limit')
		self.max = max
	
	# Return the iterator object itself
	def __iter__(self):
		self.n = 0
		return self
		
	# Return the next item in the sequence
	def __next__(self):
		if self.n <= self.max:
			result = self.primes[self.n]
			self.n += 1
			return result
		else:
			raise StopIteration

for p in Prime(6):
	print(p)
```