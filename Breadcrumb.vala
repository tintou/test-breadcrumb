public class Breadcrumb : Gtk.Grid {
    private const string ARROW_BUTTON = """
        breadcrumb {
            padding: 0;
        }
    """;
    private static Gtk.CssProvider arrow_provider;

    class construct {
        set_css_name ("breadcrumb");
        arrow_provider = new Gtk.CssProvider ();
        try {
            arrow_provider.load_from_data (ARROW_BUTTON);
        } catch (Error e) {
            critical (e.message);
        }
    }

    construct {
        get_style_context ().add_provider (arrow_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        hexpand = true;
        var ele1 = new BreadcrumbElement ();
        ele1.label = "home";
        var ele2 = new BreadcrumbElement ();
        ele2.label = "tintou";
        var ele3 = new BreadcrumbElement ();
        ele3.label = "est";
        var ele4 = new BreadcrumbElement ();
        ele4.hexpand = true;
        orientation = Gtk.Orientation.HORIZONTAL;
        add (ele1);
        add (ele2);
        add (ele3);
        add (ele4);
    }

    public override bool draw (Cairo.Context cr) {
        int width = get_allocated_width ();
        int height = get_allocated_height ();
        var style_context = get_style_context ();

        Gtk.StateFlags state = style_context.get_state ();
        style_context.render_background (cr, 0, 0, width, height);
        style_context.render_frame (cr, 0, 0, width, height);

        Gtk.Border padding = style_context.get_padding (state);
        Gtk.Border margin = style_context.get_margin (state);

        cr.translate (margin.left, margin.top);
        cr.translate (padding.left, padding.top);
        var children = get_children ();
        children.reverse ();
        children.foreach ((child) => {
            cr.save ();
            child.draw (cr);
            cr.restore ();
            cr.translate (child.get_allocated_width (), 0);
        });
        return true;
    }
}
