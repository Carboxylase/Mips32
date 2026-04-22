// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VtopModule.h for the primary calling header

#include "VtopModule__pch.h"
#include "VtopModule__Syms.h"
#include "VtopModule___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void VtopModule___024root___dump_triggers__act(VtopModule___024root* vlSelf);
#endif  // VL_DEBUG

void VtopModule___024root___eval_triggers__act(VtopModule___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VtopModule___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__clk__0))));
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        VtopModule___024root___dump_triggers__act(vlSelf);
    }
#endif
}
