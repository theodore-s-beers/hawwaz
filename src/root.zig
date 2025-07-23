const std = @import("std");
const testing = std.testing;

const utf8_decode = @import("utf8_decode");

//
// Public types
//

pub const AbjadOrder = enum { mashriqi, maghribi };

pub const AbjadPrefs = struct {
    order: AbjadOrder = .mashriqi,
    count_shadda: bool = false,
    double_alif_madda: bool = false,
    ignore_lone_hamza: bool = false,
};

//
// Public functions
//

pub fn abjad(input: []const u8, prefs: AbjadPrefs) !u32 {
    var iter = utf8_decode.Utf8Iterator.init(input);
    var total: u32 = 0;
    var last_val: u32 = 0;

    while (iter.next()) |char| {
        const new_val = letterValue(char, last_val, prefs);
        total += new_val;
        last_val = if (char == '\u{0651}') 0 else new_val; // Ignore repeated shadda
    }

    return total;
}

//
// Private functions
//

fn letterValue(char: u32, last_val: u32, prefs: AbjadPrefs) u32 {
    const maghribi = prefs.order == .maghribi;

    return switch (char) {
        'ا', 'أ', 'إ', 'ٱ' => 1,
        'آ' => if (prefs.double_alif_madda) 2 else 1,
        'ء' => if (prefs.ignore_lone_hamza) 0 else 1,
        'ب', 'پ' => 2,
        'ج', 'چ' => 3,
        'د' => 4,
        'ه', 'ة', 'ۀ' => 5,
        'و', 'ؤ' => 6,
        'ز', 'ژ' => 7,
        'ح' => 8,
        'ط' => 9,
        'ي', 'ى', 'ئ', 'ی' => 10,
        'ك', 'ک', 'گ' => 20,
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
        '\u{0651}' => if (prefs.count_shadda) last_val else 0,
        else => 0,
    };
}

//
// Tests
//

test "basmala" {
    try testing.expect(try abjad("بسم الله الرحمن الرحيم", .{}) == 786);
}

test "full alphabet" {
    const input = "ابجد هوز حطي كلمن سعفص قرشت ثخذ ضظغ";
    const expected: u32 = 5995;
    try testing.expect(try abjad(input, .{}) == expected);
    try testing.expect(try abjad(input, .{ .order = .maghribi }) == expected);
}

test "latin script ignored" {
    try testing.expect(try abjad("روح الله tap-dancing خمینی", .{}) == 990);
}

test "baha counted" {
    try testing.expect(try abjad("بهاء", .{}) == 9);
}

test "baha ignored" {
    try testing.expect(try abjad("بهاء", .{ .ignore_lone_hamza = true }) == 8);
}

test "shadda ignored" {
    try testing.expect(try abjad("قد تمّمته", .{}) == 989);
}

test "shadda counted" {
    try testing.expect(try abjad("رئیس مؤسّس دانشگاه", .{ .count_shadda = true }) == 887);
}

test "humayun chronogram" {
    try testing.expect(try abjad("همایون پادشاه از بام افتاد", .{}) == 962);
}

test "vahshi chronogram" {
    try testing.expect(try abjad("وفات وحشی مسکین", .{}) == 991);
}
