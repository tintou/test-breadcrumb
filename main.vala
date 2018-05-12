

public int main (string[] args) {
    Gtk.init (ref args);

    var window = new Gtk.Window ();
    window.title = "First GTK+ Program";
    window.border_width = 10;
    window.window_position = Gtk.WindowPosition.CENTER;
    window.set_default_size (50, 400);
    window.destroy.connect (Gtk.main_quit);

    var grid = new Gtk.Grid ();
    grid.orientation = Gtk.Orientation.VERTICAL;
    var breadcrumb = new Breadcrumb ();

    grid.add (breadcrumb);
    window.add (grid);
    window.show_all ();

    Gtk.main ();
    return 0;
}
