import os
import shutil
import subprocess

from tqdm import tqdm
from pathlib import Path

benchmarks = sorted(
    [Path(f.path) for f in os.scandir(Path(__file__).parent) if f.is_dir()]
)
for benchmark in tqdm(benchmarks):
    if benchmark.name == ".git":
        continue

    if not (benchmark / f"{benchmark.name}_a.c").is_file():
        continue

    cmd = [
        "daisycc",
        "-O2",
        "-fno-unroll-loops",
        "-fschedule=multicore",
        "-fdump-raw-maps",
        "-DPOLYBENCH_TIME",
        "-DLARGE_DATASET",
        f"{benchmark.name}/{benchmark.name}_a.c",
        "./polybench.c",
        "-I./",
        f"-I./{benchmark.name}",
        "-o vdaisy.out",
        "-lm",
    ]
    if benchmark.name in ["cholesky", "correlation", "gramschmidt", "deriche"]:
        cmd.insert(1, "-ffast-math")

    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
    )
    stdout, stderr = process.communicate()
    if process.returncode > 0:
        print(stdout)
        print(stderr)
    assert process.returncode == 0

    for sdfg_path in (Path(__file__).parent / ".daisycache" / "raw_maps").glob(
        "*.sdfg"
    ):
        shutil.move(sdfg_path, Path(__file__).parent / "dataset")
