"""
Quick launcher for multi-bit-width detection
Run this to execute all three designs at once
"""

import subprocess
import sys

print("""
╔══════════════════════════════════════════════════════════════╗
║   MULTI-SCALE HARDWARE TROJAN DETECTION                     ║
║   4-bit, 8-bit, and 16-bit ALU Analysis                     ║
╚══════════════════════════════════════════════════════════════╝
""")

print("Choose an option:\n")
print("  [1] Run ALL bit-widths (4, 8, 16-bit)")
print("  [2] Run ONLY 4-bit")
print("  [3] Run ONLY 8-bit")
print("  [4] Run ONLY 16-bit")
print("  [5] View comparison (no simulation)")
print("  [0] Exit\n")

choice = input("Enter choice (1-5): ").strip()

if choice == "1":
    print("\n🚀 Running multi-scale detection...\n")
    subprocess.run([sys.executable, "run_multiscale_detection.py"])

elif choice == "2":
    print("\n🔬 Running 4-bit detection...\n")
    subprocess.run([sys.executable, "run_analysis.py"])

elif choice == "3":
    print("\n🔬 Running 8-bit detection...\n")
    # Run 8-bit simulation and analysis
    import os
    from pathlib import Path
    
    design_dir = Path("designs/8bit")
    os.chdir(design_dir)
    
    # Compile and run clean
    print("[1/4] Compiling 8-bit clean ALU...")
    subprocess.run("iverilog -o results/clean.vvp rtl/alu_8bit_clean.v testbench/tb_alu_8bit_clean.v", shell=True)
    print("[2/4] Simulating 8-bit clean ALU...")
    subprocess.run("vvp results/clean.vvp", shell=True)
    
    # Compile and run trojan
    print("[3/4] Compiling 8-bit trojan ALU...")
    subprocess.run("iverilog -o results/trojan.vvp rtl/alu_8bit_trojan.v testbench/tb_alu_8bit_trojan.v", shell=True)
    print("[4/4] Simulating 8-bit trojan ALU...")
    subprocess.run("vvp results/trojan.vvp", shell=True)
    
    # Move VCD files
    for vcd in ["alu_8bit_clean.vcd", "alu_8bit_trojan.vcd"]:
        if Path(vcd).exists():
            Path(vcd).rename(f"results/{vcd}")
    
    os.chdir("../..")
    print("\n✅ 8-bit simulation complete! VCD files in designs/8bit/results/")

elif choice == "4":
    print("\n🔬 Running 16-bit detection...\n")
    # Run 16-bit simulation and analysis
    import os
    from pathlib import Path
    
    design_dir = Path("designs/16bit")
    os.chdir(design_dir)
    
    # Compile and run clean
    print("[1/4] Compiling 16-bit clean ALU...")
    subprocess.run("iverilog -o results/clean.vvp rtl/alu_16bit_clean.v testbench/tb_alu_16bit_clean.v", shell=True)
    print("[2/4] Simulating 16-bit clean ALU...")
    subprocess.run("vvp results/clean.vvp", shell=True)
    
    # Compile and run trojan
    print("[3/4] Compiling 16-bit trojan ALU...")
    subprocess.run("iverilog -o results/trojan.vvp rtl/alu_16bit_trojan.v testbench/tb_alu_16bit_trojan.v", shell=True)
    print("[4/4] Simulating 16-bit trojan ALU...")
    subprocess.run("vvp results/trojan.vvp", shell=True)
    
    # Move VCD files
    for vcd in ["alu_16bit_clean.vcd", "alu_16bit_trojan.vcd"]:
        if Path(vcd).exists():
            Path(vcd).rename(f"results/{vcd}")
    
    os.chdir("../..")
    print("\n✅ 16-bit simulation complete! VCD files in designs/16bit/results/")

elif choice == "5":
    print("\n📊 Viewing comparison...\n")
    subprocess.run([sys.executable, "compare_bitwidths.py"])

else:
    print("\n👋 Exiting...")
    sys.exit(0)

print("\n" + "="*70)
print("  DONE! Check the results/ folders for each bit-width")
print("="*70 + "\n")
