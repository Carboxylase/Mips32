// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VtopModule.h for the primary calling header

#include "VtopModule__pch.h"
#include "VtopModule___024root.h"

VL_ATTR_COLD void VtopModule___024root___eval_static(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_static\n"); );
}

VL_ATTR_COLD void VtopModule___024root___eval_initial__TOP(VtopModule___024root* vlSelf);

VL_ATTR_COLD void VtopModule___024root___eval_initial(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_initial\n"); );
    // Body
    VtopModule___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vm_traceActivity[1U] = 1U;
    vlSelf->__Vm_traceActivity[0U] = 1U;
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
}

VL_ATTR_COLD void VtopModule___024root___eval_initial__TOP(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_initial__TOP\n"); );
    // Init
    VlWide<4>/*127:0*/ __Vtemp_2;
    // Body
    vlSelf->topModule__DOT__instr_mem_write_enable = 0U;
    vlSelf->topModule__DOT__instr_load = 0U;
    vlSelf->topModule__DOT__instMem__DOT__unnamedblk1__DOT__i = 0U;
    while (VL_GTS_III(32, 0x400U, vlSelf->topModule__DOT__instMem__DOT__unnamedblk1__DOT__i)) {
        vlSelf->topModule__DOT__instMem__DOT__instr_mem[(0x3ffU 
                                                         & vlSelf->topModule__DOT__instMem__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelf->topModule__DOT__instMem__DOT__unnamedblk1__DOT__i 
            = ((IData)(1U) + vlSelf->topModule__DOT__instMem__DOT__unnamedblk1__DOT__i);
    }
    vlSelf->topModule__DOT__instMem__DOT__internal_addr_counter = 0U;
    __Vtemp_2[0U] = 0x653d2573U;
    __Vtemp_2[1U] = 0x5f66696cU;
    __Vtemp_2[2U] = 0x6e737472U;
    __Vtemp_2[3U] = 0x69U;
    if (VL_UNLIKELY(VL_VALUEPLUSARGS_INN(64, VL_CVT_PACK_STR_NW(4, __Vtemp_2), 
                                         vlSelf->topModule__DOT__instMem__DOT__instr_file))) {
        VL_READMEM_N(false, 32, 1024, 0, VL_CVT_PACK_STR_NN(vlSelf->topModule__DOT__instMem__DOT__instr_file)
                     ,  &(vlSelf->topModule__DOT__instMem__DOT__instr_mem)
                     , 0, ~0ULL);
    }
}

VL_ATTR_COLD void VtopModule___024root___eval_final(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_final\n"); );
}

VL_ATTR_COLD void VtopModule___024root___eval_settle(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void VtopModule___024root___dump_triggers__act(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void VtopModule___024root___dump_triggers__nba(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void VtopModule___024root___ctor_var_reset(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->topModule__DOT__rst = VL_RAND_RESET_I(1);
    vlSelf->topModule__DOT__program_counter = VL_RAND_RESET_I(32);
    vlSelf->topModule__DOT__instr_fetched = VL_RAND_RESET_I(32);
    vlSelf->topModule__DOT__instr_mem_write_enable = VL_RAND_RESET_I(1);
    vlSelf->topModule__DOT__instr_load = VL_RAND_RESET_I(32);
    vlSelf->topModule__DOT__instr_mem_err_code = VL_RAND_RESET_I(4);
    for (int __Vi0 = 0; __Vi0 < 1024; ++__Vi0) {
        vlSelf->topModule__DOT__instMem__DOT__instr_mem[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->topModule__DOT__instMem__DOT__internal_addr_counter = VL_RAND_RESET_I(32);
    vlSelf->topModule__DOT__instMem__DOT__unnamedblk1__DOT__i = VL_RAND_RESET_I(32);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
