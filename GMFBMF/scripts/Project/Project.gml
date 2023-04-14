/// @param {obj_system} system
function Project(_system/*:obj_system*/) constructor {
    system = _system;       /// @is {obj_system}
    
    data = {
        name : "",
        yyHash : "",
        padding : new Inset(8, 8, 8, 8),
        border : new Inset(0, 0, 0, 0)
    };
    
    yyGMFont = new GMFont();
    directory = "";
    textureWidth = 64;
    textureHeight = 64;
    
    _bmfcTemplate = "";
    _bmfcSeekPosInsert = 1;
    _bmfcSeekPosReplace = 1;
    
    static createNew = function(yy_filename/*:string*/) {
        if (yy_filename != "") {
            directory = filename_dir(yy_filename);
            
            data.name = string_delete(directory, 1, string_last_pos("\\", directory));
            data.yyHash = md5_file(yy_filename);
            
            var base_filename = directory + "\\" + data.name + ".base.yy";
            file_copy(yy_filename, base_filename);
            
            save();
            
            yyGMFont.load(yy_filename);
        }
    }
    
    static open = function(project_filename/*:string*/) {
        if (project_filename != "") {
            var json = file_text_orc(project_filename);
            data = json_parse(json);
            
            directory = filename_dir(project_filename);
            
            var base_filename = directory + "\\" + data.name + ".base.yy";
            yyGMFont.load(base_filename);
        }
    }
    
    static save = function() {
        var filename = directory + "\\" + data.name + ".json";
        
        file_text_owc(filename, json_beautify(json_stringify(data)));
    }
    
    static generate = function() {
        _bmfcTemplate = file_text_orc("template.bmfc");
        _bmfcSeekPosInsert = 1;
        
        var fontname = filename_name(yyGMFont.data.TTFName);
        if (fontname != "") fontname = directory + "\\" + fontname;
        
        _bmfcInsertValue("fontName=", yyGMFont.data.fontName);
        // _bmfcInsertValue("fontName=", string_replace_all(yyGMFont.data.fontName + "-" + yyGMFont.data.styleName, " ", ""));
        _bmfcInsertValue("fontFile=", fontname);
        _bmfcInsertValue("fontSize=-", string(round(yyGMFont.data.size / 0.75)));
        // _bmfcInsertValue("isBold=", string(yyGMFont.data.bold));
        _bmfcInsertValue("isBold=", yyGMFont.data.styleName == "Bold" ? "1" : "0");
        // _bmfcInsertValue("isItalic=", string(yyGMFont.data.italic));
        _bmfcInsertValue("isItalic=", yyGMFont.data.styleName == "Italic" ? "1" : "0");
        
        _bmfcInsertValue("paddingDown=", string(data.padding.bottom));
        _bmfcInsertValue("paddingUp=", string(data.padding.top));
        _bmfcInsertValue("paddingRight=", string(data.padding.right));
        _bmfcInsertValue("paddingLeft=", string(data.padding.left));
        
        _bmfcSeekPosReplace = _bmfcSeekPosInsert;
        
        _bmfcInsertValue("outWidth=", string(textureWidth));
        _bmfcInsertValue("outHeight=", string(textureHeight));
        
        var chars = "";
        for (var i = 0, i_size = array_length(yyGMFont.data.ranges); i < i_size; i++) {
            var range = yyGMFont.data.ranges[i];
            
            if (i != 0) {
                chars += ",";
            }
            
            chars += string(range.lower) + "-" + string(range.upper);
        }
        
        _bmfcInsertValue("chars=", chars);
        
        var bmfc_name = directory + "\\" + data.name + ".bmfc";
        file_text_owc(bmfc_name, _bmfcTemplate);
        
        show_debug_message(working_directory + "\\bmfont\\bmfont64.exe" + " -c " + bmfc_name + " -o " + directory + "\\" + data.name + ".fnt");
        execute_shell_simple(working_directory + "\\bmfont\\bmfont64.exe", "-c " + bmfc_name + " -o " + directory + "\\" + data.name + ".fnt");
        
        system.loadProcess();
    }
    
    static _bmfcInsertValue = function(opening/*:string*/, value/*:string*/) {
        _bmfcSeekPosInsert = string_pos_ext(opening, _bmfcTemplate, _bmfcSeekPosInsert) + string_length(opening);
        _bmfcTemplate = string_insert(value, _bmfcTemplate, _bmfcSeekPosInsert);
        _bmfcSeekPosInsert += string_length(value) - 1;
    }
    
    static _bmfcReplaceValue = function(opening/*:string*/, closing/*:string*/, value/*:string*/) {
        _bmfcSeekPosReplace = string_pos_ext(opening, _bmfcTemplate, _bmfcSeekPosReplace) + string_length(opening);
        _bmfcTemplate = string_delete(_bmfcTemplate, _bmfcSeekPosReplace, string_pos_ext(closing, _bmfcTemplate, _bmfcSeekPosReplace) - _bmfcSeekPosReplace);
        _bmfcTemplate = string_insert(value, _bmfcTemplate, _bmfcSeekPosReplace);
        _bmfcSeekPosReplace += string_length(value) - 1;
    }
    
    static exportStateSizing = function()/*->bool*/ {
        if (file_exists(directory + "\\" + data.name + ".fnt")) {
            var pngs = [];
            var find = file_find_first(directory + "\\" + data.name + "_*.png", 0);
            
            for (var i = 0; find != ""; i++) {
                pngs[i] = find;
                find = file_find_next();
            }
            
            file_find_close();
            
            if (i == 1) {
                return true;
            }
            
            for (var i = 0, i_size = array_length(pngs); i < i_size; i++) {
                file_delete(directory + "\\" + pngs[i]);
            }
            
            if (i == 0) {
                i = 2;
            }
            
            file_delete(directory + "\\" + data.name + ".fnt");
            
            show_debug_message(floor(log2(i)));
            
            repeat(floor(log2(i))) {
                if (textureWidth > textureHeight) {
                    textureHeight *= 2;
                } else {
                    textureWidth *= 2;
                }
            }
            
            _bmfcSeekPosReplace = 1;
            
            _bmfcReplaceValue("outWidth=", "\r\n", string(textureWidth));
            _bmfcReplaceValue("outHeight=", "\r\n", string(textureHeight));
            
            var bmfc_name = directory + "\\" + data.name + ".bmfc";
            file_delete(bmfc_name);
            file_text_owc(bmfc_name, _bmfcTemplate);
            
            execute_shell_simple(working_directory + "\\bmfont\\bmfont64.exe", "-c " + bmfc_name + " -o " + directory + "\\" + data.name + ".fnt");
        }
        
        return false;
    }
    
    static exportStateGenerateYY = function()/*->bool*/ {
        var bmfont = new BMFont();
        if (!bmfont.load(directory + "\\" + data.name + ".fnt")) return false;
        
        var yy_filename = directory + "\\" + data.name + ".yy";
        
        yyGMFont.update(self, bmfont);
        yyGMFont.save(yy_filename);
        data.yyHash = md5_file(yy_filename);
        
        file_copy(directory + "\\" + data.name + "_0.png", directory + "\\" + data.name + ".png");
        file_delete(directory + "\\" + data.name + "_0.png");
        
        return true;
    }
    
    static exportStateChecking = function()/*->bool*/ {
        if (file_exists(directory + "\\" + data.name + ".png") && file_exists(directory + "\\" + data.name + ".yy")) {
            return true;
        }
        
        return false;
    }
    
    static constructMsdf = function()/*->void*/ {
        var png_font = directory + "\\" + data.name + ".png";
        var png_msdf = directory + "\\" + "msdf.png";
        
        if (!file_exists(png_font)) throw string("No {0} file found", png_font);
        if (!file_exists(png_msdf)) throw string("No {0} file found", png_msdf);
        
        var spr_font = sprite_add(png_font, 1, false, false, 0, 0);
        var spr_msdf = sprite_add(png_msdf, 1, false, false, 0, 0);
        
        var bmfont_font = new BMFont();
        if (!bmfont_font.load(directory + "\\" + data.name + ".fnt")) throw "Main fnt file not found";
        
        var bmfont_msdf = new BMFont();
        if (!bmfont_msdf.load(directory + "\\" + "msdf.fnt")) throw "MSDF fnt file not found";
        
        // var surf = surface_create(sprite_get_width(spr_font), sprite_get_height(spr_font));
        // surface_set_target(surf);
        // draw_clear(c_black);
        // draw_sprite(spr_font, 0, 0, 0);
        // surface_reset_target();
        
        var surf_msdf = surface_create(sprite_get_width(spr_font), sprite_get_height(spr_font));
        surface_set_target(surf_msdf);
        draw_clear(c_black);
        
        var chars_font = bmfont_font.chars;
        for (var i = 0, length = array_length(chars_font); i < length; i++) {
            var char_font = chars_font[i];
            
            // draw_set_color(c_white);
            // draw_rectangle(char_font.x, char_font.y, char_font.x + char_font.width, char_font.y + char_font.height, true);
            
            var char_msdf = bmfont_msdf.chars[bmfont_msdf.charsMap[$ string(char_font.id)]];
            
            // draw_set_color(c_red);
            // draw_rectangle(char_font.x, char_font.y + char_msdf.yoffset, char_font.x + char_font.width, char_font.y + char_font.height, true);
            
            draw_sprite_part(
                spr_msdf,
                0,
                char_msdf.x,
                char_msdf.y,
                char_msdf.width,
                char_msdf.height,
                char_font.x - char_font.xoffset + char_msdf.xoffset,
                char_font.y - char_font.yoffset + char_msdf.yoffset + (bmfont_font.lineHeight - bmfont_font.size)
            );
        }
        
        surface_reset_target();
        
        // file_copy(directory + "\\" + data.name + ".png", directory + "\\" + data.name + ".original.png");
        surface_save(surf_msdf, directory + "\\" + data.name + ".png");
        
        // surface_save(surf, "surf_font.png");
        surface_save(surf_msdf, "surf_msdf.png");
    }
}