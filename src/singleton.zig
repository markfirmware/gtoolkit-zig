const info = std.log.info;

pub fn main() !void {
    const allocator = &std.heap.FixedBufferAllocator.init(buf[0 ..]).allocator;
    const tree = try zig.parse(allocator, source);
    var i: u32 = 0;
    while (i < tree.nodes.len) : (i += 1) {
        var tag = tree.nodes.items(.tag)[i];
    //      findStruct(tree, 0, i, trunk);
        switch (tag) {
            .simple_var_decl => {
                info("processed {}", .{tag});
            },
            else =>{
                info("else {}", .{tag});
            }
        }
    }
}

fn findStruct(tree: *Tree, depth: u32, n: u32, trunk: *Node) void {
    if (trunk.cast(VarDecl)) |var_decl| {
            if (trunk.iterate(0)) |container_node| {
                if (container_node.cast(ContainerDecl)) |container_decl| {
                    if (mem.eql(u8, tree.tokenSlice(container_decl.kind_token), "struct")) {
                        const struct_name = tree.tokenSlice(var_decl.name_token);
                        var has_field = false;
                        var has_state = false;
                        var i: u32 = 0;
                        while (container_node.iterate(i)) |node| : (i += 1) {
                            if (node.cast(VarDecl)) |state_decl| {
                                if (mem.eql(u8, tree.tokenSlice(state_decl.mut_token), "var")) {
                                    has_state = true;
                                }
                            } else if (node.cast(ContainerField)) |container_field| {
                                has_field = true;
                            }
                        }
                        if (has_state and !has_field) {
                            var d: u32 = 0;
                            while (d < depth) : (d += 1) {
                                warn("    ", .{});
                            }
                            warn("stateful singleton {}\n", .{struct_name});
                        }
                        i = 0;
                        while (container_node.iterate(i)) |node| : (i += 1) {
                            if (node.cast(VarDecl)) |state_decl| {
                                if (!mem.eql(u8, tree.tokenSlice(state_decl.mut_token), "var")) {
                                    findStruct(tree, depth + 1, i, node);
                                }
                            }
                        }
                    }
                }
            }
    } else {
        var i: u32 = 0;
        while (trunk.iterate(i)) |node| : (i += 1) {
            findStruct(tree, depth + 1, i, node);
        }
    }
}

const ast = zig.ast;
const ContainerDecl = ast.Node.ContainerDecl;
const ContainerField = ast.Node.ContainerField;
const mem = std.mem;
const Node = ast.Node;
const source = @embedFile("main.zig");
const std = @import("std");
const Tree = ast.Tree;
const VarDecl = ast.Node.VarDecl;
const warn = std.debug.warn;
const zig = std.zig;

var buf:[1024 * 1024] u8 = undefined;
