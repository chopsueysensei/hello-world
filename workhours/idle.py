import ctypes
import ctypes.wintypes
import time
import os
import _thread


homedir = os.path.expanduser('~/.workhours')
runfile = homedir + 'run'


# http://msdn.microsoft.com/en-us/library/ms646272(VS.85).aspx
# typedef struct tagLASTINPUTINFO {
#     UINT cbSize;
#     DWORD dwTime;
# } LASTINPUTINFO, *PLASTINPUTINFO;


class LASTINPUTINFO(ctypes.Structure):
    _fields_ = [
      ('cbSize', ctypes.wintypes.UINT),
      ('dwTime', ctypes.wintypes.DWORD),
      ]

PLASTINPUTINFO = ctypes.POINTER(LASTINPUTINFO)

# http://msdn.microsoft.com/en-us/library/ms646302(VS.85).aspx
# BOOL GetLastInputInfo(PLASTINPUTINFO plii);

user32 = ctypes.windll.user32
GetLastInputInfo = user32.GetLastInputInfo
GetLastInputInfo.restype = ctypes.wintypes.BOOL
GetLastInputInfo.argtypes = [PLASTINPUTINFO]

kernel32 = ctypes.windll.kernel32
GetTickCount = kernel32.GetTickCount
Sleep = kernel32.Sleep


def wait_until_idle(idle_time=60):
    '''Wait until no more user activity is detected.

    This function won't return until `idle_time` seconds have elapsed
    since the last user activity was detected.
    '''

    idle_time_ms = int(idle_time*1000)
    liinfo = LASTINPUTINFO()
    liinfo.cbSize = ctypes.sizeof(liinfo)
    while True:
        GetLastInputInfo(ctypes.byref(liinfo))
        elapsed = GetTickCount() - liinfo.dwTime
        if elapsed >= idle_time_ms:
            break
        Sleep(idle_time_ms - elapsed or 1)


def thread_loop():
    '''Executes continuously (until killed), logging user activity 'chunks'
    to and output CSV file.
    '''

    alive = True
    filename = 'blocks_' + time.strftime('%Y%m%d', gmtime())
    open(runfile, 'w').close()

    while(alive):
        block_time = time.strftime('%H:%M:%S', gmtime())
        block_start = GetTickCount()
        # Sleep until user idle
        wait_until_idle()
        block_end = GetTickCount()

        with open(filename, 'a') as f:
            duration_secs = (block_end-block_start)//1000
            f.write('{}, {}\n'.format(block_time, duration_secs))

    os.remove(runfile)


if __name__ == '__main__':

    if not os.path.exists(homedir):
        os.makedirs(homedir)

    if os.path.exists(runfile):
        # Kill current running process
        raise NotImplementedError()
    else:
        # Launch thread
        _thread.start_new_thread(thread_loop, ())
