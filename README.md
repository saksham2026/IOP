# Single Cycle Core

We will build a **Single Cycle Processor** using the **RISC-V ISA**.
I have used **Verilog** as **HDL**.

## 📂 Project Structure

The project contains the following main folders:

- **`Components`/** → Contains all the individual modules used in the processor design.
- **`Testbench/`** → Holds testbenches for verifying each module.
- **`Output/`** → Stores the simulation files. `.vcd` files are included for waveform analysis in **GTKWave**.

This tutorial will explain how to use these **testbenches** and **`.vcd` files** to verify the processor design.

---

## INSTALLING GTKWAVE AND ICARUS VERILOG.

### WINDOWS

- `ICARUS VERILOG` → https://bleyer.org/icarus/

This will install both gtkwave and icarus verilog. I will suggest windows users to 
use VS code as the code editor.

### LINUX

First update the apt by writing the following command in the terminal:

```bash
sudo apt-get update
```

Once the apt is updated, We will install Icarus Verilog with the given command:

```bash
sudo apt-get install iverilog
```

After this we will install gtkwave:

```bash
sudo apt-get install gtkwave
```


## 🔹 Clone the Repository

To clone this repository, run the following command in your terminal:

```bash
git clone https://github.com/saksham2026/IOP.git
```

## Simulation

```bash
iverilog -o Output/moduleName_sim Testbench/moduleName_tb.v Components/moduleName.v
vvp Output/moduleName_sim
```

This will give you the display results, if there were any in the testbench.
After this run the following command to see the simulation:

```bash
gtkwave Dumpfiles/moduleName_tb.vcd
```



## 🖩 ALU (Arithmetic Logic Unit)

### 🔹 **INPUTS**

The ALU takes two **32-bit operands** as inputs along with a **4-bit `aluControl` signal**, which determines the operation.

- `operandA` → First operand (32-bit)
- `operandB` → Second operand (32-bit)
- `aluControl` → Operation selector (4-bit)

### 🔹 **OUTPUTS**

The ALU produces a **32-bit result** based on the operation.

- `result` → Output (32-bit)

### 🔹 **Supported ALU Operations**

The ALU can perform **10 operations**, determined by the `aluControl` signal:

| **Operation** | **Description** | **`aluControl` Value** |
|--------------|----------------|------------------|
| **ADD**  | Addition | `4'b0000` |
| **SUB**  | Subtraction | `4'b0001` |
| **AND**  | Bitwise AND | `4'b0010` |
| **OR**   | Bitwise OR | `4'b0011` |
| **XOR**  | Bitwise XOR | `4'b0100` |
| **SLL**  | Shift Left Logical | `4'b0101` |
| **SRL**  | Shift Right Logical | `4'b0110` |
| **SRA**  | Shift Right Arithmetic | `4'b0111` |
| **SLTU** | Set Less Than Unsigned | `4'b1000` |
| **SLT**  | Set Less Than (Signed) | `4'b1001` |

---

## 🖩 INSTRUCTION MEMORY

### 🔹 **INPUTS**
- `reset` → initialize instruction memory to zero
- `chip_select` → for any operation on the chip, this should be high
- `address` → 32'b address of the instruction to be fetched

### 🔹 **OUTPUTS**

- `instruction` → 32'b fetched instruction

Instruction memory is a Read Only Memory. We have used .mif file to initialize it.

## 🔗 **Resources**

- [RISC-V ISA Specification](https://riscv.org/technical/specifications/)
