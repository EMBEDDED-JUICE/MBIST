module multiplexer #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] normal_in,
    input  logic [WIDTH-1:0] bist_in,
    input  logic             NbarT,
    output logic [WIDTH-1:0] out
);

assign out = NbarT ? bist_in : normal_in;

endmodule