import dace

from daisytuner.profiling.measure import random_arguments

if __name__ == "__main__":
    sdfg = dace.SDFG.from_file("correlation/correlation.sdfg")

    # Instrument
    sdfg.instrument = dace.InstrumentationType.Timer
    for nsdfg in sdfg.all_sdfgs_recursive():
        for state in nsdfg.states():
            for node in state.nodes():
                if (
                    not isinstance(node, dace.nodes.MapEntry)
                    or state.entry_node(node) is not None
                ):
                    continue

                node.instrument = dace.InstrumentationType.Timer

    # Run
    args = random_arguments(sdfg)
    csdfg = sdfg.compile()
    csdfg(**args)

    report = sdfg.get_latest_report()
    print(report)
