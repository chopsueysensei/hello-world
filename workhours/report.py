import os
import webbrowser
import pystache
from datetime import datetime, timedelta



def to_hourmin(total_seconds):
    m, s = divmod(total_seconds, 60)
    h, m = divmod(m, 60)

    return int(h), int(m)


def build_context(monitor_thread, timeformat):
    ctx = {}

    # Today
    fdate = datetime.now()
    fname = monitor_thread.chunkfile(fdate)
    with open(fname, mode='r') as f:
        timestr = f.readline().split(',')[0]

    startdate = datetime.strptime(timestr, timeformat)
    totalsecs = (fdate - startdate).total_seconds()
    h, m = to_hourmin(totalsecs)

    ctx['today_start'] = startdate.strftime('%H:%M')
    ctx['today_current'] = fdate.strftime('%H:%M')
    ctx['today_total'] = '{}:{:02d}'.format(h, m)

    # Week
    weekdays = []

    while fdate.weekday() != 0:
        fdate = fdate - timedelta(days=1)
        fname = monitor_thread.chunkfile(fdate)

        try:
            with open(fname, mode='r') as f:
                starttime_str = f.readline().split(',')[0]
                for line in f:
                    pass
                endtime_str = line.split(',')[0]
                endsecs = int(line.split(',')[1])
        except IOError:
            continue

        startdate = datetime.strptime(starttime_str, timeformat)
        enddate = datetime.strptime(endtime_str, timeformat) + \
            timedelta(seconds=endsecs)
        secs = (enddate - startdate).total_seconds()
        h, m = to_hourmin(secs)
        totalsecs += secs

        weekdays.append({
                        'dow': fdate.strftime('%A'),
                        'start': startdate.strftime('%H:%M'),
                        'end': enddate.strftime('%H:%M'),
                        'total': '{}:{:02d}'.format(h, m)
                        })

    ctx['weekday'] = weekdays
    h, m = to_hourmin(totalsecs)
    ctx['total_hours'] = '{}:{:02d} / 44h'.format(h, m)

    return ctx


def report(homedir, monitor_thread, timeformat):
    out = homedir + 'out.html'

    with open('template.mustache', mode='r') as f:
        text = f.read()

    ctx = build_context(monitor_thread, timeformat)
    html = pystache.render(text, ctx)

    with open(out, mode='w') as f:
        f.write(html)

    webbrowser.open(out)

