# Section 2 Notes

## Memory Operations
### Memory is a prerequisite
- You need memory to do the following:
  - Return values to external calls (when an external contract calls your contract)
  - Set the function arguments for external calls (when you want to set the function arguments to make an external call to another contract)
  - Get values from external calls (when you want to get those values back)
  - Revert with an error string
  - Log messages
  - Create other smart contracts
  - Use the `keccak256` hash function
### Overview
- Equivalent to the heap in other languages
  - But there is no garbage collector or `free`
  - Solidity memory is laid out in 32 byte sequences
  - Adjustible by byte rather than in increments of 32
- Only four instructions: `mload`, `mstore`, `mstore8`, `msize`
- In pure Yul programs, memory is easy to use. (just an array)
  - But in mixed Solidity/Yul programs, Solidity expects memory to be used in a specific manner
- **Important** You are charged gas for each memory access, _and_ for how far into the memory array you accessed
  - Memory is relatively cheap compared to storage, but the further out you access memory on that array, the more you be charged gas
  - Starts to become quadratic
  - This is to disincentivize users from abusing the memory in Ethereum nodes
- Ex: `mload (0xffffffffffffffff)` will run out of gas
  - Using a hash function to `mstore` like storage does is a bad idea
- `mstore(p, v)` stores value `v` in slot `p` (just like `sload`)
- `mload(p)` retrieves 32 bytes from slot `p` `[p..0x20]`
- `mstore(p, v)` and `mload(p)` can only read values in 32 byte increments 
- `mstore8(p, v)` like `mstore` but for 1 byte
- `msize()` largest accessed memory index in that transaction
![Memory Visual 1](images/memory-visual1.png)
- This would behave the same way you would expect it to in storage
  - If you `mstore` into slot 0 (32 bytes into `ff`), then you're going to see `ff` stored inside of each of the byte slots 
  - Byte is the smallest unit of memory, so doing `mstore(0x01)` won't shift you forward 32 bytes; it's only going to shift you forward 1 byte
![Memory Visual 2](images/memory-visual2.png)
- In this example the 00 slot is not written to, but it still writes 32 bytes and brings you up to the 0x20 (32 in decimal)
- In the first visual example, 0x20 would not be written to because 0x00 is equivalent to zero and 0x19 is equivalent to 31
![Memory Visual 3](images/memory-visual3.png)
- In this example, decimal 7 is the same as hexadecimal 7
- In this case, you are still going to be implicitly having a bunch of zeroes in front of the 7
  - Still write to slots leading up to the 32nd byte and 7 will be stored in the slot at the end
![Memory Visual 4](images/memory-visual4.png)
- If you used `mstore8` instead, then only the 0th slot will be written to and the 7 would be put into slot 0
  - The other bytes in front of it would be untouched
## How Solidity Uses Memory
- Solidity allocates slots `[0x00-0x20]`, `[0x20-0x40]` as "scratch space"
  - Can just write values here and expect them to be emphemeral
  - Can also mean a previous operation left a value here
  - If you're writing in 32 byte increments it's going to overwrite whatever slot you're writing into
- Solidity reserves slot `[0x40]` as the "free memory pointer"
  - If you want to write something new to memory, this is where you'd start writing it to
  - Will never decrement as the transcation progresses
- Solidity keeps slot `[0x60]` empty
- The action begins in slot `[0x80-]`
  - Writing to structs, arrays etc will begin here
- Solidity uses memory for
  - `abi.encode` and `abi.encodePacked` 
  - Structs and arrays (but you explicitly need the `memory` keyword)
  - When structs and arrays are declared `memory` in function arguments
    - Memory allocated when it's set to be the modifier for the function argument
  - Because objects in memory are laid out end to end according to where free memory pointer is pointing
    - After a new object is written, the free memory pointer is set to point ahead of that 
    - Memory arrays have no `push` like storage
- In Yul
  - _The variable itself_ is where it begins in memory 
  - To access a dynamic array, you have to add 32 bytes or 0x20 to skip the length
## Dangers of Memory Misuse
- If you don't respect Solidity's memory layout and free memory pointer, you can get some serious bugs
- The EVM memory does not try to pack datatypes smaller than 32 bytes
- If you load from storage to memory, it wlll be unpacked
## Return, Require, Tuples, and Keccak256
## Logs and Events