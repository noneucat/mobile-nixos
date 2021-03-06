module GUI
  class AboutWindow < BaseWindow
    include ButtonPalette
    def initialize()
      super()
      BackButton.new(@toolbar, MainWindow.instance)
      @container.refresh

      LVGL::LVLabel.new(@container).tap do |label|
text = <<EOF
Mobile NixOS "Hello GUI"

This application is intended to provide a minimum viable known working framebuffer application to test different components of your mobile device.

This is NOT a complete useful system.
EOF
        label.set_long_mode(LVGL::LABEL_LONG::BREAK)
        label.set_text(text)
        label.set_align(LVGL::LABEL_ALIGN::CENTER)
        label.set_width(@container.get_width_fit)
      end
    end
  end
end
