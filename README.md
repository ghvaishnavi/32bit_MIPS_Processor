# 32bit_MIPS_Processor
A 32-bit pipelined MIPS processor designed and simulated in Verilog (by Vaishnavi G H). Includes hazard detection, forwarding, and full 5-stage pipeline.
# 🧠 Pipelined MIPS Processor in Verilog  
### 👩‍💻 Designed by: Vaishnavi G H  
### 📅 Date: March 2026  
### 🧩 Tool Used: Xilinx Vivado / ModelSim

---

## 🚀 Project Overview

This project implements a **32-bit 5-stage pipelined MIPS processor** using **Verilog HDL**.  
It demonstrates the classic RISC architecture pipeline stages:

> **Fetch → Decode → Execute → Memory → Writeback**

The design includes key concepts such as:
- Instruction and Data Memory
- Forwarding Unit to resolve data hazards
- Hazard Detection Unit for stall and flush control
- Register File, ALU, and Control Unit
- Support for basic MIPS instructions (R-type, I-type, and J-type)

---

## ⚙️ Architecture Overview

### 🔸 Pipeline Stages:
1. **Instruction Fetch (IF)** – Fetches instruction from memory  
2. **Instruction Decode (ID)** – Decodes instruction and reads registers  
3. **Execute (EX)** – Performs ALU operations  
4. **Memory (MEM)** – Reads/Writes data memory  
5. **Write Back (WB)** – Writes results back to the register file  

### 🔸 Key Features:
- 32-bit data path  
- Fully pipelined architecture  
- Data forwarding to reduce stalls  
- Branch and jump handling  
- Modular Verilog design with reusable components  

---

## 📁 Project Directory Structure
