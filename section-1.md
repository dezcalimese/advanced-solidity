# Section 1 Notes

## Types
- Yul has only one type: the 32-bit word (256 bits)
- Yul does not use semicolons
- When you're assigning a variable, it requires a `:=` sign as well as being in an `assembly` block
- Variable naming is able to reference things in `assembly` block scope
- A string is not naturally a bytes32
- Bytes32 is the only type that's used in Yul, but Solidity is enforcing an interpretation when you make an address, a bytes32, an integer, etc
- A boolean in Solidity is 32 bytes where the last bit is 1
## Basic Operations
- Yul has a for loop and an if statement
- Yul doesn't have a `!` operator, but `iszero` is pretty similar to it
- Because Yul only has 32-byte words as a type, it doesn't have booleans
  - Can use `if` statements to prove if something is true or false
- "Falsy" values in Yul are where all the 32 bytes are 0
- Using `iszero` is the safest way to use negation in Yul
  - Avoid using the `not` word when using negation
  - If you take `not` of something that isn't zero, it is going to essentially flip all of the bits & you will get a nonzero value back
- If statements don't have `else`, so to check out other scenarios you have to explicitly check them
## Storage Slots
- Key opcodes we need to know for storage are SLOAD and SSTORE
- `.slot` is the actual memory location of where a variable is
  - Ex. `ret := x.slot` will not return the value, it will return where it is
  - To show the value, you actually need to run `ret := sload(x.slot)
- `.slot` is determined sequentially
- You can write to an arbitrary location, and if you were to write to a location e.g. where the owner of the contract is stored and someone changes it to be a different owner, there would be a serious security issue
- `.sstore` allows you to store into a given slot a new value
- `(variable name).slot` is determined at compile time and never changes
- If two variables are in the same slot, e.g. two `uint128`'s, to load each value you can return `bytes32` instead of `uint256` 
<<<<<<< HEAD
## Storage Offsets and Bitshifting 
- Shift right `shr` takes the number of bits you want to shift by as an argument, not bytes 
- 
## Storage of Arrays and Mappings
=======
=======
>>>>>>> bd144501499b06e75faabf8f29369d13de85cc20
## Storage Offsets and Bitshifting
## Storage of Arrays and Mappings
