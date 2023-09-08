export OMP_NUM_THREADS=12

if [ "$RUN_POLLY" ]; then
echo "POLLY"
/home/lukas/.local/bin/clang -O3 -mllvm -polly -mllvm -polly-parallel -mllvm -polly-tiling -mllvm -polly-vectorizer=stripmine -mllvm -polly-2nd-level-tiling -lgomp -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET bicg_a.c ../polybench.c -I../ -o vpolly_a.out
for run in {1..5}; do ./vpolly_a.out; done
fi

if [ "$RUN_ICC" ]; then
echo "ICC"
icc -O3 -parallel -qopenmp -DPOLYBENCH_TIME -DPOLYBENCH_USE_RESTRICT -DLARGE_DATASET bicg_a.c ../polybench.c -I../ -o vicc_a.out
for run in {1..5}; do ./vicc_a.out; done
fi

if [ "$RUN_DAISY_NF" ]; then
echo "DAISY_NF"
daisycc -O2 -fschedule=multicore -fno-unroll-loops -DPOLYBENCH_TIME -DLARGE_DATASET bicg_a.c ../polybench.c -I../ -o vdaisy_a.out
for run in {1..5}; do ./vdaisy_a.out; done
fi

if [ "$RUN_DAISY_TT" ]; then
echo "DAISY_TT"
daisycc -O2 -fschedule=multicore -ftransfer-tune -fno-unroll-loops -DPOLYBENCH_TIME -DLARGE_DATASET bicg_a.c ../polybench.c -I../ -o vdaisy_a.out
for run in {1..5}; do ./vdaisy_a.out; done
fi