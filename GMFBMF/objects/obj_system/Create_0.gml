
var filename = @"C:\Users\MusNik\Desktop\test\f_fontin_pt22_bold_outlined.fnt";

var fnt = new Fnt();
fnt.load(filename);

var gmfont = new GMFont(fnt);

//fontyy_filename = get_save_filename_ext("GameMaker font (*.yy)|*.yy", fnt.name, "", "Save As");
fontyy_filename = @"C:\Users\MusNik\Documents\GameMakerStudio2\Strategy\Strategy\fonts\f_fontin_pt22_bold_outlined\f_fontin_pt22_bold_outlined.yy";
fontyy_file = file_text_open_write(fontyy_filename);

file_text_write_string(fontyy_file, json_minify(json_stringify(gmfont)));

file_text_close(fontyy_file);

game_end();