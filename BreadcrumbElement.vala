public class BreadcrumbElement : Gtk.EventBox {

    class construct {
        if (Gtk.Settings.get_default ().gtk_theme_name == "elementary"){
            set_css_name ("breadcrumb-entry");
        } else {
            set_css_name ("button");
        }
    }

    construct {
        can_focus = true;
        focus_out_event.connect (() => {
            queue_redraw ();
        });
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

        var arrow_width = (height + border.left + border.right)/GLib.Math.SQRT2;
        var arrow_height = (height + border.top + border.bottom)/GLib.Math.SQRT2;
        var arrow_x = (height/2 + border.left + border.right)/GLib.Math.SQRT2;
        var arrow_y = (height/2 + border.top + border.bottom)/GLib.Math.SQRT2;

        style_context.save ();
        style_context.add_class ("no-end-button");
        style_context.render_background (cr, 0, 0, width, height);
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
        style_context.render_background (cr, -arrow_x, -arrow_y, arrow_width, arrow_height);
        style_context.render_frame (cr, -arrow_x, -arrow_y, arrow_width, arrow_height);
        style_context.render_focus (cr, -arrow_x, -arrow_y, arrow_width, arrow_height);
        style_context.restore ();

        cr.restore ();

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

    public int get_arrow_width () {
        int height = get_allocated_height ();
        var parent_style_context = get_parent ().get_style_context ();
        Gtk.Border parent_padding = parent_style_context.get_padding (parent_style_context.get_state ());
        height += parent_padding.top + parent_padding.bottom;

        return height/2;
    }

    public override bool button_press_event (Gdk.EventButton event) {
        set_state_flags (Gtk.StateFlags.ACTIVE, false);
        queue_redraw ();
        return base.button_press_event (event);
    }

    public override bool button_release_event (Gdk.EventButton event) {
        unset_state_flags (Gtk.StateFlags.ACTIVE);
        grab_focus ();
        queue_redraw ();
        return base.button_release_event (event);
    }

    public override bool key_press_event (Gdk.EventKey event) {
        if (event.keyval == Gdk.Key.Return) {
            set_state_flags (Gtk.StateFlags.ACTIVE, false);
            queue_redraw ();
        }

        return base.key_press_event (event);
    }

    public override bool key_release_event (Gdk.EventKey event) {
        if (event.keyval == Gdk.Key.Return) {
            unset_state_flags (Gtk.StateFlags.ACTIVE);
            queue_redraw ();
        }

        return base.key_release_event (event);
    }

    public override void get_preferred_width (out int minimum_width, out int natural_width) {
        base.get_preferred_width (out minimum_width, out natural_width);
        var arrow_width = get_arrow_width ();
        minimum_width += arrow_width;
        natural_width += arrow_width;
    }

    private void queue_redraw () {
        get_parent ().queue_draw ();
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
