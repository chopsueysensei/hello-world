import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
import rebackup


model = Gtk.TreeStore(str)
model.append(None, [rebackup.target])


class MainWindow(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self, title='Backup folder tree')
        self.set_border_width(10)

        self.box = Gtk.VBox(spacing=10)
        self.add(self.box)

        # Main tree
        self.tree = Gtk.TreeView(model)
        self.box.pack_start(self.tree, True, True, 0)

        self.tree.append_column(Gtk.TreeViewColumn('Path',
                                                   Gtk.CellRendererText(),
                                                   text=0))

        # Bottom button
        self.button = Gtk.Button(label='Go!')
        self.button.connect('clicked', self.on_button_clicked)
        self.box.pack_start(self.button, False, False, 0)

    def on_button_clicked(self, widget):
        print('Backup started')


win = MainWindow()
win.connect('delete-event', Gtk.main_quit)
win.show_all()

Gtk.main()
