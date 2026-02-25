module attributes {llvm.data_layout = "", llvm.target_triple = "x86_64-unknown-linux-gnu", soda.container_module} {
  llvm.func @free(!llvm.ptr<i8>)
  llvm.func @malloc(i64) -> !llvm.ptr<i8>
  llvm.func @cgra_generic_0(!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) attributes {sym_visibility = "private"}
  llvm.func @cgra_matmul(!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) attributes {sym_visibility = "private"}
  llvm.func @main_graph(%arg0: !llvm.ptr<f32>, %arg1: !llvm.ptr<f32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr<f32>, %arg8: !llvm.ptr<f32>, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr<f32>, %arg15: !llvm.ptr<f32>, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64, %arg21: !llvm.ptr<f32>, %arg22: !llvm.ptr<f32>, %arg23: i64, %arg24: i64, %arg25: i64, %arg26: i64, %arg27: i64, %arg28: !llvm.ptr<f32>, %arg29: !llvm.ptr<f32>, %arg30: i64, %arg31: i64, %arg32: i64, %arg33: i64, %arg34: i64) attributes {input_names = ["X0", "X1", "X2", "X3"], output_names = ["Z0"]} {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg6, %6[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %9 = llvm.insertvalue %arg7, %8[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.insertvalue %arg8, %9[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %arg9, %10[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %arg10, %11[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %arg12, %12[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg11, %13[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg13, %14[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %17 = llvm.insertvalue %arg14, %16[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %arg15, %17[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %arg16, %18[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %arg17, %19[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %arg19, %20[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %arg18, %21[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %arg20, %22[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %25 = llvm.insertvalue %arg21, %24[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.insertvalue %arg22, %25[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.insertvalue %arg23, %26[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %28 = llvm.insertvalue %arg24, %27[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %29 = llvm.insertvalue %arg26, %28[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.insertvalue %arg25, %29[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %31 = llvm.insertvalue %arg27, %30[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %32 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %33 = llvm.insertvalue %arg28, %32[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.insertvalue %arg29, %33[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.insertvalue %arg30, %34[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.insertvalue %arg31, %35[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.insertvalue %arg33, %36[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %38 = llvm.insertvalue %arg32, %37[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.insertvalue %arg34, %38[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.mlir.constant(1 : index) : i64
    %41 = llvm.mlir.constant(0 : index) : i64
    %42 = llvm.mlir.constant(16 : index) : i64
    %43 = llvm.mlir.constant(4 : index) : i64
    %44 = llvm.mlir.constant(32 : index) : i64
    %45 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %46 = llvm.mlir.constant(16 : index) : i64
    %47 = llvm.mlir.constant(16 : index) : i64
    %48 = llvm.mlir.constant(1 : index) : i64
    %49 = llvm.mlir.constant(256 : index) : i64
    %50 = llvm.mlir.null : !llvm.ptr<f32>
    %51 = llvm.getelementptr %50[256] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %52 = llvm.ptrtoint %51 : !llvm.ptr<f32> to i64
    %53 = llvm.mlir.constant(128 : index) : i64
    %54 = llvm.add %52, %53  : i64
    %55 = llvm.call @malloc(%54) : (i64) -> !llvm.ptr<i8>
    %56 = llvm.bitcast %55 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %57 = llvm.ptrtoint %56 : !llvm.ptr<f32> to i64
    %58 = llvm.mlir.constant(1 : index) : i64
    %59 = llvm.sub %53, %58  : i64
    %60 = llvm.add %57, %59  : i64
    %61 = llvm.urem %60, %53  : i64
    %62 = llvm.sub %60, %61  : i64
    %63 = llvm.inttoptr %62 : i64 to !llvm.ptr<f32>
    %64 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %65 = llvm.insertvalue %56, %64[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %66 = llvm.insertvalue %63, %65[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %67 = llvm.mlir.constant(0 : index) : i64
    %68 = llvm.insertvalue %67, %66[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %69 = llvm.insertvalue %46, %68[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %70 = llvm.insertvalue %47, %69[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %71 = llvm.insertvalue %47, %70[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %72 = llvm.insertvalue %48, %71[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%41 : i64)
  ^bb1(%73: i64):  // 2 preds: ^bb0, ^bb4
    %74 = llvm.icmp "slt" %73, %42 : i64
    llvm.cond_br %74, ^bb2(%41 : i64), ^bb5
  ^bb2(%75: i64):  // 2 preds: ^bb1, ^bb3
    %76 = llvm.icmp "slt" %75, %42 : i64
    llvm.cond_br %76, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    %77 = llvm.mlir.constant(16 : index) : i64
    %78 = llvm.mul %73, %77  : i64
    %79 = llvm.add %78, %75  : i64
    %80 = llvm.getelementptr %63[%79] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %45, %80 : !llvm.ptr<f32>
    %81 = llvm.add %75, %40  : i64
    llvm.br ^bb2(%81 : i64)
  ^bb4:  // pred: ^bb2
    %82 = llvm.add %73, %40  : i64
    llvm.br ^bb1(%82 : i64)
  ^bb5:  // pred: ^bb1
    %83 = llvm.mlir.constant(16 : index) : i64
    %84 = llvm.mlir.constant(16 : index) : i64
    %85 = llvm.mlir.constant(1 : index) : i64
    %86 = llvm.mlir.constant(256 : index) : i64
    %87 = llvm.mlir.null : !llvm.ptr<f32>
    %88 = llvm.getelementptr %87[256] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %89 = llvm.ptrtoint %88 : !llvm.ptr<f32> to i64
    %90 = llvm.mlir.constant(128 : index) : i64
    %91 = llvm.add %89, %90  : i64
    %92 = llvm.call @malloc(%91) : (i64) -> !llvm.ptr<i8>
    %93 = llvm.bitcast %92 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %94 = llvm.ptrtoint %93 : !llvm.ptr<f32> to i64
    %95 = llvm.mlir.constant(1 : index) : i64
    %96 = llvm.sub %90, %95  : i64
    %97 = llvm.add %94, %96  : i64
    %98 = llvm.urem %97, %90  : i64
    %99 = llvm.sub %97, %98  : i64
    %100 = llvm.inttoptr %99 : i64 to !llvm.ptr<f32>
    %101 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %102 = llvm.insertvalue %93, %101[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %103 = llvm.insertvalue %100, %102[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %104 = llvm.mlir.constant(0 : index) : i64
    %105 = llvm.insertvalue %104, %103[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %106 = llvm.insertvalue %83, %105[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %107 = llvm.insertvalue %84, %106[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %108 = llvm.insertvalue %84, %107[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %109 = llvm.insertvalue %85, %108[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %110 = llvm.mlir.constant(1 : index) : i64
    %111 = llvm.mul %110, %46  : i64
    %112 = llvm.mul %111, %47  : i64
    %113 = llvm.mlir.null : !llvm.ptr<f32>
    %114 = llvm.getelementptr %113[1] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %115 = llvm.ptrtoint %114 : !llvm.ptr<f32> to i64
    %116 = llvm.mul %112, %115  : i64
    %117 = llvm.getelementptr %63[%67] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %118 = llvm.getelementptr %100[%104] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %119 = llvm.mlir.constant(false) : i1
    "llvm.intr.memcpy"(%118, %117, %116, %119) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i1) -> ()
    %120 = llvm.bitcast %56 : !llvm.ptr<f32> to !llvm.ptr<i8>
    llvm.call @free(%120) : (!llvm.ptr<i8>) -> ()
    llvm.br ^bb6(%41 : i64)
  ^bb6(%121: i64):  // 2 preds: ^bb5, ^bb11
    %122 = llvm.icmp "slt" %121, %42 : i64
    llvm.cond_br %122, ^bb7(%41 : i64), ^bb12
  ^bb7(%123: i64):  // 2 preds: ^bb6, ^bb10
    %124 = llvm.icmp "slt" %123, %42 : i64
    llvm.cond_br %124, ^bb8(%41 : i64), ^bb11
  ^bb8(%125: i64):  // 2 preds: ^bb7, ^bb9
    %126 = llvm.icmp "slt" %125, %44 : i64
    llvm.cond_br %126, ^bb9, ^bb10
  ^bb9:  // pred: ^bb8
    %127 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %128 = llvm.extractvalue %7[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %129 = llvm.insertvalue %128, %127[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %130 = llvm.extractvalue %7[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %131 = llvm.insertvalue %130, %129[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %132 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %133 = llvm.extractvalue %7[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %134 = llvm.extractvalue %7[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %135 = llvm.mul %121, %132  : i64
    %136 = llvm.add %134, %135  : i64
    %137 = llvm.mul %125, %133  : i64
    %138 = llvm.add %136, %137  : i64
    %139 = llvm.insertvalue %138, %131[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %140 = llvm.mlir.constant(16 : i64) : i64
    %141 = llvm.mlir.constant(1 : i64) : i64
    %142 = llvm.insertvalue %140, %139[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %143 = llvm.insertvalue %141, %142[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %144 = llvm.mlir.constant(4 : i64) : i64
    %145 = llvm.mlir.constant(32 : i64) : i64
    %146 = llvm.insertvalue %144, %143[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %147 = llvm.insertvalue %145, %146[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %148 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %149 = llvm.extractvalue %15[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %150 = llvm.insertvalue %149, %148[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %151 = llvm.extractvalue %15[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %152 = llvm.insertvalue %151, %150[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %153 = llvm.extractvalue %15[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %154 = llvm.extractvalue %15[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %155 = llvm.extractvalue %15[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %156 = llvm.mul %125, %153  : i64
    %157 = llvm.add %155, %156  : i64
    %158 = llvm.mul %123, %154  : i64
    %159 = llvm.add %157, %158  : i64
    %160 = llvm.insertvalue %159, %152[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %161 = llvm.mlir.constant(4 : i64) : i64
    %162 = llvm.mlir.constant(1 : i64) : i64
    %163 = llvm.insertvalue %161, %160[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %164 = llvm.insertvalue %162, %163[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %165 = llvm.mlir.constant(16 : i64) : i64
    %166 = llvm.mlir.constant(16 : i64) : i64
    %167 = llvm.insertvalue %165, %164[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %168 = llvm.insertvalue %166, %167[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %169 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %170 = llvm.insertvalue %93, %169[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %171 = llvm.insertvalue %100, %170[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %172 = llvm.mul %121, %84  : i64
    %173 = llvm.add %104, %172  : i64
    %174 = llvm.mul %123, %85  : i64
    %175 = llvm.add %173, %174  : i64
    %176 = llvm.insertvalue %175, %171[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %177 = llvm.mlir.constant(4 : i64) : i64
    %178 = llvm.mlir.constant(1 : i64) : i64
    %179 = llvm.insertvalue %177, %176[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %180 = llvm.insertvalue %178, %179[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %181 = llvm.mlir.constant(4 : i64) : i64
    %182 = llvm.mlir.constant(16 : i64) : i64
    %183 = llvm.insertvalue %181, %180[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %184 = llvm.insertvalue %182, %183[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @cgra_matmul(%128, %130, %138, %144, %140, %145, %141, %149, %151, %159, %165, %161, %166, %162, %93, %100, %175, %181, %177, %182, %178) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) -> ()
    %185 = llvm.add %125, %42  : i64
    llvm.br ^bb8(%185 : i64)
  ^bb10:  // pred: ^bb8
    %186 = llvm.add %123, %43  : i64
    llvm.br ^bb7(%186 : i64)
  ^bb11:  // pred: ^bb7
    %187 = llvm.add %121, %43  : i64
    llvm.br ^bb6(%187 : i64)
  ^bb12:  // pred: ^bb6
    %188 = llvm.mlir.constant(16 : index) : i64
    %189 = llvm.mlir.constant(16 : index) : i64
    %190 = llvm.mlir.constant(1 : index) : i64
    %191 = llvm.mlir.constant(256 : index) : i64
    %192 = llvm.mlir.null : !llvm.ptr<f32>
    %193 = llvm.getelementptr %192[256] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %194 = llvm.ptrtoint %193 : !llvm.ptr<f32> to i64
    %195 = llvm.mlir.constant(128 : index) : i64
    %196 = llvm.add %194, %195  : i64
    %197 = llvm.call @malloc(%196) : (i64) -> !llvm.ptr<i8>
    %198 = llvm.bitcast %197 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %199 = llvm.ptrtoint %198 : !llvm.ptr<f32> to i64
    %200 = llvm.mlir.constant(1 : index) : i64
    %201 = llvm.sub %195, %200  : i64
    %202 = llvm.add %199, %201  : i64
    %203 = llvm.urem %202, %195  : i64
    %204 = llvm.sub %202, %203  : i64
    %205 = llvm.inttoptr %204 : i64 to !llvm.ptr<f32>
    %206 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %207 = llvm.insertvalue %198, %206[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %208 = llvm.insertvalue %205, %207[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %209 = llvm.mlir.constant(0 : index) : i64
    %210 = llvm.insertvalue %209, %208[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %211 = llvm.insertvalue %188, %210[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %212 = llvm.insertvalue %189, %211[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %213 = llvm.insertvalue %189, %212[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %214 = llvm.insertvalue %190, %213[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %215 = llvm.extractvalue %23[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %216 = llvm.extractvalue %23[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %217 = llvm.extractvalue %23[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %218 = llvm.extractvalue %23[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %219 = llvm.extractvalue %23[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %220 = llvm.extractvalue %23[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %221 = llvm.extractvalue %23[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %222 = llvm.extractvalue %31[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %223 = llvm.extractvalue %31[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %224 = llvm.extractvalue %31[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %225 = llvm.extractvalue %31[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %226 = llvm.extractvalue %31[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %227 = llvm.extractvalue %31[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %228 = llvm.extractvalue %31[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @cgra_generic_0(%93, %100, %104, %83, %84, %84, %85, %215, %216, %217, %218, %219, %220, %221, %222, %223, %224, %225, %226, %227, %228, %198, %205, %209, %188, %189, %189, %190) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) -> ()
    %229 = llvm.bitcast %93 : !llvm.ptr<f32> to !llvm.ptr<i8>
    llvm.call @free(%229) : (!llvm.ptr<i8>) -> ()
    %230 = llvm.mlir.constant(1 : index) : i64
    %231 = llvm.mul %230, %188  : i64
    %232 = llvm.mul %231, %189  : i64
    %233 = llvm.mlir.null : !llvm.ptr<f32>
    %234 = llvm.getelementptr %233[1] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %235 = llvm.ptrtoint %234 : !llvm.ptr<f32> to i64
    %236 = llvm.mul %232, %235  : i64
    %237 = llvm.getelementptr %205[%209] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %238 = llvm.extractvalue %39[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %239 = llvm.extractvalue %39[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %240 = llvm.getelementptr %238[%239] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %241 = llvm.mlir.constant(false) : i1
    "llvm.intr.memcpy"(%240, %237, %236, %241) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i1) -> ()
    llvm.return
  }
}

