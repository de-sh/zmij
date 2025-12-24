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

```
std.fmt                                     | zmij                                       
--------------------------------------------|--------------------------------------------
Value                     | Avg. Time (ns)  | Value                     | Avg. Time (ns) 
--------------------------|-----------------|---------------------------|----------------
1.23456e2                 |      217.706875 | 1.23456e+02               |       80.578084
3.141592653589793e0       |      194.159166 | 3.141592653589793e+00     |      104.522875
1e-20                     |         239.597 | 1.e-20                    |       81.734208
1.2345678901234567e300    |      197.318291 | 1.2345678901234567e+300   |       102.10875
0e0                       |        87.62675 | 0                         |          5.5385
```
