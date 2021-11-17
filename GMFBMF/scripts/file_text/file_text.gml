// ORC - Open, Read, Close
function file_text_orc(filename/*:string*/)/*->string*/ {
    var file = file_text_open_read(filename);
    var result = "";
    
    while(!file_text_eof(file)) {
        if (result != "") {
            result += "\r\n";
        }
        
        result += file_text_read_string(file);
        file_text_readln(file);
    }
    
    file_text_close(file);
    
    return result;
}

// OWC - Open, Write, Close
function file_text_owc(filename/*:string*/, value/*:string*/) {
    var file = file_text_open_write(filename);
    file_text_write_string(file, value);
    file_text_close(file);
}