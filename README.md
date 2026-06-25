# 8bit-integer-calculator-systemverilog

# 8-bit Integer Calculator using SystemVerilog

## Overview

This project implements a fully synchronous 8-bit integer calculator using SystemVerilog. The calculator accepts numeric and operator inputs through a keypad, processes arithmetic and logic operations, and displays the input or computed result on a 7-segment display.

The system is designed using a modular RTL structure, including synchronizer, hexadecimal code generator, control unit, arithmetic logic unit, barrel shifter, and input/output converter blocks.

## Features

* 8-bit integer calculation with operands from 0 to 255
* Keypad input using row and column scanning
* Hexadecimal key decoding for number and operator input
* Arithmetic operations: addition, subtraction, multiplication, and division
* Bitwise operations such as AND, OR, XOR, and NOT
* Shift operations using barrel shifter
* 7-segment display output
* Overflow and negative result indication
* System reset support
* Block-level and full-chip testbench verification

## System Architecture

The calculator system is divided into the following RTL blocks:

```text
syncb  - Synchronizer block
hexcb  - Hexadecimal code generator block
cub    - Control unit block
alub   - Arithmetic logic unit block
bsb    - Barrel shifter block
iocb   - Input/output converter block
ics    - Top-level integer calculator system
```

## My Contribution

My main contribution was the input/output converter block. This block converts calculator input and computed results into displayable 7-segment output. It also handles result display formatting, binary-to-decimal conversion, overflow display, and negative value indication.

## Technologies Used

* SystemVerilog
* RTL Design
* Vivado Simulator
* Digital Logic Design
* 7-segment Display
* Keypad Interface

## Project Structure

```text
rtl/     SystemVerilog RTL source files
tb/      Testbench files
doc/    Architecture and verification documentation
```

## Verification

The design was verified using SystemVerilog testbenches. Test cases include reset operation, keypad input, arithmetic operations, bitwise operations, shift operations, overflow handling, division by zero, and 7-segment display output verification.

## Status

Completed
