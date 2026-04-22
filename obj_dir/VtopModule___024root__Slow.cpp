// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VtopModule.h for the primary calling header

#include "VtopModule__pch.h"
#include "VtopModule__Syms.h"
#include "VtopModule___024root.h"

void VtopModule___024root___ctor_var_reset(VtopModule___024root* vlSelf);

VtopModule___024root::VtopModule___024root(VtopModule__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    VtopModule___024root___ctor_var_reset(this);
}

void VtopModule___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

VtopModule___024root::~VtopModule___024root() {
}
