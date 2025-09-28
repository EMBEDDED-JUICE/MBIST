module counter #(
    parameter length = 10
)(
    input  logic [length-1:0] d_in,
    input  logic              clk,
    input  logic              ld,
    input  logic              u_d,
    input  logic              cen,
    output logic [length-1:0] q,
    output logic              cout
);

    always_ff @(posedge clk) begin
        if (cen) begin
            if (ld) begin
                q <= d_in;
                cout <= 1'b0;
            end 
            else if (u_d) begin
                if (q == {length{1'b1}}) begin
                    q <= '0;
                    cout <= 1'b1;
                end else begin
                    q <= q + 1'b1;
                    cout <= 1'b0;
                end
            end 
            else begin
                if (q == '0) begin
                    q <= {length{1'b1}};
                    cout <= 1'b1;
                end 
                else begin
                    q <= q - 1'b1;
                    cout <= 1'b0;
                end
            end
        end
    end

endmodule