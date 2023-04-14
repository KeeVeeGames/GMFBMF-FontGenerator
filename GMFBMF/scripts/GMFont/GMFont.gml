function GMFont() constructor {
    data = {
      hinting: 0,
      glyphOperations: 0,
      interpreter: 0,
      pointRounding: 0,
      fontName: "",
      styleName: "",
      size: 0,
      bold: false,
      italic: false,
      charset: 0,
      AntiAlias: 1,
      first: 0,
      last: 0,
      sampleText: "",
      includeTTF: true,
      TTFName: "",
      textureGroupId: {},
      ascenderOffset: 0,
      glyphs: {},
      kerningPairs: [],
      ranges: [],
      regenerateBitmap: false,
      canGenerateBitmap: true,
      maintainGms1Font: false,
      parent: {},
      resourceVersion: "1.0",
      name: "",
      tags: [],
      resourceType: "GMFont",
    }
    
    static load = function(yy_filename/*:string*/) {
        var json = file_text_orc(yy_filename);
        
        data = json_parse(json);
    }
    
    static save = function(yy_filename/*:string*/) {
        file_text_owc(yy_filename, json_beautify(json_stringify(data)));
    }
    
    static update = function(project/*:Project*/, bmfont/*:BMFont*/) {
        var glyphs = data.glyphs;
        var height = glyphs[$ variable_struct_get_names(glyphs)[0]].h;
        
        data.ascenderOffset = bmfont.size - bmfont.base;
        
        data.glyphs = {};
        
        for (var i = 0, i_size = array_length(bmfont.chars); i < i_size; i++) {
            var char = bmfont.chars[i];
            data.glyphs[$ string(char.id)] = {
                x : char.x - project.data.border.left,
                y : char.y + bmfont.padding.top - project.data.border.top,
                w : char.width + project.data.border.left + project.data.border.right,
                h : height + project.data.border.top + project.data.border.bottom,
                // h : char.height + project.data.border.top + project.data.border.bottom,
                character : char.id,
                shift : char.xadvance + project.data.border.left + project.data.border.right,
                offset : char.xoffset
            };
        }
        
        data.kerningPairs = [];
    
        for (var i = 0, i_size = array_length(bmfont.kernings); i < i_size; i++) {
            var kerning = bmfont.kernings[i];
            array_push(data.kerningPairs, { first : kerning.first, second : kerning.second, amount : kerning.amount });
        }
    }
    
    // var yoffset = (fnt.size - fnt.base) / 2;
    
    // hinting = 0;
    // glyphOperations = 0;
    // interpreter = 0;
    // pointRounding = 0;
    // fontName = fnt.face;
    // styleName = fnt.bold ? "Bold" : (fnt.italic ? "Italic" : "Regular");
    // size = fnt.size;
    // bold = fnt.bold;
    // italic = fnt.italic;
    // charset = 1;
    // AntiAlias = 1;
    // first = 0;
    // last = 0;
    // sampleText = "abcdef ABCDEF\n0123456789 .,<>\"'&!?\nthe quick brown fox jumps over the lazy dog\nTHE QUICK BROWN FOX JUMPS OVER THE LAZY DOG\nDefault character: ▯ (9647)";
    // includeTTF = bool(false);
    // TTFName = "";
    // textureGroupId = {
    //     name: "Default",
    //     path: "texturegroups/Default"
    // }
    // ascenderOffset = 0;
    
    // glyphs = {};
    // ranges = [];
    // var range = { lower : 0, upper : 0 };
    
    // for (var i = 0, i_size = array_length(fnt.chars); i < i_size; i++) {
    //     var char = fnt.chars[i];
    //     glyphs[$ string(char.id)] = {
    //         x : char.x,
    //         y : char.y + fnt.padding.top,
    //         w : char.width,
    //         h : char.height - fnt.padding.top - fnt.padding.bottom + 2,
    //         character : char.id,
    //         shift : char.xadvance,
    //         offset : char.xoffset
    //     };
        
    //     if (char.id != range.upper) {
    //         if (i != 0) {
    //             range.upper -= 1;
    //             array_push(ranges, range);
    //         }
            
    //         range = { lower : char.id, upper : 0 };
    //     }
        
    //     range.upper = char.id + 1;
    // }
    
    // kerningPairs = [];
    
    // for (var i = 0, i_size = array_length(fnt.kernings); i < i_size; i++) {
    //     var kerning = fnt.kernings[i];
    //     array_push(kerningPairs, { first : kerning.first, second : kerning.second, amount : kerning.amount });
    // }
    
    // regenerateBitmap =  bool(false);
    // canGenerateBitmap = bool(true);
    // maintainGms1Font = bool(false);
    // parent =  {
    //     name : "Fonts",
    //     path : "folders/Fonts.yy",
    // };
    // resourceVersion = "1.0";
    // name = fnt.name;
    // tags = [];
    // resourceType = "GMFont";
    
    // show_debug_message(json_stringify(self));
}