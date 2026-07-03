# SPI-to-UART FPGA Bridge

This project implements a hardware communication pipeline on a Xilinx Artix-7 FPGA that receives encoded data over SPI, applies rule-based processing in RTL, and transmits results over UART for real-time observation on a host computer.

The design was written in SystemVerilog and organized into modular components including a clock-domain crossing synchronizer, SPI bit receiver, edge detector, finite state machine (FSM) controller, FIFO buffer, and UART transmitter. An Arduino-based SPI master sends encoded 3-byte messages over a 6 MHz SPI bus, and a Python viewer decodes the UART output for debugging and visualization.

## Features

- SPI slave interface implemented in SystemVerilog
- Clock-domain crossing synchronization
- Edge detection for SPI clock/data sampling
- FSM-based control flow
- FIFO buffering for streamed data
- UART transmitter for host communication
- Arduino SPI master test source
- Python UART viewer / decoder
- End-to-end simulation and hardware verification

## System Overview

The data flow is:

**Arduino SPI Master → FPGA SPI Receiver → Rule-Matching Logic → FIFO → UART Transmitter → Python Viewer**

The FPGA receives 3-byte SPI messages, decodes them in RTL, applies conditional logic, and outputs the result over UART. This makes it possible to test and debug the system in real time.

