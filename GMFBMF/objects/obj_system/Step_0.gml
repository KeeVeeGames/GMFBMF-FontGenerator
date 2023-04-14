
if (keyboard_check_pressed(vk_f1)) {
    project.createNew(get_open_filename_ext("GameMaker font (*.yy)|*.yy", "", "", "Open GameMaker font to create a new Project"));
}

if (keyboard_check_pressed(vk_f2)) {
    project.generate();
}

if (keyboard_check_pressed(vk_f3)) {
    project.open(get_open_filename_ext("GMFBMF Project (*.json)|*.json", "", "", "Open Project"));
}

if (keyboard_check_pressed(vk_f4)) {
    project.exportStateGenerateYY();
}

if (keyboard_check_pressed(vk_f5)) {
    project.constructMsdf();
}