use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn fib(n: u64) -> u64 {
    if n == 0 {
        return 0;
    }

    let mut a = 0;
    let mut b = 1;
    for _ in 2..=n {
        (a, b) = (b, (a + b) % (1 << 32));
    }

    b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fib() {
        assert_eq!(fib(0), 0);
        assert_eq!(fib(1), 1);
        assert_eq!(fib(5), 5);
        assert_eq!(fib(40), 102334155);
    }
}
