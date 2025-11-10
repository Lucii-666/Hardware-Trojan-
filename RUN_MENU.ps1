# Quick Run Menu for Hardware Trojan Detection
# Multi-bit-width launcher

Clear-Host

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   MULTI-SCALE HARDWARE TROJAN DETECTION" -ForegroundColor Cyan
Write-Host "   4-bit, 8-bit, and 16-bit ALU Analysis" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

Write-Host "`nChoose an option:`n" -ForegroundColor Yellow

Write-Host "  [1] Run ALL bit-widths: 4-bit, 8-bit, 16-bit" -ForegroundColor White
Write-Host "  [2] Run ONLY 4-bit" -ForegroundColor White
Write-Host "  [3] Run ONLY 8-bit" -ForegroundColor White
Write-Host "  [4] Run ONLY 16-bit" -ForegroundColor White
Write-Host "  [5] View comparison - no simulation" -ForegroundColor White
Write-Host "  [6] Quick demo - 4-bit only, 10 seconds" -ForegroundColor Green
Write-Host "  [0] Exit`n" -ForegroundColor White

$choice = Read-Host "Enter choice (0-6)"

switch ($choice) {
    "1" {
        Write-Host "`n[*] Running multi-scale detection...`n" -ForegroundColor Green
        python run_multiscale_detection.py
    }
    "2" {
        Write-Host "`n[*] Running 4-bit detection...`n" -ForegroundColor Green
        python run_analysis.py
    }
    "3" {
        Write-Host "`n[*] Running 8-bit detection...`n" -ForegroundColor Green
        
        Push-Location designs\8bit
        
        Write-Host "[1/4] Compiling 8-bit clean ALU..." -ForegroundColor Cyan
        iverilog -o results\clean.vvp rtl\alu_8bit_clean.v testbench\tb_alu_8bit_clean.v
        
        Write-Host "[2/4] Simulating 8-bit clean ALU..." -ForegroundColor Cyan
        vvp results\clean.vvp
        
        Write-Host "[3/4] Compiling 8-bit trojan ALU..." -ForegroundColor Cyan
        iverilog -o results\trojan.vvp rtl\alu_8bit_trojan.v testbench\tb_alu_8bit_trojan.v
        
        Write-Host "[4/4] Simulating 8-bit trojan ALU..." -ForegroundColor Cyan
        vvp results\trojan.vvp
        
        if (Test-Path "alu_8bit_clean.vcd") { 
            Move-Item "alu_8bit_clean.vcd" "results\" -Force 
        }
        if (Test-Path "alu_8bit_trojan.vcd") { 
            Move-Item "alu_8bit_trojan.vcd" "results\" -Force 
        }
        
        Pop-Location
        
        Write-Host "`n[DONE] 8-bit simulation complete! VCD files in designs\8bit\results\" -ForegroundColor Green
    }
    "4" {
        Write-Host "`n[*] Running 16-bit detection...`n" -ForegroundColor Green
        
        Push-Location designs\16bit
        
        Write-Host "[1/4] Compiling 16-bit clean ALU..." -ForegroundColor Cyan
        iverilog -o results\clean.vvp rtl\alu_16bit_clean.v testbench\tb_alu_16bit_clean.v
        
        Write-Host "[2/4] Simulating 16-bit clean ALU..." -ForegroundColor Cyan
        vvp results\clean.vvp
        
        Write-Host "[3/4] Compiling 16-bit trojan ALU..." -ForegroundColor Cyan
        iverilog -o results\trojan.vvp rtl\alu_16bit_trojan.v testbench\tb_alu_16bit_trojan.v
        
        Write-Host "[4/4] Simulating 16-bit trojan ALU..." -ForegroundColor Cyan
        vvp results\trojan.vvp
        
        if (Test-Path "alu_16bit_clean.vcd") { 
            Move-Item "alu_16bit_clean.vcd" "results\" -Force 
        }
        if (Test-Path "alu_16bit_trojan.vcd") { 
            Move-Item "alu_16bit_trojan.vcd" "results\" -Force 
        }
        
        Pop-Location
        
        Write-Host "`n[DONE] 16-bit simulation complete! VCD files in designs\16bit\results\" -ForegroundColor Green
    }
    "5" {
        Write-Host "`n[*] Viewing comparison...`n" -ForegroundColor Green
        python compare_bitwidths.py
    }
    "6" {
        Write-Host "`n[*] Running quick demo...`n" -ForegroundColor Green
        Push-Location presentation\demo_files
        .\run_quick_demo.ps1
        Pop-Location
    }
    default {
        Write-Host "`nExiting..." -ForegroundColor Yellow
        exit
    }
}

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host "  DONE! Check the results folders for outputs" -ForegroundColor Green
Write-Host "================================================================`n" -ForegroundColor Cyan
