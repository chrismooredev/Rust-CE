#![no_std]
#![no_main]

// extern crate core;

// use core::fmt::Write;

mod ffi;

#[no_mangle]
unsafe fn rust_main() -> i8 {
    ffi::os_ClrLCD();
    ffi::os_HomeUp();
    ffi::os_DrawStatusBar();
    ffi::os_PutStrFull(b"Hello from Rust!\x00");

    // let _ = writeln!(ffi::DebugWriter, "Hello from DebugWriter!");

    while ffi::os_GetCSC() == 0 { }

    return 0;
}

#[panic_handler]
fn panic(_panic: &core::panic::PanicInfo<'_>) -> ! {
    loop {}
}

