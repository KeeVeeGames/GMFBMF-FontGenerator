/// @param {obj_system} system
function Project(_system/*:obj_system*/) constructor {
    system = _system;       /// @is {obj_system}
    
    data = {
        name : "",
        yyHash : "",
        padding : new Inset(2, 2, 2, 2),
        border : new Inset(1, 0, 1, 0)
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
        
        // _bmfcInsertValue("fontName=", yyGMFont.data.fontName);
        _bmfcInsertValue("fontName=", string_replace_all(yyGMFont.data.fontName + "-" + yyGMFont.data.styleName, " ", ""));
        _bmfcInsertValue("fontFile=", fontname);
        _bmfcInsertValue("fontSize=-", string(round(yyGMFont.data.size / 0.75)));
        _bmfcInsertValue("isBold=", string(yyGMFont.data.bold));
        _bmfcInsertValue("isItalic=", string(yyGMFont.data.italic));
        
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
            
            file_delete(directory + "\\" + data.name + ".fnt");
            
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
        
        return true;
    }
    
    static exportStateChecking = function()/*->bool*/ {
        if (file_exists(directory + "\\" + data.name + ".png") && file_exists(directory + "\\" + data.name + ".yy")) {
            return true;
        }
        
        return false;
    }
}