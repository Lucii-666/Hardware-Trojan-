# Multi-Scale Hardware Trojan Detection

This directory contains ALU implementations across three different bit-widths, demonstrating the scalability and robustness of side-channel detection methodology.

## Directory Structure

```
designs/
├── 4bit/           # 4-bit ALU (Embedded Systems)
│   ├── rtl/        # Verilog source files
│   ├── testbench/  # Verification testbenches
│   └── results/    # VCD files and analysis outputs
│
├── 8bit/           # 8-bit ALU (Microcontrollers)
│   ├── rtl/
│   ├── testbench/
│   └── results/
│
└── 16bit/          # 16-bit ALU (Processors)
    ├── rtl/
    ├── testbench/
    └── results/
```

## Design Specifications

| Bit-Width | Clean Signals | Trojan Signals | Trigger Condition | Activation Rate |
|-----------|--------------|----------------|-------------------|-----------------|
| **4-bit** | 7 | +4 backdoor | A=0xF && B=0xF | 1/256 (0.4%) |
| **8-bit** | 8 | +4 backdoor | A=0xFF && B=0xFF | 1/65536 (0.0015%) |
| **16-bit** | 9 | +6 backdoor | A=0xFFFF && B=0xFFFF | 1/4B (~0%) |

## Trojan Characteristics

### 4-bit Trojan
- **Trigger**: Maximum values on both inputs (rare but testable)
- **Payload**: Single-bit XOR corruption
- **Signals**: 4 extra (trojan_trigger, trojan_active, trigger_counter, payload_mask)

### 8-bit Trojan
- **Trigger**: Maximum 8-bit values (extremely rare)
- **Payload**: 2-bit XOR corruption
- **Signals**: 4 extra with enhanced state machine

### 16-bit Trojan
- **Trigger**: Maximum 16-bit values (nearly impossible to hit functionally)
- **Payload**: Multi-level corruption (1-5 bits based on activation level)
- **Signals**: 6 extra with multi-stage activation mechanism

## Key Demonstration

This multi-scale implementation proves:

1. **Scalability**: Detection works regardless of bit-width
2. **Universality**: Same side-channel method for all designs
3. **Effectiveness**: Even 1-in-4-billion triggers are detectable
4. **Practicality**: Analysis completes in <1 second per design

## Running the Analysis

```powershell
# Run all bit-widths
python run_multiscale_detection.py

# View comparison
python compare_bitwidths.py
```

## Expected Results

Each design produces:
- VCD waveform files (clean and trojan)
- Toggle count analysis
- Statistical deviation reports
- Visual detection graphs
- 100% detection rate across all bit-widths

---

*This demonstrates that side-channel analysis is a robust, scalable solution for hardware Trojan detection across different design complexities.*
