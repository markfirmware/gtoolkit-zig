const std = @import("std");
const parse = std.zig.parse;

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var alloc = &arena.allocator;
    var tree = try parse(alloc, "fn function () void {}");
    var rendering = try tree.render(alloc);
    std.log.info("{s}", .{rendering});
    var json = try tree.jsonRender(alloc);
    std.log.info("{s}", .{json});
}