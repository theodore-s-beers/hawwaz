const std = @import("std");
const testing = std.testing;

pub fn abjadValue(input: []const u8) !u32 {
    const view = try std.unicode.Utf8View.init(input);
    var iter = view.iterator();

    var total: u32 = 0;

    while (iter.nextCodepoint()) |char| {
        const nextValue: u32 = switch (char) {
            'ا' => 1,
            'ب' => 2,
            'ج' => 3,
            'د' => 4,
            'ه' => 5,
            'و' => 6,
            'ز' => 7,
            'ح' => 8,
            'ط' => 9,
            'ي' => 10,
            'ك' => 20,
            'ل' => 30,
            'م' => 40,
            'ن' => 50,
            'س' => 60,
            'ع' => 70,
            'ف' => 80,
            'ص' => 90,
            'ق' => 100,
            'ر' => 200,
            'ش' => 300,
            'ت' => 400,
            'ث' => 500,
            'خ' => 600,
            'ذ' => 700,
            'ض' => 800,
            'ظ' => 900,
            'غ' => 1000,
            else => 0,
        };

        total += nextValue;
    }

    return total;
}

test "abjad value calculation" {
    try testing.expect(try abjadValue("بسم الله الرحمن الرحيم") == 786);
}
