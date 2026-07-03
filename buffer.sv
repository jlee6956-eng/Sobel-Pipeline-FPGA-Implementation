module buffer #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 8,
    parameter int NUM_PIXELS = DEPTH * WIDTH
    ) (
    input logic clk,
    input logic read_enable,
    input logic reset,
    input logic edge_valid,
    input logic [10:0] edge_scaled,
    output logic [10:0] edge_out,
    output logic buffer_full,
    output logic read_done
);

localparam int NUM_OUTPUT_PIXELS = (WIDTH - 2) * (DEPTH - 2);
localparam PIPE_LATENCY = (WIDTH * 2) + 5;
localparam int ADDR_WIDTH = $clog2(NUM_OUTPUT_PIXELS);
logic [ADDR_WIDTH - 1: 0] write_ptr;
logic [ADDR_WIDTH - 1: 0] read_ptr;

(* ram_style = "block" *) logic [10:0] edge_pixels [0:NUM_OUTPUT_PIXELS-1];

always_ff @(posedge clk) begin
    if (reset) begin
        write_ptr <= 0;
        edge_out <= 0;
        // for (i = 0; i < NUM_OUTPUT_PIXELS; i++) begin
        //     edge_pixels[i] <= 11'b0;
        // end
    end else if (edge_valid) begin
        edge_pixels[write_ptr] <= edge_scaled;
        if (write_ptr < NUM_OUTPUT_PIXELS-1) begin
            write_ptr <= write_ptr + 1;
        end
    end
end

always_ff @(posedge clk) begin
    if (reset) begin
        read_ptr <= 0;
    end else if (read_enable && read_ptr < write_ptr) begin
        edge_out <= edge_pixels[read_ptr];
        read_ptr <= read_ptr + 1;
    end
end

assign buffer_full = (write_ptr == NUM_OUTPUT_PIXELS - 1);
assign read_done = (read_ptr == NUM_OUTPUT_PIXELS - 1);


endmodule