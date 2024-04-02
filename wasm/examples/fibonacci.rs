#![no_main]
#![allow(non_snake_case)]

#[no_mangle]
pub extern "C" fn fibonacci(n: u64) -> u64 {
    if n == 0 {
        return 0;
    }

    let mut a = 0;
    let mut b = 1;
    for _ in 2..=n {
        (a, b) = (b, a + b);
    }

    b
}
