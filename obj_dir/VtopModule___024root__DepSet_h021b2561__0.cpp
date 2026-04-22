// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VtopModule.h for the primary calling header

#include "VtopModule__pch.h"
#include "VtopModule___024root.h"

void VtopModule___024root___eval_act(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_act\n"); );
}

VL_INLINE_OPT void VtopModule___024root___nba_sequent__TOP__0(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___nba_sequent__TOP__0\n"); );
    // Init
    IData/*31:0*/ __Vdly__topModule__DOT__program_counter;
    __Vdly__topModule__DOT__program_counter = 0;
    SData/*9:0*/ __Vdlyvdim0__topModule__DOT__instMem__DOT__instr_mem__v0;
    __Vdlyvdim0__topModule__DOT__instMem__DOT__instr_mem__v0 = 0;
    IData/*31:0*/ __Vdlyvval__topModule__DOT__instMem__DOT__instr_mem__v0;
    __Vdlyvval__topModule__DOT__instMem__DOT__instr_mem__v0 = 0;
    CData/*0:0*/ __Vdlyvset__topModule__DOT__instMem__DOT__instr_mem__v0;
    __Vdlyvset__topModule__DOT__instMem__DOT__instr_mem__v0 = 0;
    // Body
    __Vdlyvset__topModule__DOT__instMem__DOT__instr_mem__v0 = 0U;
    __Vdly__topModule__DOT__program_counter = vlSelf->topModule__DOT__program_counter;
    if (vlSelf->topModule__DOT__instr_mem_write_enable) {
        __Vdlyvval__topModule__DOT__instMem__DOT__instr_mem__v0 
            = vlSelf->topModule__DOT__instr_load;
        __Vdlyvset__topModule__DOT__instMem__DOT__instr_mem__v0 = 1U;
        __Vdlyvdim0__topModule__DOT__instMem__DOT__instr_mem__v0 
            = (0x3ffU & vlSelf->topModule__DOT__instMem__DOT__internal_addr_counter);
        vlSelf->topModule__DOT__instMem__DOT__internal_addr_counter 
            = ((IData)(1U) + vlSelf->topModule__DOT__instMem__DOT__internal_addr_counter);
    } else if ((0x3ffU >= vlSelf->topModule__DOT__program_counter)) {
        vlSelf->topModule__DOT__instMem__DOT__internal_addr_counter = 0U;
    }
    VL_WRITEF("program_counter: %10#, instruction: %b\n",
              32,vlSelf->topModule__DOT__program_counter,
              32,vlSelf->topModule__DOT__instr_fetched);
    __Vdly__topModule__DOT__program_counter = ((IData)(1U) 
                                               + vlSelf->topModule__DOT__program_counter);
    if ((1U & (~ (IData)(vlSelf->topModule__DOT__instr_mem_write_enable)))) {
        if ((0x3ffU < vlSelf->topModule__DOT__program_counter)) {
            vlSelf->topModule__DOT__instr_mem_err_code = 1U;
        }
        if ((0x3ffU >= vlSelf->topModule__DOT__program_counter)) {
            vlSelf->topModule__DOT__instr_fetched = 
                vlSelf->topModule__DOT__instMem__DOT__instr_mem
                [(0x3ffU & vlSelf->topModule__DOT__program_counter)];
        }
    }
    if (__Vdlyvset__topModule__DOT__instMem__DOT__instr_mem__v0) {
        vlSelf->topModule__DOT__instMem__DOT__instr_mem[__Vdlyvdim0__topModule__DOT__instMem__DOT__instr_mem__v0] 
            = __Vdlyvval__topModule__DOT__instMem__DOT__instr_mem__v0;
    }
    vlSelf->topModule__DOT__program_counter = __Vdly__topModule__DOT__program_counter;
}

void VtopModule___024root___eval_nba(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VtopModule___024root___nba_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
    }
}

void VtopModule___024root___eval_triggers__act(VtopModule___024root* vlSelf);

bool VtopModule___024root___eval_phase__act(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    VtopModule___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        VtopModule___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool VtopModule___024root___eval_phase__nba(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        VtopModule___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void VtopModule___024root___dump_triggers__nba(VtopModule___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void VtopModule___024root___dump_triggers__act(VtopModule___024root* vlSelf);
#endif  // VL_DEBUG

void VtopModule___024root___eval(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            VtopModule___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("topModule.sv", 1, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                VtopModule___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("topModule.sv", 1, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (VtopModule___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (VtopModule___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void VtopModule___024root___eval_debug_assertions(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
}
#endif  // VL_DEBUG
