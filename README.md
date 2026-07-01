# 🧠 Custom 8-Bit Processor with 24-Bit ISA

A fully custom 8-bit CPU designed from scratch in **Verilog**, featuring a 24-bit instruction set architecture (ISA), a modular datapath, and complete unit + system-level verification. Synthesized to run at a maximum frequency of **~407 MHz**.

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Vivado](https://img.shields.io/badge/Tool-Xilinx%20Vivado-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## 📖 Overview

This project implements a custom **8-bit processor** built entirely from the ground up — from the ALU to the top-level datapath — using a **24-bit instruction word** for extended opcode and operand flexibility. It supports arithmetic/logic operations, immediate operations, memory access, and control-flow instructions (branch/jump).

Every module (ALU, Register File, Memory, Decoder, Program Counter, etc.) was individually designed, verified with its own testbench, and then integrated into a top-level CPU that was validated by running a **Fibonacci sequence generator program** end-to-end. The design was then synthesized in Xilinx Vivado to evaluate real hardware performance.

This project was built to deepen understanding of computer architecture fundamentals — instruction decoding, datapath control, and single cycle hardware design — by implementing every stage manually in RTL rather than using a pre-built core.

---

## ✨ Features

- 🔧 **Custom 24-bit ISA** — wide instruction word allowing room for opcode, register addressing, and immediate fields
- ⚙️ **Modular Datapath** — cleanly separated ALU, Register File, Decoder, PC, and Memory modules
- ➕ **Arithmetic & Logic Operations** — ADD, SUBTRACT, AND, OR, XOR
- 🔢 **Immediate Operations** — ADD Immediate (ADDI)
- 🔀 **Control Flow** — BRANCH and JUMP instructions
- 💾 **Memory Access** — LOAD and STORE between Register File and Data Memory
- 🧪 **Fully Verified** — individual testbenches for every module + a full top-level system test
- 🐇 **Real Program Execution** — validated by running a Fibonacci sequence generator on the CPU
- 📊 **Synthesized Design** — timing analysis performed, achieving ~407 MHz max operating frequency

---

## 🏗️ Architecture

```
                ┌─────────────────────┐
                │   Program Counter    │
                └──────────┬───────────┘
                           │
                ┌──────────▼───────────┐
                │  Instruction Memory   │
                └──────────┬───────────┘
                           │ (24-bit Instruction)
                ┌──────────▼───────────┐
                │       Decoder         │
                └──────────┬───────────┘
                           │
          ┌────────────────┼─────────────────┐
          │                │                 │
┌─────────▼────────┐ ┌─────▼──────┐  ┌───────▼────────┐
│   Register File    │ │    ALU     │  │  Control Signals │
└─────────┬────────┘ └─────┬──────┘  └───────┬────────┘
          │                │                 │
          └────────────────┼─────────────────┘
                           │
                ┌──────────▼───────────┐
                │      Data Memory       │
                └──────────┬───────────┘
                           │
                ┌──────────▼───────────┐
                │    Writeback / Top     │
                └───────────────────────┘
```

> All modules above are connected via the **Datapath**, which is orchestrated by the **Top Module**.

---

## 📂 Repository Structure

```
custom-8bit-cpu/
│
├── rtl/                          # Design source files
│   ├── alu.v                     # Arithmetic Logic Unit (perform 8 bit operations between 2 operands)
│   ├── reg_file.v                # Register File (32*8 bit registers, with x0 hardwired to zero)
│   ├── data_memory_4kB.v         # Data Memory (4kB, 4096*8 bits)
│   ├── instruction_memory.v      # Instruction Memory (0.75 kB, supports upto 256 instructions at once)
│   ├── decoder.v                 # Instruction Decoder
│   ├── program_counter.v         # Program Counter 
│   ├── datapath.v                # Datapath integration without PC and Instruction Memory
│   └── top_module.v              # Top-level CPU module (complete end-to-end cpu) 
│
├── tb/                           # Verification files
│   ├── testbench_alu.v
│   ├── testbench_reg_file.v
│   ├── testbench_memory.v
│   ├── testbench_datapath.v
│   ├── testbench_decoder.v
│   ├── testbench_fibonacci.v         # Top-level test: Fibonacci sequence , self checking
│   └── testbench_2.v                 # Top-level test: tests the jump operation , self checking     
│
├── constraints/                  # Timing Constraints
│   └──timing_constraints.xdc     #XDC Constraints file used for synthesis
│
├── synthesis/                    # Synthesis outputs
│   ├── cpu_timing.rpx            # Timing / utilization report, synthesis report of top module
│   └── timing_summary.png        # Max frequency screenshot
│
├── docs/                          # Documentation
│   ├── isa_spec.md                # Instruction set details
│   └── schematics
│       ├── cpu_schematic.png                        #design of top module
│       ├── Elaborated_cpu_schematic.png             #design of top module, with all components expanded,except reg_file and memory
│
│
├── LICENSE
│
└── README.md
```


---

## 🧾 Instruction Set (ISA) Overview

| Category         | Instructions                      |
|------------------|-----------------------------------|
| Arithmetic       | ADD, SUB                          |
| Logic            | AND, OR, XOR                      |
| Immediate        | ADDI                              |
| Memory Access    | LOAD, STORE                       |
| Control Flow     | BRANCH, JUMP                      |

- **Instruction Width:** 24 bits
- **Data Width:** 8 bits

> See [`docs/isa_spec.md`](docs/isa_spec.md) for the full opcode table and instruction encoding format.

---

## 🧪 Testing & Verification

Each module was verified independently before system integration:

| Module              | Testbench                       |   Status   |
|---------------------|---------------------------------|:----------:|
| ALU                 | `tb_alu.v`                      | ✅ Passed  |
| Register File       | `tb_reg_file.v`                 | ✅ Passed  |
| Data Memory         | `tb_memory.v`                   | ✅ Passed  |
| Instruction Memory  | `tb_instruction_memory.v`       | ✅ Passed  |
| Decoder             | `tb_decoder.v`                  | ✅ Passed  |
| Program Counter     | `tb_program_counter.v`          | ✅ Passed  |
| **Top Module**      | `tb_top_fibonacci.v`            | ✅ Passed  |

### 🐇 System-Level Test — Fibonacci Sequence

The complete CPU was validated by loading a Fibonacci sequence generator program into instruction memory and running it through the fully integrated datapath. The correct sequence was produced and verified against expected values, confirming that instruction fetch, decode, execution, memory access, and register writeback all function correctly together.

---

## 📊 Synthesis Results

The design was synthesized using **Xilinx Vivado**.

| Metric                     | Result              |
|----------------------------|---------------------|
| Max Operating Frequency    | **~407 MHz**        |
| Target Tool                | Xilinx Vivado       |
| HDL                        | Verilog             |

### 📐 Max Frequency Calculation

Fmax is derived from the Worst Negative Slack (WNS) reported by Vivado's timing analysis:

Achievable Clock Period = Target Clock Period − WNS  
Fmax = 1 / Achievable Clock Period

Target Period = 10.000 ns → WNS = +7.543 ns → Achievable Period = 2.457 ns → Fmax ≈ 407 MHz

Target Period = 3.000 ns → WNS = +0.544 ns → Achievable Period = 2.457 ns → Fmax ≈ 407 MHz

Target Period = 2.457 ns → WNS = +0.000 ns → Achievable Period = 2.457 ns → Fmax ≈ 407 MHz


> 📄 Full synthesis and timing reports available in [`cpu_timing`](synthesis/cpu_timing.rpx).

---

## 🖼️ Schematics

Top-level RTL schematic generated in Vivado:

![Top Module Schematic](docs/schematics/cpu_schematic.png)

Additional module-level schematics available in [`docs/schematics/`](docs/schematics/).


## 🚀 Getting Started

### Prerequisites
- [Xilinx Vivado](https://www.xilinx.com/support/download.html) (Design Suite)

### Running Simulations
1. Clone the repository:
   ```bash
   git clone https://github.com/Viraj-Kumar-Manocha/custom-8bit-processor-verilog.git
   cd custom-8bit-processor-verilog
   ```
2. Open Vivado and create a new project, adding all files from `rtl/` as design sources.
3. Add the desired testbench from `testbench/` as a simulation source.
4. Run **Behavioral Simulation** to view waveforms in the Vivado waveform viewer.

### Running Synthesis
1. With all `rtl/` files added as design sources, run **Synthesis** in Vivado.
2. Open the **Timing Summary** report to view the achievable maximum frequency.

---

## 🔮 Future Improvements

- Add support for additional ALU operations (multiply, shift)
- Implement pipelining to improve throughput
- Add hazard detection and forwarding logic
- Expand instruction set with more control-flow instructions

---

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 🙋 Author

 **[ Viraj Kumar Manocha ]**
   
   Undergraduate at Indian Institue of Technology Ropar

Feel free to connect or reach out for questions/collaboration!
[LinkedIn](https://www.linkedin.com/in/viraj-kumar-818aa0321/)
