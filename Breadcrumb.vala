public class Breadcrumb : Gtk.Grid {
    private const string BREADCRUMB = """
        breadcrumb {
            padding: 0;
        }

        breadcrumb button:not(:last-child) .no-end-button {
            border-right-width: 0;
            border-top-right-radius: 0;
            border-bottom-right-radius: 0;
        }

        breadcrumb button:not(:first-child) > * {
            padding: 6px;
            padding-left: 22px;
            padding-right: 0;
        }

        breadcrumb button:first-child > * {
            padding:6px;
            padding-right: 0;
        }

        breadcrumb button:not(:first-child) .no-end-button {
            border-left-width: 0;
            border-top-left-radius: 0;
            border-bottom-left-radius: 0;
        }

        breadcrumb button .arrow-button {
            border-radius: 0;
            border-left-width: 0;
            border-bottom-width: 0;
        }

        breadcrumb button {
            outline-width: 0;
            box-shadow: 0px 0px;
        }
    """;

    class construct {
        set_css_name ("breadcrumb");
        var arrow_provider = new Gtk.CssProvider ();
        try {
            arrow_provider.load_from_data (BREADCRUMB);
        } catch (Error e) {
            critical (e.message);
        }

        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), arrow_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    construct {
        hexpand = true;
        var ele1 = new BreadcrumbElement ();
        var home_image = new Gtk.Image.from_icon_name ("user-home-symbolic", Gtk.IconSize.MENU);
        var home = new Gtk.Label ("home");
        var home_grid = new Gtk.Grid ();
        home_grid.add (home_image);
        home_grid.add (home);
        ele1.add (home_grid);

        var ele2 = new BreadcrumbElement ();
        var tintou = new Gtk.Label ("tintou");
        ele2.add (tintou);

        var ele3 = new BreadcrumbElement ();
        var est = new Gtk.Label ("est");
        ele3.add (est);

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
        cr.translate (width, 0);
        children.foreach ((child) => {
            cr.translate (-child.get_allocated_width (), 0);
            cr.save ();
            child.draw (cr);
            cr.restore ();
        });
        return true;
    }
}
