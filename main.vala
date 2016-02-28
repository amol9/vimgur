using Gtk;
using GLib;
using Gdk;


public class Vimgur: Gtk.Application {

	private ApplicationWindow window;
	private Box top_box;
	private Box mid_box;
	private Box bot_box;
	private	Box main_box;
	private Image image;
	private Pixbuf pixbuf;

	private int image_c = 1;


	protected override void activate() {
		window = new ApplicationWindow (this);
		window.set_title("Vimgur");

		setup_widgets();

		var wg = Geometry();
		wg.min_height = 300;
		wg.max_height = 800;
		wg.min_width = 400;
		wg.max_width = 1000;
		
		window.set_geometry_hints(window, wg, WindowHints.MIN_SIZE | WindowHints.MAX_SIZE);

		window.set_default_size (1000, 600);
		window.show_all ();
	}

	private void setup_widgets() {
		main_box = new Box(Orientation.VERTICAL, 5);

		top_box = new Box(Orientation.HORIZONTAL, 5);
		top_box.set_size_request(-1, 50);

		var label = new Label("Title will go here");
		var btn_up = new Button.with_label("Up");
		btn_up.clicked.connect(on_btn_up);

		var btn_dn = new Button.with_label("Down");

		top_box.pack_start(label, true, true);
		top_box.pack_start(btn_up, false, false);
		top_box.pack_start(btn_dn, false, false);

		top_box.set_vexpand_set(true);
		top_box.set_vexpand(false);

		main_box.pack_start(top_box, false, false);

		mid_box = new Box(Orientation.HORIZONTAL, 5);

		image = new Image();

		mid_box.pack_start(image, true, true);

		main_box.pack_start(mid_box, true, true);

		bot_box = new Box(Orientation.HORIZONTAL, 5);
		bot_box.set_size_request(-1, 50);

		var lbl_cm = new Label("top comment will go here");
		var btn_cm_up = new Button.with_label("Up");
		var btn_cm_dn = new Button.with_label("Down");

		bot_box.pack_start(lbl_cm, true, true);
		bot_box.pack_start(btn_cm_up, false, false);
		bot_box.pack_start(btn_cm_dn, false, false);

		bot_box.set_vexpand_set(true);
		bot_box.set_vexpand(false);

		main_box.pack_start(bot_box, false, false);

		window.add(main_box);

	}

	public void on_btn_up(Button self){
		set_image(@"images/$image_c.jpg");
		image_c += 1;
	}

	public void set_image(string filepath){
		try {
			pixbuf = new Pixbuf.from_file(filepath);
		} catch (Error e) {
			stdout.printf("error creating pixbuf from file, %s", e.message);
			return;
		}

		int image_box_width = image.get_allocated_width();
		int image_box_height = image.get_allocated_height();
		
		stdout.printf("ibw: %d, ibh: %d\n", image_box_width, image_box_height);

		int image_width = pixbuf.width;
		int image_height = pixbuf.height;

		stdout.printf("iw: %d, ih: %d\n", image_width, image_height);

		if (image_width > image_box_width || image_height > image_box_height) {
			int new_width, new_height;
			float aspect_ratio = (float)image_width / image_height;

			new_width = image_width;
			new_height = image_height;

			if (image_width > image_box_width) {
				new_width = image_box_width;
				new_height = (int)(new_width / aspect_ratio);
			} 
	
			if (new_height > image_box_height) {
				new_height = image_box_height;
				new_width = (int)(new_height * aspect_ratio);
			}

			stdout.printf("nw: %d, nh: %d\n", new_width, new_height);
			Pixbuf new_pixbuf = pixbuf.scale_simple(new_width, new_height, InterpType.BILINEAR);
			image.set_from_pixbuf(new_pixbuf);
		} else {
			image.set_from_pixbuf(pixbuf);
		}
	}

}

public int main (string[] args) {
	return new Vimgur().run(args);
}

