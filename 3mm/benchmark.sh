export OMP_NUM_THREADS=12

if [ "$RUN_POLLY" ]; then
echo "POLLY 1"
/home/lukas/repos/llvm-project/build/bin/clang -O3 -ffast-math -mllvm -polly -mllvm -polly-parallel -mllvm -polly-tiling -mllvm -polly-vectorizer=stripmine -mllvm -polly-2nd-level-tiling -lgomp -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET 3mm_a.c ../polybench.c -I../ -o vpolly_a.out
for run in {1..5}; do ./vpolly_a.out; done

echo "POLLY 2"
/home/lukas/repos/llvm-project/build/bin/clang -O3 -ffast-math -mllvm -polly -mllvm -polly-parallel -mllvm -polly-tiling -mllvm -polly-vectorizer=stripmine -mllvm -polly-2nd-level-tiling -lgomp -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET 3mm_b.c ../polybench.c -I../ -o vpolly_b.out
for run in {1..5}; do ./vpolly_b.out; done
fi

if [ "$RUN_DAISY_NF" ]; then
echo "DAISY (NF) 1"
daisycc -O3 -ffast-math -fno-unroll-loops -fopenmp -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET 3mm_a.c ../polybench.c -I../ -I/home/lukas/anaconda3/pkgs/llvm-openmp-16.0.6-h4dfa4b3_0/include/ -o vdaisy_a.out
for run in {1..5}; do ./vdaisy_a.out; done

echo "DAISY (NF) 2"
daisycc -O3 -ffast-math -fno-unroll-loops -fopenmp -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET 3mm_b.c ../polybench.c -I../ -I/home/lukas/anaconda3/pkgs/llvm-openmp-16.0.6-h4dfa4b3_0/include/ -o vdaisy_b.out
for run in {1..5}; do ./vdaisy_b.out; done
fi

if [ "$RUN_DAISY_TT" ]; then
echo "DAISY (TT) 1"
daisycc -O3 -ffast-math -fno-unroll-loops -fopenmp -ftransfer-tune -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET 3mm_a.c ../polybench.c -I../ -I/home/lukas/anaconda3/pkgs/llvm-openmp-16.0.6-h4dfa4b3_0/include/ -o vdaisy_tt_a.out
for run in {1..5}; do ./vdaisy_tt_a.out; done

echo "DAISY (TT) 2"
daisycc -O3 -ffast-math -fno-unroll-loops -fopenmp -ftransfer-tune -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET 3mm_b.c ../polybench.c -I../ -I/home/lukas/anaconda3/pkgs/llvm-openmp-16.0.6-h4dfa4b3_0/include/ -o vdaisy_tt_b.out
for run in {1..5}; do ./vdaisy_tt_b.out; done
fi

if [ "$RUN_ICC" ]; then
echo "ICC 1"
icc -O3 -ffast-math -parallel -qopenmp -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET 3mm_a.c ../polybench.c -I../ -o vicc_a.out
for run in {1..5}; do ./vicc_a.out; done

echo "ICC 2"
icc -O3 -ffast-math -parallel -qopenmp -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET 3mm_b.c ../polybench.c -I../ -o vicc_b.out
for run in {1..5}; do ./vicc_b.out; done
fi

