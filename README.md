# 🧪 MBIST Project – 64×8 SRAM Built-In Self-Test  

**Course:** ECE-GY 6443: VLSI System and Architecture Design — Spring 2025  
**Author:** Naveen Kumar Senthil Kumar  

---

## 📘 Overview
This repository contains the complete **Memory Built-In Self-Test (MBIST)** implementation for a **64 × 8-bit single-port SRAM** using **SystemVerilog**.  
The project demonstrates how on-chip self-test logic can detect SRAM faults without relying on external testers.

The design flow covers:
- RTL development and verification in **Synopsys VCS**
- Functional testbenches for each module
- Synthesis in **Synopsys Design Compiler** with provided SDC timing constraints
- A fully integrated top-level MBIST that flags pass/fail conditions

---

## 🏗️ Architecture
The design follows a modular approach.  
The top-level **BIST** module integrates the following blocks:

| Module | Purpose |
| ------ | ------- |
| **Comparator** | Compares expected test pattern (`data_t`) with SRAM output (`ramout`) and sets flags `eq`, `gt`, `lt`. |
| **Counter** | Parameterized synchronous counter for address generation, timing control, and pattern selection. Supports up/down count, load, and carry-out. |
| **Decoder** | Generates 8-bit test patterns (e.g. `10101010`, `01010101`, `11110000`) from a 3-bit selector to detect stuck-at / pattern-sensitivity faults. |
| **Controller (FSM)** | Two-state finite-state machine controlling reset ↔ test phases using `start`, `NbarT`, and `ld` signals. |
| **Multiplexer** | Parameterized mux to switch address/data lines between normal-mode and BIST-mode sources. |
| **SRAM** | 64×8 single-port synchronous memory with chip-select (`cs`) and read/write (`rwbar`) support. |
| **BIST (Top)** | Integrates all modules, drives SRAM in both modes, monitors pass/fail logic, and exposes `dataout` and `fail` outputs. |

---

## ⚙️ Key Features
- Parameterized design (`size`, `length`) for flexible reuse
- Single generic multiplexer reused for both address and data paths
- Pre-defined on-chip test patterns to detect stuck-at & coupling faults
- Real-time **fail flag** for immediate fault detection
- Synthesizable RTL that meets given SDC constraints at **6 ns clock period**

---

## 📂 Repository Structure
```
MBIST_Project/
│
├── src/
│   ├── comparator.sv
│   ├── counter.sv
│   ├── decoder.sv
│   ├── controller.sv
│   ├── multiplexer.sv
│   ├── sram.sv
│   └── bist.sv
│
├── tb/
│   ├── tb_comparator.sv
│   ├── tb_counter.sv
│   ├── tb_decoder.sv
│   ├── tb_controller.sv
│   ├── tb_multiplexer.sv
│   ├── tb_sram.sv
│   └── tb_bist.sv
│
├── constraints/
│   └── controller.sdc
│
└── README.md
```

---

## ▶️ Simulation
- **Simulator:** Synopsys VCS (or any SystemVerilog simulator such as Icarus Verilog)
- Verify each submodule with its testbench before running the integrated BIST testbench.

**Example VCS commands:**
```bash
vcs -sverilog src/*.sv tb/tb_bist.sv -o simv
./simv
```
Open generated waveforms in DVE/Verdi or your preferred viewer.

---

## 🛠️ Synthesis
- **Tool:** Synopsys Design Compiler  
- Apply the supplied **SDC constraints**:
```tcl
create_clock -period 6 -name clk [get_ports clk]
set_input_delay 0.1  -clock clk [all_inputs]
set_output_delay 0.15 -clock clk [all_outputs]
set_load 0.1 [all_outputs]
set_max_fanout 1 [all_inputs]
set_fanout_load 8 [all_outputs]
set_clock_uncertainty 0.01 [all_clocks]
set_clock_latency 0.01 -source [get_ports clk]
```
- Optimize RTL or adjust clock period if timing violations occur.

---

## ✅ Results
- All submodules passed functional simulation with expected waveforms.
- The integrated **MBIST successfully detected injected SRAM faults**.
- Timing closure achieved at **6 ns clock period** after synthesis.

---

## 🚀 Quick Start
1. Clone this repo:
```bash
git clone https://github.com/<your-username>/MBIST_Project.git
cd MBIST_Project
```
2. Compile & simulate using your preferred simulator.  
3. Inspect waveforms for functional verification.  
4. Synthesize using Design Compiler with `controller.sdc`.

---

## 📄 License
This project is released under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👤 Author
**Naveen Kumar Senthil Kumar**  
M.S. Computer Engineering, NYU Tandon  
📧 [ns6503@nyu.edu](mailto:ns6503@nyu.edu)
