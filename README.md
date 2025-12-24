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
