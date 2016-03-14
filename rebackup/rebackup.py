import os
import tarfile

output = 'out.tar.gz'
target = 'testdir'

blacklist = ['testdir\\NI\\Maschine']


def ls(path):
    for entry in os.scandir(path):
        if entry.is_dir():
            print(entry.path)
            ls(entry.path)


def filter(path):
    if not os.path.isdir(path):
        return False

    excluded = path in blacklist
    print('Exclude', path, '? ->', excluded)
    return excluded


if __name__ == '__main__':
    with tarfile.open(output, 'w:gz') as tar:
        tar.add(target, exclude=filter)
