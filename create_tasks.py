
prefix = 'task: '
separator = 'COLORIZE AND PRINT STATS'

run_log_file = '../run.log'


def minify_line(line):
    return line.strip().replace(prefix, '').replace('Component://Электрическая система УАЗ.', '').replace('Container://Электрическая система УАЗ.', '')


def get_rels_from_file(filename):
    with open (filename, encoding="utf-8") as run_log:
        for line in run_log:
            if prefix in line:
                yield minify_line(line)
            if separator in line:
                yield separator




tasks = list()

for line in get_rels_from_file(run_log_file):
    if line == separator:
        # drop tasks, because detected newer logs
        tasks = []
    else:
        tasks.append(line)


for task in tasks:
    print(task)