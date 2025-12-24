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

std.fmt (ns)                                | zmij (ns)                                  
--------------------------------------------|--------------------------------------------
Value                     | Avg. Time       | Value                     | Avg. Time      
--------------------------|-----------------|---------------------------|----------------
1.23456e2                 |      229.554541 | 1.23456e+02               |        83.86175
3.141592653589793e0       |      194.736375 | 3.141592653589793e+00     |      106.911042
1e-20                     |       239.93975 | 1.e-20                    |       83.562458
1.2345678901234567e300    |      198.272666 | 1.2345678901234567e+300   |      105.636083
0e0                       |       86.746875 | 0                         |        5.591416
