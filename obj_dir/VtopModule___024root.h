// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See VtopModule.h for the primary calling header

#ifndef VERILATED_VTOPMODULE___024ROOT_H_
#define VERILATED_VTOPMODULE___024ROOT_H_  // guard

#include "verilated.h"


class VtopModule__Syms;

class alignas(VL_CACHE_LINE_BYTES) VtopModule___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    CData/*0:0*/ topModule__DOT__rst;
    CData/*0:0*/ topModule__DOT__instr_mem_write_enable;
    CData/*3:0*/ topModule__DOT__instr_mem_err_code;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ topModule__DOT__program_counter;
    IData/*31:0*/ topModule__DOT__instr_fetched;
    IData/*31:0*/ topModule__DOT__instr_load;
    IData/*31:0*/ topModule__DOT__instMem__DOT__internal_addr_counter;
    IData/*31:0*/ topModule__DOT__instMem__DOT__unnamedblk1__DOT__i;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 1024> topModule__DOT__instMem__DOT__instr_mem;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    std::string topModule__DOT__instMem__DOT__instr_file;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    VtopModule__Syms* const vlSymsp;

    // CONSTRUCTORS
    VtopModule___024root(VtopModule__Syms* symsp, const char* v__name);
    ~VtopModule___024root();
    VL_UNCOPYABLE(VtopModule___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
