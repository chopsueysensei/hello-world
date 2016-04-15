import os
import ctypes
import ctypes.wintypes
import time
from datetime import datetime, timedelta
import threading
import python_tools.systray_app as trayapp


TIMEFORMAT = '%d/%m/%Y %H:%M:%S'

homedir = os.path.expanduser('~/.workhours/')
runfile = homedir + 'run'
thread = None
app = None


#

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

    @property
    def chunkfile(self):
        return self._chunkfile

    #

    def __init__(self):
        self._alive = True

        thread = threading.Thread(target=self._thread_loop, args=())
        thread.start()

    def _thread_loop(self):
        '''
        Executes continuously (until killed), logging user activity 'chunks'
        to an output CSV file.
        '''
        self._finished = False
        self._chunkfile = '{}blocks_{}.csv'.format(homedir,
                                                   time.strftime('%Y%m%d',
                                                                 time.localtime()))

        # Touch a file which will serve as run indicator
        open(runfile, 'w').close()

        while self._alive:
            # Activity block start time
            block_time = time.strftime(TIMEFORMAT, time.localtime())
            block_start = GetTickCount()

            # Sleep until user idle
            # TODO Check app death (logout)
            self._wait_until_idle()

            block_end = GetTickCount()

            with open(self._chunkfile, 'a') as f:
                duration_secs = (block_end-block_start)//1000
                f.write('{}, {}\n'.format(block_time, duration_secs))

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
        idle_time_ms = int(idle_time*1000)
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

    def quit(self):
        self._alive = False

        # Block so that the systray app stays alive while the thread does
        while not self._finished:
            pass


def tooltip_updater():
    if os.path.exists(runfile):
        with open(thread.chunkfile, 'r') as f:
            timestr = f.readline().split(',')[0]

        startdate = datetime.strptime(timestr, TIMEFORMAT)
        totalsecs = (datetime.now() - startdate).total_seconds()
        m, s = divmod(totalsecs, 60)
        h, m = divmod(m, 60)

        tooltip = 'Tracking: {}:{} today'.format(int(h), int(m))
        app.update_tooltip(tooltip)

    # Repeat ourselves in a minute
    if thread.alive:
        threading.Timer(60, tooltip_updater).start()


if __name__ == '__main__':

    if not os.path.exists(homedir):
        os.makedirs(homedir)

    if os.path.exists(runfile):
        # Kill current running process
        raise ValueError('Already running!')
    else:
        try:
            # Launch thread
            thread = ActivityMonitorThread()
            # Start tooltip updater
            tooltip_updater()
            # Create systray app
            app = trayapp.SysTrayApp((),
                                     'Clock.ico',
                                     'Tracking time...',
                                     on_quit=thread.quit) #, default_menu_action_index=1)

        except:
            thread.quit()
            app.quit()
            raise



