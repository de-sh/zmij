const std = @import("std");
const zmij = @import("zmij.zig");
const expectEqualStrings = std.testing.expectEqualStrings;
const expectEqual = std.testing.expectEqual;

fn dtoa(value: f64) []const u8 {
    var buf = zmij.Buffer{};
    return buf.format(value);
}

test "normal" {
    try expectEqualStrings(
        "6.62607015e-34",
        dtoa(6.62607015e-34),
    );
}

test "zero" {
    try expectEqualStrings("0", dtoa(0.0));
    try expectEqualStrings("-0", dtoa(-0.0));
}

test "inf" {
    try expectEqualStrings("inf", dtoa(std.math.inf(f64)));
    try expectEqualStrings("-inf", dtoa(-std.math.inf(f64)));
}

test "nan" {
    try expectEqualStrings("nan", dtoa(std.math.nan(f64)));
}

test "shorter" {
    // A possibly shorter underestimate is picked (u' in Schubfach).
    try expectEqualStrings("-4.932096661796888e-226", dtoa(-4.932096661796888e-226));

    // A possibly shorter overestimate is picked (w' in Schubfach).
    try expectEqualStrings("3.439070283483335e+35", dtoa(3.439070283483335e+35));
}

test "single_candidate" {
    // Only an underestimate is in the rounding region (u in Schubfach).
    try expectEqualStrings("6.606854224493745e-17", dtoa(6.606854224493745e-17));

    // Only an overestimate is in the rounding region (w in Schubfach).
    try expectEqualStrings("6.079537928711555e+61", dtoa(6.079537928711555e+61));
}

test "zero_exponent" {
    // A single digit number
    try expectEqualStrings("0.000000000000001e+15", dtoa(1.0));

    // A fractional with zero as exponent
    try expectEqualStrings("1.234e+00", dtoa(1.234));
}
