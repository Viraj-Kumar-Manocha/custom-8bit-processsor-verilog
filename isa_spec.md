# Instruction Set Architecture (ISA) Specification

## Overview

- **Instruction Width:** 24 bits
- **Data Width:** 8 bits
- **Register Address Width:** 5 bits (supports up to 32 registers)
- **Opcode Width:** 5 bits

Every instruction is 24 bits wide. The upper 5 bits (`inst[23:19]`) are always the opcode. The remaining 19 bits are interpreted differently depending on the instruction type (R-type, Immediate-type, Memory-type, or Branch/Jump-type).

---

## Instruction Formats

### 1. R-Type (Register-Register ALU Operations)

Used for: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `MOVE`

| Bits    | 23:19  | 18:14 | 13:9 | 8       | 7:0     |
|---------|--------|-------|------|---------|---------|
| Field   | opcode | rd    | rs   | unused  | imm8    |

- `rd` — destination register
- `rs` — source register
- `imm8` — not used for R-type (ALU source is register, `alu_src = 0`)

### 2. I-Type (Immediate ALU Operation)

Used for: `ADDI`

| Bits    | 23:19  | 18:14 | 13:9 | 8       | 7:0     |
|---------|--------|-------|------|---------|---------|
| Field   | opcode | rd    | rs   | unused  | imm8    |

- Same layout as R-type, but `alu_src = 1`, so the ALU takes `imm8` instead of `rs` as its second operand.

### 3. Memory-Type (Load/Store)

Used for: `LOAD`, `STORE`

| Bits    | 23:19  | 18:14 | 13:2         | 1:0     |
|---------|--------|-------|--------------|---------|
| Field   | opcode | rd    | mem_addr(12) | unused  |

- `rd` — register to load into / store from
- `mem_addr` — 12-bit memory address (`inst[13:2]`)
- Bottom 2 bits are unused

### 4. Branch/Jump-Type

Used for: `BEQ` (conditional branch), `JMP` (unconditional jump)

| Bits    | 23:19  | 18:14 | 13:9 | 8       | 7:0     |
|---------|--------|-------|------|---------|---------|
| Field   | opcode | rd    | rs   | unused  | imm8    |

- For `BEQ`: `rd` and `rs` are compared via ALU subtraction; if the zero flag is set, the branch is taken.
- For `JMP`: `rd`/`rs` fields are unused; `imm8` gives the number of instructions to jump (offset).
- `imm8` is used as the branch/jump offset for both.

---

## Opcode Table

| Mnemonic | Opcode (`inst[23:19]`) | Type      | ALU Op   | reg_we | mem_read | mem_write | alu_src | mem_to_reg | is_mem_inst | is_branch | branch_type |
|----------|-------------------------|-----------|----------|--------|----------|-----------|---------|------------|-------------|-----------|-------------|
| ADD      | `00000`                 | R-Type    | `0000`   | 1      | 0        | 0         | 0       | 0          | 0           | 0         | –           |
| SUB      | `00001`                 | R-Type    | `0001`   | 1      | 0        | 0         | 0       | 0          | 0           | 0         | –           |
| AND      | `00010`                 | R-Type    | `0010`   | 1      | 0        | 0         | 0       | 0          | 0           | 0         | –           |
| OR       | `00011`                 | R-Type    | `0011`   | 1      | 0        | 0         | 0       | 0          | 0           | 0         | –           |
| XOR      | `00100`                 | R-Type    | `0100`   | 1      | 0        | 0         | 0       | 0          | 0           | 0         | –           |
| ADDI     | `00101`                 | I-Type    | `0000`   | 1      | 0        | 0         | 1       | 0          | 0           | 0         | –           |
| LOAD     | `00110`                 | Memory    | –        | 1      | 1        | 0         | 0       | 1          | 1           | 0         | –           |
| STORE    | `00111`                 | Memory    | –        | 0      | 0        | 1         | 0       | 0          | 1           | 0         | –           |
| BEQ      | `01000`                 | Branch    | `0001`   | 0      | 0        | 0         | 0       | 0          | 0           | 1         | 0           |
| JMP      | `01001`                 | Branch    | –        | 0      | 0        | 0         | 0       | 0          | 0           | 1         | 1           |
| MOVE     | `01010`                 | R-Type    | `1001`   | 1      | 0        | 0         | 0       | 0          | 0           | 0         | –           |

> All opcodes not listed above fall into the `default` case in the decoder, which produces a safe no-op (all control signals de-asserted).

---

## Control Signal Reference

| Signal        | Width | Description                                             |
|---------------|-------|-----------------------------------------------------------|
| `alu_op`      | 4     | Selects the ALU operation                                  |
| `reg_we`      | 1     | Register file write enable                                  |
| `mem_read`    | 1     | Enables read from data memory                               |
| `mem_write`   | 1     | Enables write to data memory                                 |
| `alu_src`     | 1     | 0 = second ALU operand is `rs`, 1 = second operand is `imm8` |
| `mem_to_reg`  | 1     | 1 = value written to register comes from memory (LOAD)      |
| `is_mem_inst` | 1     | Indicates a LOAD/STORE instruction                            |
| `is_branch`   | 1     | Indicates a BEQ/JMP instruction                                |
| `branch_type` | 1     | 0 = BEQ (conditional), 1 = JMP (unconditional)                 |
