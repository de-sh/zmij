# zmij :dragon:

Zig implementation of a fast floating point to string conversion algorithm

Inspirations: 
1. [David Tolnay's Rust implementation](https://github.com/dtolnay/zmij)
2. [Victor Zverovich's C++ implementation](https://github.com/vitaut/zmij)


### Example
```zig
const zmij = @import("zmij.zig");
const expectEqualStrings = @import("std").testing.expectEqualStrings;

pub fn main() !void {
    var buf = zmij.Buffer{};
    const printed = buf.format(1.234);
    try expectEqualStrings("1.234e+00", printed);
}
```

### Benchmark
The code has been benchmarked against std.fmt and the results are as follows:

Value                   | std.fmt (ns)    | zmij (ns)      
------------------------|-----------------|----------------
1.23456e2               |          223.79 |           86.35
3.141592653589793e0     |          193.63 |          105.88
1e-20                   |          236.80 |           82.14
1.2345678901234567e300  |          195.90 |           98.89
0e0                     |           86.43 |            5.84
