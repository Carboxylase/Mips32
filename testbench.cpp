#include <iostream>
#include <fstream>
#include <string>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VtopModule.h"

void clkToggle(VtopModule *tb, VerilatedVcdC *tfp, int *tickCount);

int main (int argc, char**argv)
{

    if (argc == 1)
    {
        std::cout << "Instruction File Name Required - Exiting" << std::endl;
        return 1;
    }
    std::string instrFile = (std::string)argv[1]; // argv[0] is the program name
    std::cout << "Using Intruction File: " << instrFile << std::endl;

    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    // int tick = 0;

    VtopModule *tb = new VtopModule;

    
    VerilatedVcdC *tfp = new VerilatedVcdC;

    tb->trace(tfp, 99); //idk what this 99 means, look it up
    tfp->open("testbench.vcd");

    // loadInstrMemory(tb, tfp, instrFile);

    int tickCount = 0;

    int clockCycleCount = 20;

    for (int i = 0; i <= clockCycleCount; i++)
    {
        clkToggle(tb, tfp, &tickCount);
    }

    tfp->close();

}

void clkToggle(VtopModule *tb, VerilatedVcdC *tfp, int *tickCount)
{
    tb->clk = 1;
    tb->eval();
    tfp->dump(*tickCount);
    *tickCount += 1;
    
    tb->clk = 0;
    tb->eval();
    tfp->dump(*tickCount);
    *tickCount += 1;
}
