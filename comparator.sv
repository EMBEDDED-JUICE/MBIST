module comparator (
    input  logic [7:0] data_t,
    input  logic [7:0] ramout,
    output logic       gt,
    output logic       eq,
    output logic       lt
);
    
    always_comb begin
        eq = (data_t == ramout);
        gt = (data_t > ramout);
        lt = (data_t < ramout);
    end
    
endmodule