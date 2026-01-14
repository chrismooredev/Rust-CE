
#[allow(improper_ctypes)]
extern "C" {
    pub fn os_ClrLCD();
    pub fn os_HomeUp();
    pub fn os_DrawStatusBar();
    pub fn os_PutStrFull(str: *const [u8]);
    pub fn os_GetCSC() -> i8;
    pub fn sprintf(
        buffer: *mut u8,
        format: *const u8,
        args: ...
    ) -> i32;
}

pub const DEBUG: bool = true;

pub mod debug {
    pub const DBG_OUT: *mut u8 = 0xFB0000 as *mut u8;
    // pub const DBG_ERR: *mut u8 = 0xFC0000 as *mut u8;

    pub fn clear_console() {
        if !super::DEBUG { return; }

        const CLEAR_CONSOLE_FLAG: *mut u8 = 0xFD0000 as *mut u8;
        unsafe {
            *CLEAR_CONSOLE_FLAG = 1;
        }
    }
}

// A Writer that emits to the debug console of CE-Emu
// pub struct DebugWriter;

// impl core::fmt::Write for DebugWriter {
//     fn write_str(&mut self, s: &str) -> core::fmt::Result {
//         if !DEBUG { return Ok(()); }

//         let bytes = s.as_bytes();
//         unsafe {
//             sprintf(debug::DBG_OUT, b"%.*s\0".as_ptr(), bytes.len(), bytes.as_ptr());
//         }
//         Ok(())
//     }
// }



