md dist
xcopy Clock.ico dist
xcopy template.mustache dist

cxfreeze workhours.py --target-dir=dist --include-modules=imp --base-name=Win32GUI