use anyhow::Result;
use wasmi::{Caller, Engine, Func, Linker, Store};

fn main() -> Result<()> {
    let engine = Engine::default();
    let wasm = include_bytes!("../wasm/fibonacci.wasm");
    let module = wasmi::Module::new(&engine, &wasm[..])?;

    let mut store = Store::new(&engine, 4);
    let host_fib = Func::wrap(&mut store, |caller: Caller<'_, u64>, param: u64| {
        println!("Got {param} from WebAssembly");
        println!("My host state is: {}", caller.data());
    });

    let mut linker = <Linker<u64>>::new(&engine);
    linker.define("host", "fibonacci", host_fib)?;
    let instance = linker.instantiate(&mut store, &module)?.start(&mut store)?;
    let fib = instance.get_typed_func::<u64, u64>(&store, "fibonacci")?;

    let res = fib.call(&mut store, 40)?;
    println!("Result: {}", res);

    Ok(())
}
