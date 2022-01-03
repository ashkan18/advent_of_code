from functools import reduce

def update_smallest(current_smallest, item):
  if item >= current_smallest[-1]: return current_smallest
  # item is smaller than max, list needs to be updated
  current_smallest.append(item)
  current_smallest.sort()
  current_smallest.pop()
  return current_smallest


def nth_smallest(arr, n):
  # return the nth smallest element
  arr = list(set(arr))
  if n > len(arr): return None

  current_list = [99999999999999] * n
  result = reduce(update_smallest, arr, current_list)
  print result[-1]

nth_smallest([14, 12, 46, 34, 334], 3)