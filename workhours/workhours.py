import os
import threading
from datetime import datetime
from functools import partial

import monitor_thread
import python_tools.systray_app as trayapp
import report


TIMEFORMAT = '%d/%m/%Y %H:%M:%S'

homedir = os.path.expanduser('~/.workhours/')
runfile = homedir + 'run'


#

def reportfunc(thread):
    return partial(report.report, homedir, thread, TIMEFORMAT)


def tooltip_updater(app, thread):
    fname = thread.chunkfile(datetime.now())

    if (thread.alive and
        app is not None and
        os.path.exists(fname)):

        with open(fname, 'r') as f:
            timestr = f.readline().split(',')[0]

        startdate = datetime.strptime(timestr, TIMEFORMAT)
        totalsecs = (datetime.now() - startdate).total_seconds()
        m, s = divmod(totalsecs, 60)
        h, m = divmod(m, 60)

        tooltip = 'Tracking: {}:{:02d} today'.format(int(h), int(m))
        app.update_tooltip(tooltip)

    # Repeat ourselves in a minute
    if thread.alive:
        t = threading.Timer(60, tooltip_updater, [app, thread])
        t.daemon = True
        t.start()


if __name__ == '__main__':

    if not os.path.exists(homedir):
        os.makedirs(homedir)

    if os.path.exists(runfile):
        # Kill current running process
        raise ValueError('Already running!')
    else:
        try:
            # Launch thread
            thread = monitor_thread.ActivityMonitorThread(homedir, TIMEFORMAT)

            menu = (('Report', None, reportfunc(thread)),)
            # Create systray app
            app = trayapp.SysTrayApp(menu,
                                     'Clock.ico',
                                     'Tracking time...',
                                     on_quit=thread.quit) #, default_menu_action_index=1)
            # Start tooltip updater
            tooltip_updater(app, thread)

            app.run()

        except:
            thread.quit()
            app.quit()
            raise

