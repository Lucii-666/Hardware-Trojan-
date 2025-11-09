"""
Scalable Hardware Trojan Detection System
Supports 4-bit, 8-bit, and 16-bit ALU designs
Demonstrates detection methodology across multiple bit-widths
"""

import os
import sys
import subprocess
from pathlib import Path

class MultiScaleDetector:
    def __init__(self, base_dir="designs"):
        self.base_dir = Path(base_dir)
        self.bit_widths = ['4bit', '8bit', '16bit']
        self.results = {}
        
    def run_simulation(self, bit_width):
        """Run Verilog simulation for specified bit-width"""
        design_dir = self.base_dir / bit_width
        rtl_dir = design_dir / "rtl"
        tb_dir = design_dir / "testbench"
        results_dir = design_dir / "results"
        
        results_dir.mkdir(parents=True, exist_ok=True)
        
        print(f"\n{'='*60}")
        print(f"  Simulating {bit_width.upper()} ALU Designs")
        print(f"{'='*60}\n")
        
        # Compile and run clean design
        clean_verilog = rtl_dir / f"alu_{bit_width}_clean.v"
        clean_tb = tb_dir / f"tb_alu_{bit_width}_clean.v"
        
        if clean_verilog.exists() and clean_tb.exists():
            print(f"[1/2] Clean {bit_width} ALU...")
            compile_cmd = f"iverilog -o {results_dir}/clean.vvp {clean_verilog} {clean_tb}"
            subprocess.run(compile_cmd, shell=True, cwd=design_dir)
            
            run_cmd = f"vvp {results_dir}/clean.vvp"
            subprocess.run(run_cmd, shell=True, cwd=design_dir)
            
            # Move VCD file
            vcd_src = design_dir / f"alu_{bit_width}_clean.vcd"
            if vcd_src.exists():
                vcd_src.rename(results_dir / f"alu_{bit_width}_clean.vcd")
            print(f"   ✓ Generated {bit_width} clean VCD")
        
        # Compile and run trojan design
        trojan_verilog = rtl_dir / f"alu_{bit_width}_trojan.v"
        trojan_tb = tb_dir / f"tb_alu_{bit_width}_trojan.v"
        
        if trojan_verilog.exists() and trojan_tb.exists():
            print(f"[2/2] Trojan {bit_width} ALU...")
            compile_cmd = f"iverilog -o {results_dir}/trojan.vvp {trojan_verilog} {trojan_tb}"
            subprocess.run(compile_cmd, shell=True, cwd=design_dir)
            
            run_cmd = f"vvp {results_dir}/trojan.vvp"
            subprocess.run(run_cmd, shell=True, cwd=design_dir)
            
            # Move VCD file
            vcd_src = design_dir / f"alu_{bit_width}_trojan.vcd"
            if vcd_src.exists():
                vcd_src.rename(results_dir / f"alu_{bit_width}_trojan.vcd")
            print(f"   ✓ Generated {bit_width} trojan VCD")
        
        return results_dir
    
    def analyze_design(self, bit_width):
        """Analyze VCD files for specified bit-width"""
        results_dir = self.base_dir / bit_width / "results"
        clean_vcd = results_dir / f"alu_{bit_width}_clean.vcd"
        trojan_vcd = results_dir / f"alu_{bit_width}_trojan.vcd"
        
        if not (clean_vcd.exists() and trojan_vcd.exists()):
            print(f"   ⚠ VCD files not found for {bit_width}")
            return None
        
        print(f"\n{'='*60}")
        print(f"  Analyzing {bit_width.upper()} Designs")
        print(f"{'='*60}\n")
        
        # Use existing trojan_detector.py with path arguments
        analysis_cmd = f'python analysis/trojan_detector.py "{clean_vcd}" "{trojan_vcd}" --output "{results_dir}"'
        result = subprocess.run(analysis_cmd, shell=True, capture_output=True, text=True)
        
        if result.returncode == 0:
            print(f"   ✓ Analysis complete for {bit_width}")
            return True
        else:
            print(f"   ⚠ Analysis had issues for {bit_width}")
            return False
    
    def run_all(self):
        """Run complete multi-scale detection workflow"""
        print("\n" + "="*70)
        print("  MULTI-SCALE HARDWARE TROJAN DETECTION SYSTEM")
        print("  Scalable Detection: 4-bit, 8-bit, and 16-bit ALUs")
        print("="*70)
        
        for bit_width in self.bit_widths:
            design_dir = self.base_dir / bit_width
            if design_dir.exists():
                # Run simulation
                self.run_simulation(bit_width)
                
                # Run analysis
                self.analyze_design(bit_width)
            else:
                print(f"\n⚠ {bit_width} design not found, skipping...")
        
        print("\n" + "="*70)
        print("  MULTI-SCALE DETECTION COMPLETE")
        print("="*70)
        print("\nResults available in:")
        for bit_width in self.bit_widths:
            results_dir = self.base_dir / bit_width / "results"
            if results_dir.exists():
                print(f"  - designs/{bit_width}/results/")
        print()

def main():
    detector = MultiScaleDetector()
    detector.run_all()

if __name__ == "__main__":
    main()
