`timescale 1ns/1ps

module top_module_tb;


localparam int NUM_PIXELS = 64;
localparam int WIDTH = 8;
localparam int DEPTH = 8;
localparam int PIPE_LATENCY = (2 * WIDTH) + 5;
logic clk;
logic reset;
logic valid;
logic start;
logic [7:0] in_pixel;
logic [9:0] x_edge_scaled;
logic [9:0] y_edge_scaled;
logic [10:0] edge_scaled;
logic [10:0] edges [0:NUM_PIXELS-1];
logic [9:0] x_edges [0:NUM_PIXELS-1];
logic [9:0] y_edges [0:NUM_PIXELS-1];
logic [7:0] pixels [0:NUM_PIXELS-1];
int in_counter;
int j;
int i;
logic [$clog2(PIPE_LATENCY):0] k;
int out_counter;
logic edge_valid;
logic [10:0] edge_out;


top_module top_module_t (
    .clk(clk),
    .start(start),
    .reset(reset),
    .valid(valid),
    .in_pixel(in_pixel),
    .edge_out(edge_out),
    .buffer_full(buffer_full)
);


initial begin
    in_pixel = 8'b0;
    clk = 0;
    in_counter = 0;
    out_counter = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("edge out: %b", edge_out);
end


initial begin
    $readmemb("../Python/image.mem", pixels);
    valid = 0;
    reset = 1;
    repeat (2) @(negedge clk);
    valid = 1;
    reset = 0;
    start = 1;
    repeat (2) @(negedge clk);
    start = 0;
    
    for (i = 0; i < NUM_PIXELS; i++) begin
        @(negedge clk);
        in_pixel = pixels[in_counter];
        in_counter = in_counter + 1;
        @(posedge clk);
        #1;
    end

    repeat (2) @(negedge clk);
    valid = 0;
    in_pixel = 8'b0;

    repeat (10) @(negedge clk);

    // for (j = 0; j < NUM_PIXELS - 15; j++) begin
    //     $display("Edge %0d: %d, in_pixel: %b", j, edges[j], pixels[j]);
    // end
    // $display("buffer full: %b", top_module_t.u_buffer.buffer_full);
    // $display("read done: %b", top_module_t.u_buffer.read_done);
    // $display("read_ptr %d", top_module_t.u_buffer.read_ptr);
    // $display("write_ptr %d", top_module_t.u_buffer.write_ptr);
    // $display("read_enable %b", top_module_t.u_buffer.read_enable);
    // $display("STATE: %b", top_module_t.u_fsm.state);
    // for (j = 0; j < PIPE_LATENCY; j++) begin
    //     $display("edge pixel: %b", top_module_t.u_buffer.edge_pixels[j]);
    // end
    wait(top_module_t.done);
    $finish;
end



endmodule