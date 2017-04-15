local lib = require"logging"

assert(lib.tostring{1, 2, 3, 4, 5, 6, 7, 8, 9} == "{1, 2, 3, 4, 5, 6, 7, 8, 9}", "test is incorrect")
assert(lib.tostring{1, 2, 3, 4, 5, 6, 7, 8, 9, 10} == "{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}", "numbers were reordered")
