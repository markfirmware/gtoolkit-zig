const std = @import("std");
const parse = std.zig.parse;
const ast = std.zig.ast;

pub fn main() anyerror!void {
    var j: JsonRenderer = undefined;
    try j.render("fn function () void {}");
}

const JsonRenderer = struct {
    tree: ast.Tree,
    const Self = @This();
    fn render(self: *Self, source: []const u8) anyerror!void {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        var alloc = &arena.allocator;
        self.tree = try parse(alloc, "fn function () void {}");
        // var rendering = try tree.render(alloc);
        var members: []const ast.Node.Index = self.tree.rootDecls();
        self.add(members[0]);
    }
    fn openD(self: *Self, tag: ast.Node.Tag) void {
        std.log.info("{{tag: {s}", .{@tagName(tag)});
    }
    fn closeD(self: *Self) void {
        std.log.info("}}", .{});
    }
    fn add(self: *Self, decl: ast.Node.Index) void {
        var tag = self.tree.nodes.items(.tag)[decl];
        if (tag == .fn_decl) {
            self.openD(tag);
            self.closeD();
        } else {
            std.log.info("tag {s} not yet processed", .{@tagName(tag)});
        }
    }
};