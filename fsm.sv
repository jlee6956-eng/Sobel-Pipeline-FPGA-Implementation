module fsm (
    input logic clk,
    input logic reset,
    input logic start,
    input logic buffer_full,
    input logic read_done,
    output logic read_enable,
    output logic done
);

typedef enum logic [1:0] {
    IDLE,
    WRITE,
    READ,
    DONE
} STATE;

STATE state;
STATE next_state;


always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    next_state = state;
    case (state) 
        IDLE: if (start) next_state = WRITE;
        WRITE: if (buffer_full) next_state = READ;
        READ: if (read_done) next_state = DONE;
        DONE: next_state = IDLE;
    endcase
end

always_comb begin
    case (state)
        IDLE: read_enable = 0;
        WRITE: read_enable = 0;
        READ: read_enable = 1;
        DONE: begin
            read_enable = 0;
            done = 1;
        end

    endcase
end



endmodule