# FPGA Streaming Sobel Edge Detection Accelerator

A streaming Sobel edge detection accelerator written in SystemVerilog. The design processes one pixel per clock after pipeline fill using line buffers and a sliding 3×3 window, then stores the processed edge image in inferred FPGA block RAM.

This project was built to demonstrate FPGA-oriented RTL design techniques including streaming architectures, pipelining, finite state machines, inferred memory, and hardware/software verification.

---

## Features

- Streaming image processing architecture
- 3×3 sliding window generation
- Sobel X and Sobel Y convolution
- Gradient magnitude calculation
- Thresholding
- Fully pipelined datapath
- Output buffer using inferred RAM
- Controller FSM
- Python image preprocessing for RTL simulation


## RTL Modules

### line_buffer.sv

Stores previous image rows to enable streaming 3×3 window generation.

---

### window_generator.sv

Produces a continuous 3×3 sliding window from the incoming pixel stream.

---

### convolution.sv

Computes

- Sobel X
- Sobel Y
- Gradient magnitude
- Thresholded edge output

---

### buffer.sv

Stores valid edge pixels into inferred RAM.

Provides

- write pointer
- read pointer
- buffer full detection
- read complete detection
