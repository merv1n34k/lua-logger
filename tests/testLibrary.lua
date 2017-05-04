local lib = require"log4l"

assert(lib.tostring{1, 2, 3, 4, 5, 6, 7, 8, 9} == "{1, 2, 3, 4, 5, 6, 7, 8, 9}", "test is incorrect")
assert(lib.tostring{1, 2, 3, 4, 5, 6, 7, 8, 9, 10} == "{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}", "numbers were reordered")

assert(lib.tostring{[45] = 1, 5} == "{5, [45] = 1}", "out-of-order numbers did not sort")

local self_ref = {}

self_ref[self_ref] = self_ref

lib.tostring(self_ref)

local normal = {}

assert(lib.tostring{normal} == '{{}}', "simple case incorrect")
assert(lib.tostring{normal, normal} == '{{}, {}}', "non-nested case incorrect")
