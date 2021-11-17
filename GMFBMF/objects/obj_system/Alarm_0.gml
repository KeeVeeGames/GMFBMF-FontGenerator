
switch (exportState) {
    case ExportState.Sizing:
        if (project.exportStateSizing()) {
            exportState = ExportState.GenerateYY;
        } else {
            show_debug_message("wait 1");
        }
        
        alarm[0] = exportStateTimeout;
        
        break;
    
    case ExportState.GenerateYY:
        if (project.exportStateGenerateYY()) {
            exportState = ExportState.None;
        } else {
            show_debug_message("wait 2");
        }
        
        alarm[0] = exportStateTimeout;
        
        break;
    
    case ExportState.None:
        if (project.exportStateChecking()) {
            show_debug_message("COMPLETE!");
        } else {
            show_debug_message("wait 3");
            alarm[0] = exportStateTimeout;
        }
        
        break;
        
}
// var filename = @"C:\Users\MusNik\Desktop\cera\Font2.fnt";
// // var filename = @"C:\Users\MusNik\Desktop\test\f_fontin_pt22_bold_outlined\f_fontin_pt22_bold_outlined.fnt";

// var fnt = new BMFont();
// fnt.load(filename);

// var gmfont = new GMFont(fnt);

// //fontyy_filename = get_save_filename_ext("GameMaker font (*.yy)|*.yy", fnt.name, "", "Save As");
// fontyy_filename = @"C:\Users\MusNik\Documents\GameMakerStudio2\test\fonts\Font2\Font2.yy";
// // fontyy_filename = @"C:\Users\MusNik\Documents\GameMakerStudio2\Strategy\Strategy\fonts\f_fontin_pt22_bold_outlined\f_fontin_pt22_bold_outlined.yy";
// fontyy_file = file_text_open_write(fontyy_filename);

// file_text_write_string(fontyy_file, json_minify(json_stringify(gmfont)));

// file_text_close(fontyy_file);

// var test_font = font_add(@"C:\Users\MusNik\Downloads\CeraPro\Alef-Regular.ttf", 24.09371, false, false, 0, 0);

// show_debug_message(font_get_info(test_font).glyphs[$ " "]);

// game_end();