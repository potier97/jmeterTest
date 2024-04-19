import sys
import os
import xml.etree.ElementTree as ET

def update_file(file_path, output_folder, num_threads, ramp_up):
    tree = ET.parse(file_path)
    root = tree.getroot()
    thread_group = root.find(".//ThreadGroup")
    thread_group.find("intProp[@name='ThreadGroup.num_threads']").text = str(num_threads)
    thread_group.find("intProp[@name='ThreadGroup.ramp_time']").text = str(ramp_up)
    perfmon_collector = root.find(".//kg.apc.jmeter.perfmon.PerfMonCollector")
    print(perfmon_collector.find("stringProp[@name='filename']").text)
    print(os.path.join(output_folder, "results-performance.csv"))
    perfmon_collector.find("stringProp[@name='filename']").text = os.path.join(output_folder, "results-performance.csv")
    tree.write(file_path)

#Test
# update_file("test.jmx", "jmeter_scripts\First.jmx_results\iteration_1_threads_1000_rampup_1000\results", 10000, 10000)


if __name__ == "__main__":
    file_path = sys.argv[1]
    output_folder = sys.argv[2]
    num_threads = int(sys.argv[3])
    ramp_up = int(sys.argv[4])

    update_file(file_path, output_folder, num_threads, ramp_up)