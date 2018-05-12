public class BreadcrumbElement : Gtk.Widget {
    private const string ARROW_BUTTON = """
        button:not(:last-child) .no-end-button {
            border-right-width: 0;
            border-top-right-radius: 0;
            border-bottom-right-radius: 0;
        }

        button {
            padding-right:0px;
        }

        button:not(:first-child) {
            padding-left: 16px;
        }

        button:not(:first-child) .no-end-button {
            border-left-width: 0px;
            border-top-left-radius: 0;
            border-bottom-left-radius: 0;
        }

        button .arrow-button {
            border-radius: 0px;
            border-left-width: 0;
            border-bottom-width: 0;
        }
    """;


    private string _label = "";
    public string label {
        get {
            return _label;
        }
        set {
            if (_label != value) {
                _label = value;
                layout = create_pango_layout (value);
            }
        }
    }

    private static Gtk.CssProvider arrow_provider;
    private Pango.Layout layout;

    class construct {
        set_css_name ("button");
        arrow_provider = new Gtk.CssProvider ();
        try {
            arrow_provider.load_from_data (ARROW_BUTTON);
        } catch (Error e) {
            critical (e.message);
        }
    }

    construct {
        layout = create_pango_layout (label);
        set_has_window (false);
        get_style_context ().add_class (Gtk.STYLE_CLASS_BUTTON);
        get_style_context ().add_provider (arrow_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    public override bool draw (Cairo.Context cr) {
        int width = get_allocated_width ();
        int height = get_allocated_height ();

        weak Gtk.StyleContext style_context = get_style_context ();
        var state = style_context.get_state ();
        Gtk.Border margin = style_context.get_margin (state);
        cr.translate (margin.left, margin.top);
        width -= margin.left + margin.right;
        height -= margin.top + margin.bottom;

        var parent_style_context = get_parent ().get_style_context ();
        Gtk.Border parent_padding = parent_style_context.get_padding (parent_style_context.get_state ());
        cr.translate (-parent_padding.left, -parent_padding.top);
        width += parent_padding.left + parent_padding.right;
        height += parent_padding.top + parent_padding.bottom;

        var border = style_context.get_border (state);
        var padding = style_context.get_padding (state);

        style_context.save ();
        style_context.add_class ("no-end-button");
        style_context.render_frame (cr, 0, 0, width, height);
        style_context.render_focus (cr, 0, 0, width, height);
        style_context.restore ();
        cr.save ();
        cr.translate (width, height / 2 + border.top);
        cr.rectangle (0, -height / 2, height - border.top - border.bottom, height - border.left - border.right);
        cr.clip ();
        cr.rotate (Math.PI_4);
        style_context.save ();
        style_context.add_class ("arrow-button");
        var square_width = (height + border.left + border.right)/GLib.Math.SQRT2;
        var square_height = (height + border.top + border.bottom)/GLib.Math.SQRT2;
        var square_width2 = (height/2 + border.left + border.right)/GLib.Math.SQRT2;
        var square_height2 = (height/2 + border.top + border.bottom)/GLib.Math.SQRT2;
        style_context.render_frame (cr, -square_width2, -square_height2, square_width, square_height);
        style_context.restore ();
        cr.restore ();

        style_context.render_layout (cr, padding.left, padding.top, layout);

        return true;
    }

    public int get_arrow_width () {
        int height = get_allocated_height ();
        var parent_style_context = get_parent ().get_style_context ();
        Gtk.Border parent_padding = parent_style_context.get_padding (parent_style_context.get_state ());
        height += parent_padding.top + parent_padding.bottom;

        return height/2;
    }

    public override void get_preferred_height (out int minimum_height, out int natural_height) {
        int width;
        int height;
        var style_context = get_style_context ();
        Gtk.Border padding = style_context.get_padding (style_context.get_state ());
        Gtk.Border margin = style_context.get_margin (style_context.get_state ());

        layout.get_pixel_size (out width, out height);
        minimum_height = height + padding.top + padding.bottom + margin.top + margin.bottom;
        natural_height = minimum_height;
        //base.get_preferred_height (out minimum_height, out natural_height);
    }

    public override void get_preferred_width (out int minimum_width, out int natural_width) {
        int width;
        int height;
        var style_context = get_style_context ();
        Gtk.Border padding = style_context.get_padding (style_context.get_state ());
        Gtk.Border margin = style_context.get_margin (style_context.get_state ());

        layout.get_pixel_size (out width, out height);
        minimum_width = width + padding.left + padding.right + margin.left + margin.right;
        natural_width = minimum_width;
    }

    /*
     * This method gets called by Gtk+ when the actual size is known
     * and the widget is told how much space could actually be allocated.
     * It is called every time the widget size changes, for example when the
     * user resizes the window.
     */
    public override void size_allocate (Gtk.Allocation allocation) {
        // The base method will save the allocation and move/resize the
        // widget's GDK window if the widget is already realized.
        base.size_allocate (allocation);

        // Move/resize other realized windows if necessary
    }
}
