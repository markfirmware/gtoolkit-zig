const std = @import("std");
const parse = std.zig.parse;

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var alloc = &arena.allocator;
    var tree = try parse(alloc, "pub inline fn function () void {}");
    var rendering1 = try tree.render(alloc);
    std.log.info("{s}", .{rendering1});
    var rendering2 = try tree.renderJson(alloc);
    std.log.info("{s}", .{rendering2});
}
