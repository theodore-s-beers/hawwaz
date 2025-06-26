const std = @import("std");
const testing = std.testing;

pub const AbjadOrder = enum { Mashriqi, Maghribi };

pub const AbjadPrefs = struct {
    order: AbjadOrder = .Mashriqi,
    count_shadda: bool = false,
    double_alif_madda: bool = false,
    ignore_lone_hamza: bool = false,
};

pub fn abjadValue(input: []const u8, prefs: AbjadPrefs) !u32 {
    const view = try std.unicode.Utf8View.init(input);
    var iter = view.iterator();

    const maghribi = prefs.order == .Maghribi;

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
            'س' => if (maghribi) 300 else 60,
            'ع' => 70,
            'ف' => 80,
            'ص' => if (maghribi) 60 else 90,
            'ق' => 100,
            'ر' => 200,
            'ش' => if (maghribi) 1000 else 300,
            'ت' => 400,
            'ث' => 500,
            'خ' => 600,
            'ذ' => 700,
            'ض' => if (maghribi) 90 else 800,
            'ظ' => if (maghribi) 800 else 900,
            'غ' => if (maghribi) 900 else 1000,
            else => 0,
        };

        total += nextValue;
    }

    return total;
}

test "basmala abjad value" {
    try testing.expect(try abjadValue("بسم الله الرحمن الرحيم", AbjadPrefs{}) == 786);
}
