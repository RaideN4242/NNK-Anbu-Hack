#include <amxmodx>

#define PLUGIN  "NNK Anbu Class Menu"
#define VERSION "1.1"
#define AUTHOR  "RaideN4242"

// VGUIMenu ID for class selection (from mp.dll: 0x33 = 51)
#define VGUI_CHOOSE_CLASS 51

new const g_szClassNames[][] = {
    "\yNaruto",
    "\ySasuke",
    "\ySakura",
    "\yKakashi",
    "\rAnbu"
};

new const g_szClassCleanNames[][] = {
    "Naruto",
    "Sasuke",
    "Sakura",
    "Kakashi",
    "Anbu"
};

new const g_szClassCmds[][] = {
    "naruto",
    "sasuke",
    "sakura",
    "kakashi",
    "anbu"
};

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);

    register_clcmd("chooseclass",     "cmd_ChooseClass");
    register_clcmd("say /class",      "cmd_ChooseClass");
    register_clcmd("say_team /class", "cmd_ChooseClass");
    register_clcmd("say /anbu",       "cmd_SelectAnbu");
    register_clcmd("say_team /anbu",  "cmd_SelectAnbu");

    new msgid = get_user_msgid("VGUIMenu");
    if (msgid > 0)
    {
        register_message(msgid, "msg_VGUIMenu");
    }
}

public msg_VGUIMenu(msgid, dest, id)
{
    if (!is_user_connected(id))
        return PLUGIN_CONTINUE;

    if (get_msg_arg_int(1) == VGUI_CHOOSE_CLASS)
    {
        ShowClassMenu(id);
        return PLUGIN_HANDLED;
    }

    return PLUGIN_CONTINUE;
}

public cmd_ChooseClass(id)
{
    if (!is_user_connected(id))
        return PLUGIN_HANDLED;

    ShowClassMenu(id);
    return PLUGIN_HANDLED;
}

public cmd_SelectAnbu(id)
{
    if (!is_user_connected(id))
        return PLUGIN_HANDLED;

    client_cmd(id, "selclass anbu");
    client_print(id, print_chat, "[NNK] Selected class: Anbu");
    return PLUGIN_HANDLED;
}

public ShowClassMenu(id)
{
    new menu = menu_create("\r[NNK] \yChoose Character:", "ClassMenu_Handler");

    for (new i = 0; i < sizeof(g_szClassNames); i++)
    {
        menu_additem(menu, g_szClassNames[i]);
    }

    menu_setprop(menu, MPROP_NUMBER_COLOR, "\r");
    menu_setprop(menu, MPROP_EXITNAME, "\yExit");
    menu_display(id, menu, 0);
}

public ClassMenu_Handler(id, menu, item)
{
    if (item == MENU_EXIT || !is_user_connected(id))
    {
        menu_destroy(menu);
        return PLUGIN_HANDLED;
    }

    if (item >= 0 && item < sizeof(g_szClassCmds))
    {
        // Execute selclass on client side so client.dll updates HUD/portrait
        client_cmd(id, "selclass %s", g_szClassCmds[item]);
        client_print(id, print_chat, "[NNK] Selected class: %s", g_szClassCleanNames[item]);
    }

    menu_destroy(menu);
    return PLUGIN_HANDLED;
}