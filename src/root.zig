//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub fn calculateAbjadValue(input: []const u8) u32 {
    var total: u32 = 0;

    for (input) |char| {
        const value: u32 = switch (char) {
            'a', 'A' => 1,
            'b', 'B' => 2,
            'c', 'C' => 3,
            'd', 'D' => 4,
            'e', 'E' => 5,
            'f', 'F' => 6,
            'g', 'G' => 7,
            'h', 'H' => 8,
            'i', 'I' => 9,
            'j', 'J' => 10,
            'k', 'K' => 20,
            'l', 'L' => 30,
            'm', 'M' => 40,
            'n', 'N' => 50,
            'o', 'O' => 60,
            'p', 'P' => 70,
            'q', 'Q' => 80,
            'r', 'R' => 90,
            's', 'S' => 100,
            't', 'T' => 200,
            'u', 'U' => 300,
            'v', 'V' => 400,
            'w', 'W' => 500,
            'x', 'X' => 600,
            'y', 'Y' => 700,
            'z', 'Z' => 800,
            else => 0,
        };
        total += value;
    }

    return total;
}

test "abjad value calculation" {
    try testing.expect(calculateAbjadValue("a") == 1);
    try testing.expect(calculateAbjadValue("abc") == 6);
    try testing.expect(calculateAbjadValue("hello") == 8 + 5 + 30 + 30 + 60);
}
