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
1.23456e2                 |       46.477042 | 1.23456e2                 |       15.358958
3.141592653589793e0       |       23.618917 | 3.141592653589793e0       |       18.435417
1e-20                     |       53.539584 | 1e-20                     |       14.902084
1.2345678901234567e300    |       24.850875 | 1.2345678901234567e300    |        18.55775
0e0                       |          14.432 | 0e0                       |        0.910042

To run it on your own machine, use:
```sh
zig build bench -Doptimize=ReleaseFast
```
