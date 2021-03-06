// We use -O0 here otherwise the compiler will optimize less than equal
// to a less than operation!
// RUN: clspv %s -O0 -S -o %t.spvasm
// RUN: FileCheck %s < %t.spvasm
// RUN: clspv %s -O0 -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK: ; SPIR-V
// CHECK: ; Version: 1.0
// CHECK: ; Generator: Codeplay; 0
// CHECK: ; Bound: 19
// CHECK: ; Schema: 0
// CHECK: OpCapability Shader
// CHECK: OpCapability VariablePointers
// CHECK: OpExtension "SPV_KHR_variable_pointers"
// CHECK: OpMemoryModel Logical GLSL450
// CHECK: OpEntryPoint GLCompute %[[FOO_ID:[a-zA-Z0-9_]*]] "foo"
// CHECK: OpExecutionMode %[[FOO_ID]] LocalSize 1 1 1
// CHECK: OpDecorate %[[UINT_DYNAMIC_ARRAY_TYPE_ID:[a-zA-Z0-9_]*]] ArrayStride 4
// CHECK: OpMemberDecorate %[[UINT_ARG0_STRUCT_TYPE_ID:[a-zA-Z0-9_]*]] 0 Offset 0
// CHECK: OpDecorate %[[UINT_ARG0_STRUCT_TYPE_ID]] Block
// CHECK: OpDecorate %[[ARG0_ID:[a-zA-Z0-9_]*]] DescriptorSet 0
// CHECK: OpDecorate %[[ARG0_ID]] Binding 0
// CHECK: %[[UINT_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeInt 32 0
// CHECK: %[[UINT_GLOBAL_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[UINT_TYPE_ID]]
// CHECK: %[[UINT_DYNAMIC_ARRAY_TYPE_ID]] = OpTypeRuntimeArray %[[UINT_TYPE_ID]]
// CHECK: %[[UINT_ARG0_STRUCT_TYPE_ID]] = OpTypeStruct %[[UINT_DYNAMIC_ARRAY_TYPE_ID]]
// CHECK: %[[UINT_ARG0_POINTER_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypePointer StorageBuffer %[[UINT_ARG0_STRUCT_TYPE_ID]]
// CHECK: %[[VOID_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVoid
// CHECK: %[[FOO_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFunction %[[VOID_TYPE_ID]]
// CHECK: %[[BOOL_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeBool
// CHECK: %[[CONSTANT_0_ID:[a-zA-Z0-9_]*]] = OpConstant %[[UINT_TYPE_ID]] 0
// CHECK: %[[CONSTANT_1_ID:[a-zA-Z0-9_]*]] = OpConstant %[[UINT_TYPE_ID]] 1
// CHECK: %[[CONSTANT_42_ID:[a-zA-Z0-9_]*]] = OpConstant %[[UINT_TYPE_ID]] 43
// CHECK: %[[ARG0_ID]] = OpVariable %[[UINT_ARG0_POINTER_TYPE_ID]] StorageBuffer
// CHECK: %[[FOO_ID]] = OpFunction %[[VOID_TYPE_ID]] None %[[FOO_TYPE_ID]]
void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo(global int* a)
// CHECK: %[[LABEL_ID:[a-zA-Z0-9_]*]] = OpLabel
{
// CHECK: %[[ACCESS_CHAIN_ID:[a-zA-Z0-9_]*]] = OpAccessChain %[[UINT_GLOBAL_POINTER_TYPE_ID]] %[[ARG0_ID]] %[[CONSTANT_0_ID]] %[[CONSTANT_0_ID]]
// CHECK: %[[LOAD_ID:[a-zA-Z0-9_]*]] = OpLoad %[[UINT_TYPE_ID]] %[[ACCESS_CHAIN_ID]]
  const int aLoad = *a;

// CHECK: %[[CMP_ID:[a-zA-Z0-9_]*]] = OpSLessThan %[[BOOL_TYPE_ID]] %[[LOAD_ID]] %[[CONSTANT_42_ID]]
  const bool c = (aLoad <= 42);

// CHECK: %[[CAS_ID:[a-zA-Z0-9_]*]] = OpSelect %[[UINT_TYPE_ID]] %[[CMP_ID]] %[[CONSTANT_1_ID]] %[[CONSTANT_0_ID]]
  const int cAs = c;

// CHECK: OpStore %[[ACCESS_CHAIN_ID]] %[[CAS_ID]]
  *a = cAs;

// CHECK: OpReturn
}
// CHECK: OpFunctionEnd
