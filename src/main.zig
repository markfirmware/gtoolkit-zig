pub fn main() !void {
    const allocator = &std.heap.FixedBufferAllocator.init(buf[0 ..]).allocator;
    const tree = try zig.parse(allocator, source);
    var i: u32 = 0;
    while (i < tree.nodes.len) : (i += 1) {
        var tag = tree.nodes.items(.tag)[i];
        switch (tag) {
            .block_two_semicolon,
            .builtin_call_two,
            .call,
            .error_union,
            .field_access,
            .fn_decl,
            .identifier,
            .root,
            .simple_var_decl,
            .struct_init_dot_two => {
                info("tbd {} {s}", .{tag, tree.tokenSlice(tree.firstToken(i))});
            },
            .fn_proto_simple => {
                info("incomplete {} {s}", .{tag, tree.tokenSlice(tree.firstToken(i))});
                var buffer: [1]Node.Index = undefined;
                var f = tree.fnProtoSimple(&buffer, i);
                if (f.name_token) | name_token | {
                    info("incomplete {} name={s}", .{tag, tree.tokenSlice(name_token)});
                }
            },
            .string_literal => {
                info("complete {} {s}", .{tag, tree.tokenSlice(tree.firstToken(i))});
            },
            else =>{
                info("else {}", .{tag});
            }
        }
    }
}

const ast = zig.ast;
const ContainerDecl = ast.Node.ContainerDecl;
const ContainerField = ast.Node.ContainerField;
const info = std.log.info;
const mem = std.mem;
const Node = ast.Node;
const source = @embedFile("example1/src/main.zig");
const std = @import("std");
const Tree = ast.Tree;
const VarDecl = ast.Node.VarDecl;
const warn = std.debug.warn;
const zig = std.zig;

var buf:[1024 * 1024] u8 = undefined;
