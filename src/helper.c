
#include <stdint.h>

// file to implement any helper routines in C
// not strictly needed, but could be helpful to reduce extraneous FFI declarations on the rust-side

// this could be a char, but using stdint.h in CI helps test header resolution
int8_t rust_main(void);

int main(void) {
    // Rust doesn't have a concept of a 24-bit integer.
    // So cast the returned 8-bit integer to 24-bit here.
    return rust_main();
}
