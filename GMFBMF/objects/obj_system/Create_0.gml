project = new Project(self);

enum ExportState {
    None, Sizing, GenerateYY, Checking
}

exportState = ExportState.None;
exportStateTimeout = room_speed;

loadProcess = function() {
    exportState = ExportState.Sizing;
    alarm[0] = exportStateTimeout;
}