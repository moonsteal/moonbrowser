--[[--
 @package   MoonBrowser
 @filename  moonbrowser-app.lua
 @version   1.0
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      23.12.2020 22:09:44 -04
]]

content = Gtk.Box {
    orientation = 'HORIZONTAL',
    expand = false,
    Gtk.Button {
        id = 'btn_back',
        relief = Gtk.ReliefStyle.NONE,
        Gtk.Image { icon_name = 'back-symbolic' },
        on_clicked = function() webview:go_back() end
    },
	Gtk.Button {
        id = 'btn_forward',
        relief = Gtk.ReliefStyle.NONE,
        Gtk.Image { icon_name = 'next-symbolic' },
        on_clicked = function() webview:go_forward() end
	},
    Gtk.Button {
        id = 'btn_reload',
        relief = Gtk.ReliefStyle.NONE,
        Gtk.Image { icon_name = 'reload-symbolic' },
        on_clicked = function() webview:reload() end
	},
    Gtk.Separator(),
    Gtk.Entry { id = 'entry_url', expand = true },
    Gtk.Separator(),
    Gtk.Button {
        id = 'btn_home',
        relief = Gtk.ReliefStyle.NONE,
        Gtk.Image { icon_name = 'gtk-home-symbolic' },
        on_clicked = function()
            webview:load_uri('http://duckduckgo.com')
            ui.entry_url.text = 'duckduckgo.com'
        end
	},
}

main_window	= Gtk.Window {
	width_request	= 800,
	height_request	= 600,
    Gtk.Box {
        orientation = 'VERTICAL',
        content,
        Gtk.ScrolledWindow { id = 'scroll', expand = true }
    }
}


function moonbrowser_init()
    webview:load_uri('http://duckduckgo.com')
    main_window.child.entry_url.text = 'duckduckgo.com'
    main_window.title = webview:get_title()
end

GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 1,function()
    main_window.title = webview:get_title()
    return true
end)

function main_window:on_destroy()
    Gtk.main_quit()
end

function main_window.child.entry_url:on_key_release_event(event)
    if ( event.keyval  == Gdk.KEY_Return ) then
      webview:load_uri('http://' .. main_window.child.entry_url.text)
    end
end

function app:on_activate()
	main_window.child.scroll:add(webview)
    main_window.child.entry_url.set_icon_from_icon_name(
        main_window.child.entry_url,
        1,
        'find-symbolic'
    )
    main_window:show_all()
    moonbrowser_init()
	self:add_window(main_window)
end

