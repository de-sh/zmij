# Żmij :dragon:

Zig implementation of a fast floating point to string conversion algorithm

Inspirations: 
1. [Victor Zverovich's C/C++ implementation](https://github.com/vitaut/zmij) - **Reference Implementation**
2. [David Tolnay's Rust implementation](https://github.com/dtolnay/zmij)


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

Value(std.fmt)            | Avg. Time (ns)  | Value(zmij)               | Avg. Time (ns) 
--------------------------|-----------------|---------------------------|----------------
1.23456e2                 |         221.653 | 1.23456e+02               |       84.108542
3.141592653589793e0       |      196.794667 | 3.141592653589793e+00     |       101.46225
1e-20                     |      238.503166 | 1.e-20                    |         83.8725
1.2345678901234567e300    |      199.355334 | 1.2345678901234567e+300   |        98.94025
0e0                       |          88.918 | 0                         |         5.84175
