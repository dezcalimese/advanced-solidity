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
- Things can get tricky when multiple variables are inside a slot
- Ex: 
```solidity
    uint128 public C = 4;
    uint96 public D = 6;
    uint16 public E = 8;
    uint8 public F = 1;
```
  - Imagine trying to read variable E
  - It's contained in the 32 byte slot
- Yul gives us the offset for variables, aka where exactly in the slot it is
- Ex: if offset was 28, look 28 bytes to the left to find the variable
- Shift right `shr` takes the number of bits you want to shift by as an argument, not bytes 
- Solidity, Yul, and the EVM in general is only able to write in 32 byte increments
- Bitmasking & bitshifting are used to make sure that if you want to change a variable at a certain slot, you dont affect the other ones 
- You can't operate on values less than 32 bytes when dealing with storage
- Process is basically deleting value you're trying to change, shifting a new value in there and then `or`'ing them together
## Storage of Arrays and Mappings
- If an array is fixed, Solidity computes the storage slot pretty conventionally
- For dynamic arrays, Solidity takes the slot of where that array is, then takes the `keccak256` of it
  - This will give you the location
- For sequentially reading items on the array, just add the index
- In storage, Solidity tries to stack variables
- What an array does is takes the storage slot, takes the hash of that and then starts adding '0,1,2,3,4" in order to get the array
- A mapping concatenates the key with the storage slot, and as you change the key then that concatenated value changes & gives you a different storage location
- Nested mappings are just hashes of hashes
  - Starts with slow and key inside of the nested mapping
  - Take the `keccak256` of that and then concatenate it with the next key 
  - `keccak256` that, then put it into the `ssload`
- When concatenating variables, you're not restricted to using integers as the hash key; you could use an address 