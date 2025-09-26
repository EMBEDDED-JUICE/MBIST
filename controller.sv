module controller (
    input logic start,
    input logic rst,
    input logic clk,
    input logic cout,
    output logic NbarT,
    output logic ld
);

typedef enum logic {RESET, TEST} state_t;

state_t state, next_state;

always_ff @(posedge clk) begin :FSM
    if (rst) 
        state <= RESET;
    else 
        state <= next_state;
end    

always_comb begin : next_state_logic
    case (state)
        RESET: next_state = start ? TEST : RESET;
        TEST: next_state = cout ? RESET : TEST;
        default: next_state = RESET;
    endcase
end

assign NbarT = (state == TEST);
assign ld = (state == RESET);

endmodule