module top_module #(
    parameter int HEIGHT = 8,
    parameter int WIDTH = 8,
    parameter int NUM_PIXELS = HEIGHT * WIDTH
) (
    input logic clk,
    input logic start,
    input logic reset,
    input logic valid,
    input logic [7:0] in_pixel,
    output logic [10:0] edge_out,
    output logic buffer_full
);

localparam int PIPE_LATENCY = (2 * WIDTH) + 5;

logic [PIPE_LATENCY:0] valid_pipe;


logic [7:0] left0;
logic [7:0] mid0;
logic [7:0] right0;
logic [7:0] left1;
logic [7:0] mid1;
logic [7:0] right1;
logic [7:0] left2;
logic [7:0] mid2;
logic [7:0] right2;
logic [10:0] edge_scaled;
logic [9:0] x_edge_scaled;
logic [9:0] y_edge_scaled;
logic edge_valid;
logic read_done;
logic read_enable;
logic done;


fsm u_fsm (
    .clk(clk),
    .reset(reset),
    .start(start),
    .buffer_full(buffer_full),
    .read_done(read_done),
    .read_enable(read_enable),
    .done(done)
);

window_generator u_wg (
    .clk(clk),
    .pixel(in_pixel),
    .valid(valid),
    .reset(reset),
    .left0(left0),
    .mid0(mid0),
    .right0(right0),
    .left1(left1),
    .mid1(mid1),
    .right1(right1),
    .left2(left2),
    .mid2(mid2),
    .right2(right2)
);

convolution u_convolution (
    .left0(left0),
    .mid0(mid0),
    .right0(right0),
    .left1(left1),
    .mid1(mid1),
    .right1(right1),
    .left2(left2),
    .mid2(mid2),
    .right2(right2),
    .x_edge_pixel(x_edge_scaled),
    .y_edge_pixel(y_edge_scaled),
    .edge_scaled(edge_scaled)
);

buffer u_buffer (
    .clk(clk),
    .read_enable(read_enable),
    .reset(reset),
    .edge_valid(edge_valid),
    .edge_scaled(edge_scaled),
    .edge_out(edge_out),
    .buffer_full(buffer_full),
    .read_done(read_done)
);

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        valid_pipe <= '0;
    end else begin
        valid_pipe <= {valid_pipe[PIPE_LATENCY-1:0], valid};
    end
end

assign edge_valid = valid_pipe[PIPE_LATENCY];




endmodule