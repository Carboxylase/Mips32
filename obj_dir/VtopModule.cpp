// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "VtopModule__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

VtopModule::VtopModule(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new VtopModule__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

VtopModule::VtopModule(const char* _vcname__)
    : VtopModule(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

VtopModule::~VtopModule() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void VtopModule___024root___eval_debug_assertions(VtopModule___024root* vlSelf);
#endif  // VL_DEBUG
void VtopModule___024root___eval_static(VtopModule___024root* vlSelf);
void VtopModule___024root___eval_initial(VtopModule___024root* vlSelf);
void VtopModule___024root___eval_settle(VtopModule___024root* vlSelf);
void VtopModule___024root___eval(VtopModule___024root* vlSelf);

void VtopModule::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VtopModule::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    VtopModule___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        VtopModule___024root___eval_static(&(vlSymsp->TOP));
        VtopModule___024root___eval_initial(&(vlSymsp->TOP));
        VtopModule___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    VtopModule___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool VtopModule::eventsPending() { return false; }

uint64_t VtopModule::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* VtopModule::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void VtopModule___024root___eval_final(VtopModule___024root* vlSelf);

VL_ATTR_COLD void VtopModule::final() {
    VtopModule___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* VtopModule::hierName() const { return vlSymsp->name(); }
const char* VtopModule::modelName() const { return "VtopModule"; }
unsigned VtopModule::threads() const { return 1; }
void VtopModule::prepareClone() const { contextp()->prepareClone(); }
void VtopModule::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> VtopModule::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void VtopModule___024root__trace_decl_types(VerilatedVcd* tracep);

void VtopModule___024root__trace_init_top(VtopModule___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    VtopModule___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VtopModule___024root*>(voidSelf);
    VtopModule__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    VtopModule___024root__trace_decl_types(tracep);
    VtopModule___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void VtopModule___024root__trace_register(VtopModule___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void VtopModule::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'VtopModule::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    VtopModule___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
