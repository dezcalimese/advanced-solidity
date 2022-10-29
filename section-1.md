# Section 1 Notes

## Types
- Yul has only one type: the 32-bit word (256 bits)
- Yul does not use semicolons
- When you're assigning a variable, it requires a `:=` sign as well as being in an `assembly` block
- Variable naming is able to reference things in `assembly` block scope
- A string is not naturally a bytes32
- Bytes32 is the only type that's used un Yul, but Solidity is enforcing an interpretation when you make an address, a bytes32, an integer, etc
- A boolean in Solidity is 32 bytes where the last bit is 1
## Basic Operations
## Storage Slots
## Storage Offsets and Bitshifting
## Storage of Arrays and Mappings