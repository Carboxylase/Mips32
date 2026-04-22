// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VtopModule__Syms.h"


VL_ATTR_COLD void VtopModule___024root__trace_init_sub__TOP__0(VtopModule___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+8,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("topModule", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+8,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+9,0,"rst",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+4,0,"program_counter",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+5,0,"instr_fetched",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+1,0,"instr_mem_write_enable",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+2,0,"instr_load",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+6,0,"instr_mem_err_code",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->pushPrefix("instMem", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+10,0,"MEM_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+8,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"write_enable",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+4,0,"program_counter",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+2,0,"instr_write_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+5,0,"instr_write_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+6,0,"error_code",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+7,0,"internal_addr_counter",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+3,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void VtopModule___024root__trace_init_top(VtopModule___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_init_top\n"); );
    // Body
    VtopModule___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void VtopModule___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void VtopModule___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void VtopModule___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void VtopModule___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void VtopModule___024root__trace_register(VtopModule___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_register\n"); );
    // Body
    tracep->addConstCb(&VtopModule___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&VtopModule___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&VtopModule___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&VtopModule___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void VtopModule___024root__trace_const_0_sub_0(VtopModule___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void VtopModule___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_const_0\n"); );
    // Init
    VtopModule___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VtopModule___024root*>(voidSelf);
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    VtopModule___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void VtopModule___024root__trace_const_0_sub_0(VtopModule___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_const_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullBit(oldp+9,(vlSelf->topModule__DOT__rst));
    bufp->fullIData(oldp+10,(0xaU),32);
}

VL_ATTR_COLD void VtopModule___024root__trace_full_0_sub_0(VtopModule___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void VtopModule___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_full_0\n"); );
    // Init
    VtopModule___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VtopModule___024root*>(voidSelf);
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    VtopModule___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void VtopModule___024root__trace_full_0_sub_0(VtopModule___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root__trace_full_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullBit(oldp+1,(vlSelf->topModule__DOT__instr_mem_write_enable));
    bufp->fullIData(oldp+2,(vlSelf->topModule__DOT__instr_load),32);
    bufp->fullIData(oldp+3,(vlSelf->topModule__DOT__instMem__DOT__unnamedblk1__DOT__i),32);
    bufp->fullIData(oldp+4,(vlSelf->topModule__DOT__program_counter),32);
    bufp->fullIData(oldp+5,(vlSelf->topModule__DOT__instr_fetched),32);
    bufp->fullCData(oldp+6,(vlSelf->topModule__DOT__instr_mem_err_code),4);
    bufp->fullIData(oldp+7,(vlSelf->topModule__DOT__instMem__DOT__internal_addr_counter),32);
    bufp->fullBit(oldp+8,(vlSelf->clk));
}
