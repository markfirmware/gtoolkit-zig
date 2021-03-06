pub fn main() !void {
    const allocator = &std.heap.FixedBufferAllocator.init(buf[0 ..]).allocator;
    const tree = try zig.parse(allocator, source);
    var i: u32 = 0;
    while (i < tree.nodes.len) : (i += 1) {
        var tag = tree.nodes.items(.tag)[i];
        switch (tag) {
            .address_of,
            .array_access,
            .array_init_dot_two,
            .array_type,
            .assign_add,
            .block,
            .block_two,
            .block_two_semicolon,
            .builtin_call_two,
            .call,
            .call_one,
            .field_access,
            .fn_decl,
            .if_simple,
            .root,
            .slice_open,
            .switch,
            .switch_case,
            .switch_case_one,
            .try,
            .while_cont => {
                info("incomplete {} {s}", .{tag, tree.tokenSlice(tree.firstToken(i))});
            },
            .simple_var_decl => {
                info("incomplete {} {s}", .{tag, tree.tokenSlice(tree.firstToken(i))});
            },
            .fn_proto_simple => {
                var buffer: [1]Node.Index = undefined;
                var f = tree.fnProtoSimple(&buffer, i);
                if (f.name_token) | name_token | {
                    info("incomplete {} {s}", .{tag, tree.tokenSlice(name_token)});
                }
            },
            .identifier => {
                info("incomplete {} {s}", .{tag, tree.tokenSlice(tree.firstToken(i))});
            },
            .less_than,
            .mul => {
                info("incomplete {} {s}", .{tag, tree.tokenSlice(tree.firstToken(i))});
            },
            .enum_literal,
            .integer_literal,
            .string_literal,
            .undefined_literal => {
                info("processed {} {s}", .{tag, tree.tokenSlice(tree.firstToken(i))});
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
const source = @embedFile("example1.zig");
const std = @import("std");
const Tree = ast.Tree;
const VarDecl = ast.Node.VarDecl;
const warn = std.debug.warn;
const zig = std.zig;

var buf:[1024 * 1024] u8 = undefined;
