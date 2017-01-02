import ctypes
import ctypes.wintypes
import threading
import time
import os
from datetime import datetime, timedelta


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

#


class ActivityMonitorThread(object):
    # ::Public API::

    @property
    def alive(self):
        return self._alive

    def chunkfile(self, local_datetime):
        return self._fnfmt.format(self._homedir,
                                  local_datetime.strftime('%Y%m%d'))

    def quit(self):
        self._alive = False

        # Block so that the systray app stays alive while the thread does
        while not self._finished:
            pass

    #

    def __init__(self, homedir, timeformat_str):
        self._alive = True
        self._fnfmt = '{}blocks_{}.csv'
        self._homedir = homedir
        self._timefmt = timeformat_str

        thread = threading.Thread(target=self._thread_loop, args=())
        thread.start()

    def _thread_loop(self):
        '''
        Executes continuously (until killed), logging user activity 'chunks'
        to an output CSV file.
        '''
        self._finished = False
        runfile = self._homedir + 'run'

        # Touch a file which will serve as run indicator
        open(runfile, 'w').close()

        # TODO Check app death (exceptions) and log them somewhere
        while self._alive:
            # Activity block start time
            block_time = time.localtime()
            block_start = GetTickCount()

            # Sleep until user idle
            self._wait_until_idle()

            block_end = GetTickCount()

            with open(self.chunkfile(datetime.now()), 'a') as f:
                block_time_str = time.strftime(self._timefmt, block_time)
                duration_secs = (block_end - block_start) // 1000

                f.write('{}, {}\n'.format(block_time_str, duration_secs))

            # Now wait till there's activity again
            self._wait_until_active()

        os.remove(runfile)
        self._finished = True

    def _wait_until_idle(self, idle_time=60):
        '''
        Wait until no more user activity is detected.

        This function won't return until 'idle_time' seconds have elapsed
        since the last user activity was detected.
        '''
        idle_time_ms = int(idle_time * 1000)
        liinfo = LASTINPUTINFO()
        liinfo.cbSize = ctypes.sizeof(liinfo)

        while self._alive:
            GetLastInputInfo(ctypes.byref(liinfo))

            elapsed = GetTickCount() - liinfo.dwTime
            if elapsed >= idle_time_ms:
                break

            Sleep(500)

    def _wait_until_active(self):
        '''
        Wait until user activity is detected.
        '''
        liinfo = LASTINPUTINFO()
        liinfo.cbSize = ctypes.sizeof(liinfo)

        while self._alive:
            GetLastInputInfo(ctypes.byref(liinfo))

            elapsed = GetTickCount() - liinfo.dwTime
            if elapsed < 1000:
                break

            Sleep(500)
