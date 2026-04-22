// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VtopModule__Syms.h"


void VtopModule___024root__trace_chg_0_sub_0(VtopModule___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void VtopModule___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_chg_0\n"); );
    // Init
    VtopModule___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VtopModule___024root*>(voidSelf);
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    VtopModule___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void VtopModule___024root__trace_chg_0_sub_0(VtopModule___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_chg_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[0U])) {
        bufp->chgBit(oldp+0,(vlSelf->topModule__DOT__instr_mem_write_enable));
        bufp->chgIData(oldp+1,(vlSelf->topModule__DOT__instr_load),32);
        bufp->chgIData(oldp+2,(vlSelf->topModule__DOT__instMem__DOT__unnamedblk1__DOT__i),32);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgIData(oldp+3,(vlSelf->topModule__DOT__program_counter),32);
        bufp->chgIData(oldp+4,(vlSelf->topModule__DOT__instr_fetched),32);
        bufp->chgCData(oldp+5,(vlSelf->topModule__DOT__instr_mem_err_code),4);
        bufp->chgIData(oldp+6,(vlSelf->topModule__DOT__instMem__DOT__internal_addr_counter),32);
    }
    bufp->chgBit(oldp+7,(vlSelf->clk));
}

void VtopModule___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_cleanup\n"); );
    // Init
    VtopModule___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VtopModule___024root*>(voidSelf);
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
