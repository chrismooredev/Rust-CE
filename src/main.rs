#![no_std]
#![no_main]

#[no_mangle]
unsafe fn rust_main() -> i8 {
    os_ClrLCD();
    os_HomeUp();
    os_DrawStatusBar();
    os_PutStrFull(b"Hello from Rust!\x00");
    while os_GetCSC() == 0 {}

    return 0;
}

#[panic_handler]
fn panic(_panic: &core::panic::PanicInfo<'_>) -> ! {
    loop {}
}

#[allow(improper_ctypes)]
extern "C" {
    fn os_ClrLCD();
    fn os_HomeUp();
    fn os_DrawStatusBar();
    fn os_PutStrFull(str: *const [u8]);
    fn os_GetCSC() -> i8;
}
