
#[allow(improper_ctypes)]
extern "C" {
    pub fn os_ClrLCD();
    pub fn os_HomeUp();
    pub fn os_DrawStatusBar();
    pub fn os_PutStrFull(str: *const [u8]);
    pub fn os_GetCSC() -> i8;
}
