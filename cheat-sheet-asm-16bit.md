Author: josemanuelpr@ufps.edu.co
I did this watching a lot of videos and using info from a lot of websites, so if i get something wrong or you think something has to be adjusted, feel free to email me. 

Also, if some markdown formatting doesn't work, it's because i'm using Obsidian in order to write this, perhaps i forget to fix the linking (which in obsidian is with [[]]).

# Table of contents

[[#Assembly 16-bit]]
- [[#How can i run, debug or test code for asm-16 bits?|How can i run, debug or test code for asm-16 bits?]]
	- [[#How can i run, debug or test code for asm-16 bits?#VM with windows xp|VM with windows xp]]
	- [[#How can i run, debug or test code for asm-16 bits?#Easier way: extension for vscode|Easier way: extension for vscode]]
- [[#Registers|Registers]]
	- [[#Registers#Registers (16-bit) for DOS Programming|Registers (16-bit) for DOS Programming]]
	- [[#Registers#Sub-registers (8-bit parts):|Sub-registers (8-bit parts):]]
- [[#Memory|Memory]]
	- [[#Memory#Addressing|Addressing]]
	- [[#Memory#Overlapping|Overlapping]]
- [[#Basic structure of a 16-bit assembly program|Basic structure of a 16-bit assembly program]]
	- [[#Basic structure of a 16-bit assembly program#Comments|Comments]]
	- [[#Basic structure of a 16-bit assembly program#Basic instructions, headers, and information for the file|Basic instructions, headers, and information for the file]]
		- [[#Basic instructions, headers, and information for the file#Table of memory models|Table of memory models]]
	- [[#Basic structure of a 16-bit assembly program#Segments|Segments]]
		- [[#Segments#.data|.data]]
		- [[#Segments#.code|.code]]
		- [[#Segments#page|page]]
		- [[#Segments#.386, .i386, etc|.386, .i386, etc]]
	- [[#Basic structure of a 16-bit assembly program#Procedures, labels, and more about segments|Procedures, labels, and more about segments]]
	- [[#Basic structure of a 16-bit assembly program#Instruction set|Instruction set]]
		- [[#Instruction set#mov|mov]]
		- [[#Instruction set#lea|lea]]
		- [[#Instruction set#Arithmetic add/sub|Arithmetic add/sub]]
		- [[#Instruction set#Arithmetic mul/div|Arithmetic mul/div]]
		- [[#Instruction set#Register affected by arithmetic operations|Register affected by arithmetic operations]]
			- [[#Register affected by arithmetic operations#FLAG register representations|FLAG register representations]]
		- [[#Instruction set#int (interrupt)|int (interrupt)]]
			- [[#int (interrupt)#int 21h|int 21h]]
			- [[#int (interrupt)#int 10h|int 10h]]
[[#Examples]]
- [[#Basic operations and handling memory|Basic operations and handling memory]]
	- [[#Basic operations and handling memory#Sum 3 numbers|Sum 3 numbers]]


# Assembly 16-bit
16-bit assembly language is _a family of low-level programming languages_ that are used to produce object code for quite old processors (80s, or even 90s).

A really cool guide for pretty much everything, although in x86, but everything pretty much can be followed along: https://www.cs.virginia.edu/~evans/cs216/guides/x86.html

The full instruction set is **STUPIDLY** large and complex (Intel's x86 instruction set manuals comprise **over 2900 pages**). For example, there is a 16-bit subset of the x86 instruction set. Using the 16-bit programming model can be quite complex. It has a segmented memory model, more restrictions on register usage, and so on.

We will limit our attention to the aspects of 16-bit asm programming, and delve into the instruction set only in enough detail to get a basic feel for coding in this language and survive the semester.  

**Quick note:** 16-bit assembly works in **Real mode**, meaning we have complete access to the memory and instructions. In modern assembly, the instruction set is defined by an API or by Syscalls. In Windows is used the win32API, whereas in Linux we make syscalls to communicate with the instructions. That thing is called protected mode.

Also, the syntax we'll follow is Intel's. There is also AT&T syntax and some more standards, but these two are the most common. AT&T is in fact more used in Unix systems, but we are going out of topic, let's go back to the assembly part.

## How can i run, debug or test code for asm-16 bits?
Mostly two ways, i would recommend setting up the two:
### VM with windows xp
You can create a windows xp virtual machine in any virtualization tool, call it VMware, Virtualbox, virt-manager, etc. Just open it up, launch a terminal/cmd inside that vm, and write "debug" in order to test for all of this. 

For UFPS: https://drive.google.com/drive/u/1/folders/1txASYlxvF2hn-C_yAXsCdJgkGbWZaPCZ and follow those steps. Search how to share folders between your machine and the virtualized one, put the file with the code, the MASM.exe and LINK.exe.

### Easier way: extension for vscode
Install vscode, and go to the extensions tab. Download this one: MASM/TASM by clcxsrolau https://marketplace.visualstudio.com/items/?itemName=xsro.masm-tasm, reload vscode, and in the file that has the code for assembly (ending with the extension file .asm), use the second click and there will be an option that says "Run ASM code". With this, a tab/windows will pop at the right with a DOSbox emulator and assemble, link and run the code.

**Note**: with the extension for vscode, you will miss the steps of assembling, linking and executing the code with this step,  and also using the debug option that the Virtual Machine offers. 

## Registers
These are sections that hold small data to be used by the ALU and the CPU in general. Depending on the architecture and CPU, there are multiple of these registers to keep in mind, but overall the most used and common are the following:

### Registers (16-bit) for DOS Programming
I'd recommend giving this table a quick look before you skip and go directly to the instruction set or examples. This is just a sort of wiki to remember what each register does.

| Register  | Category        | Bits | Description                                                                                                                                                       |
| --------- | --------------- | ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **AX**    | General Purpose | 16   | Primary accumulator. Used for arithmetic and I/O operations. Here are usually allocated the values to execute interruptions and more stuff.                       |
| **BX**    | General Purpose | 16   | Base register. Used for memory addressing (e.g., `[BX + SI]`).                                                                                                    |
| **CX**    | General Purpose | 16   | Counter. Used in loops (`LOOP`) and string operations, or anything that has to do with the `CMP` (compare) instruction                                            |
| **DX**    | General Purpose | 16   | Data/offset. Used for port I/O and high-value number operations.                                                                                                  |
| **SI**    | Index           | 16   | Source Index. Points to source data in string operations                                                                                                          |
| **DI**    | Index           | 16   | Destination Index. Points to destination in string operations                                                                                                     |
| **SP**    | Pointer         | 16   | Stack Pointer. **Always** tracks the "top" of the stack                                                                                                           |
| **BP**    | Pointer         | 16   | Base Pointer. Used to denote a specific part of the stack, usually to access stack parameters or remembering where the stack was pointing before manipulating it. |
| **CS**    | Segment         | 16   | Code Segment. Defines the code memory segment                                                                                                                     |
| **DS**    | Segment         | 16   | Data Segment. Base segment for data variables                                                                                                                     |
| **ES**    | Segment         | 16   | Extra Segment. Additional segment for string operations                                                                                                           |
| **SS**    | Segment         | 16   | Stack Segment. Defines the stack memory area                                                                                                                      |
| **IP**    | Control         | 16   | Instruction Pointer. Points to next instruction to execute                                                                                                        |
| **FLAGS** | Control         | 16   | Status register. Contains flags like Carry, Zero, and Sign                                                                                                        |

### Sub-registers (8-bit parts):
The main registers, which are the AX, BX, DX and CX can be splitted in two parts: a High (h) part and a Low (l) part, this is done, because we can only store **one byte** and keep the other part free for other tasks. Why do we use this? To optimize resources, remember that this assembly code is done for really old machines and they didn't have the same resources that the machine you are using to see this.

Obviously, if you want to put data in these registers, the data **must** be of the same size, meaning 1 byte or 8 bits.

| Register | High Byte | Low Byte |
|----------|-----------|----------|
| AX       | AH        | AL       |
| BX       | BH        | BL       |
| CX       | CH        | CL       |
| DX       | DH        | DL       |

## Memory

The RAM is the memory where all the loaded data will be saved and then accessed for our programs. In 16-bit assembly, memory is managed through segmentation due to hardware limitations of early processors like the Intel 8086.

Back in time, for old processors, the size of registers were of 16 bits, just as we saw in the table of registers. A 16 bit register can only handle 2^16 = 65536 addresses (which is 64KiB).

The thing is, the address bus of those processors was 20 bits wide., which is the same as saying 2^20 = 1,048,576 bytes.

A register by itself can't possibly access more than a million of addresses with it roughly 65k capacity, then the process of knowing *where really is the data inside memory* happens through a **segmentation**. 

In order to generate an address of 20 bits, it is required to have two 16 bits values. One is the segment, and the other is the offset. 

A good analogy before going deeper in the concepts is with a book. The book has 65,536 chapters (2^16 segments), each taking 16 bytes. Each page contains 65,536 items (2^16 offsets), where each item is 1 byte long (8 characters per item). Whenever you want to check something, first you allocate the page (segment), let's suppose the page is the 0x1000 (4096 in decimal), then the item you are looking for is the 0x0040 (64 in decimal).

### Addressing
Now, a question that can be asked for the book example is, What is the actual "in-page" address of the item? we already know that the "page" (segment) is the number 0x1000, and the "item in the page" (offset) is 0x0040, then instead of saying the two addresses (that the registers understand), we translate it to an address fittable in 20 bits or 5 hex digits (so it is understandable for the memory bus).

The way of telling this address is with the following formula:
```
physical address = (segment * 16) + offset
```
Why is this formula like this? First, "segment" and "offset" are 16 bits values, they can look like this: `0x0000 to 0xFFFF`, and multiplying for 16 is equivalent to move four bits to the left. For example, `0x1234 times 16 is 0x12340`. 

Then, for the book, the real (physical) address of the item we are looking for is: `address = (0x1000 * 16) + 0x0040`, or `address = 0x10040`. 

### Overlapping
The real address of the item in the book, `0x10040`, is correct, but let's say that now you want to access that item to see it's content. You could perfectly use the same two 16 bits instructions, which are 0x1000 and 0x0040, but what if a friend that wanted to check that item, accessed it from other route? What you are saying with the two 16 bits values is: "Go to segment x and do an offset of y", or "go to chapter x and move y items".

Then, 0x1000 and 0x0040 might not be the only way to access the item. Your friend probably wants to take the route of going to the chapter (segment) 0x0FFF and the page (offset) 0x0050. Then, when he proceeds to execute those instructions in order to reach the item, he will end at:

`friend_accessed_address = (0x0FFF * 16) + 0x0050`
`friend_accessed_address = 0xFFF0 + 0x0050`
`friend_accessed_address = 0x10040`

Notice that he ended up in the same item, even when he didn't took the same chapter and page (segment and offset). This means that both options point to **the same physical address**, and that is overlapping.

Why does this happen? Remember how the chapters in the book work: the chapter 0x0100 starts at page 0x01000, and the chapter 0x0101 starts at page 0x01010 (16 pages of difference). This means that you can access the same address from similar memory regions or segments, through different segment:offset pairs. 

Programs can **reuse** memory regions for different purposes, and this can indeed lead to cases where data is overwritten. 

## Basic structure of a 16-bit assembly program
### Comments
Let's begin with a very easy concept. Keep a good practice to comment the lines of code you write since we are in a low level programming language. To do a comment, use the semicolon **;**.

E.g: 

``` Assembly
; This is a comment, everything that is to the right of the semicolon will be ignored, is just like any other language with // or #.
; mov ax, bx is ignored, because is to the right of a semicolon.
; It's not necessary to write a semicolon at the end of each line, but is generally a good idea to keep them in order to document the code.
```

### Basic instructions, headers, and information for the file
Some people call this boilerplate, some others fillers, but in general every programming language has these sort of stuff.

Every 16-bit assembly language has the following:

```Assembly
.model small
.stack 100h
```

What does these two lines mean, is:

* ".model" defines that the file has some sort of scope and limits related to the **memory**. Depending on the argument that it has (in this case, "small") will define characteristics in the overall program. The arguments that it can have are: "tiny", "small", "medium" and "large". For the great majority of the stuff we'll do, small will be ok.
* ".stack" defines the property of the stack of memory, and the argument is a hex value that indicates the amount of bytes that it will have. For now, 100h bytes of stack (256 bytes) is the standard and will work for simple examples.

Now, diving more about the ".model" directive, the aspects that affect the memory are defined in the next table:
Also, the procedures defaulting to "far" is covered later in the [[#Procedures, labels, and more about segments]] part.
#### Table of memory models

| Model   | Code Segments    | Data Segments    | Use Case                                                                           |
| ------- | ---------------- | ---------------- | ---------------------------------------------------------------------------------- |
| Tiny    | 1 (≤64KB)        | 1 (same as code) | All code + data + stack in only one segment. Used for .COM files (max 64KB total). |
| Small   | 1 (≤64KB)        | 1 (<=64KB)       | Simple programs with moderate code and data. Default for most DOS apps.            |
| Medium  | Multiple (<=1MB) | 1 (<=64KB)       | Large code (e.g, editors), and small data. Procedures default to "far".            |
| Compact | 1 (<=64KB)       | Multiple (<=1MB) | Small code, large data (e.g., databases). Data pointers default to "far".          |
| Large   | Multiple         | Multiple         | Code and data both exceed 64KB. Pointers are "far" by default.                     |
| Huge    | Multiple         | Multiple         | Like "Large," but allows single data items (e.g., arrays) >64KB.                   |
### Segments
We already saw segments that are for basic definitions in the program and file, now these are the two segments that will be used almost always:

```Assembly
.data
	;stuff

.code
	;stuff
```

These two represent:
#### .data
 ".data" is where the data required for the program to work is save. Basically, you can create labels inside it with definitions of sizes in memory, and hardcoded data in it. For example:

```Assembly
.data
    int_var    dw 1000         ; 16-bit integer
    bool_true  db 1            ; Boolean (1 = true)
    bool_false db 0            ; Boolean (0 = false)
    message    db 'Hello!$'    ; String ($ represents the end of the line when you want to print it to the terminal (only in DOS))
    array      db 1,2,3,4,5    ; 5-element byte array (are contiguous in memory)
    pi         equ 355/113     ; Constant (no memory allocated)
```

#### .code
Here is everything related to the code, and the program itself. The instructions that are used are under this segment, and they are denoted by labels and procedures.

The overall asm program will look like this:

```Assembly
.code
main proc                ; More of all of this later, just focus on seeing that .code is where all of this is being defined.
    mov ax, @data
    mov ds, ax           ; Initialize data segment
    
    ; Your code here
    
    mov ax, 4C00h        ; Exit to DOS
    int 21h
main endp
end main
```

Also, there are some more "headers" to keep in mind, that are not mandatory, but should keep in mind:
#### page
In old assemblers (in this case, assembly for... DOS) the way of documenting things was with paper, literally printing the code to save it in folders and so. With this, the page directive stands for the size of the paper that the code will be printed in. Meaning, a directive like this:

```Assembly
page (lines) (length_of_lines)
```
means that the "page" has a size of (lines) lines and each line can have a maximum of (length_of_lines) characters. By default, the dimensions of the page are 50 x 80, and the maximum size is 255 and 132 respectively.
#### .386, .i386, etc
If we are in the "debug" of windows xp, or in DOS, we don't need to use this, since these lines indicate to MASM or TASM that we want to generate this assembly code to a specific machine. By default, without writing these lines, the code will be generated for 16 bits, but if specified in the top of the file, the code will be generated for specific processors that have some sort of different instructions compared to the 16 bits ones. Example: the top of the file has .i386, then the assembly generated is focused for processors like Intel 80386 or superior that have a sort of 32 bits instructions.
```Assembly
.i386      ; top of the file
; rest of the code
```
If you are **only writing for 16 bits, you don't put this directive**.

### Procedures, labels, and more about segments
In any mainstream programming language, there are functions/methods/procedures. In assembly, the procedures are defined as follows:

```Assembly
(name_of_procedure) proc (call_modifier)
; code
(name_of_procedure) endp           ; will end the procedure segment
```

Where `call_modifier` depends of the memory model defined in the program (see [[#Table of memory models]]). For tiny and small modes, the modifier is `near`, whereas with any of the greater memory models, the modifier must be `far` due to the memory conditions of the model.

We can also specify a label to jump or go, which looks like this:
```Assembly
(label_name):
	; code
```
Labels are symbolic names for memory addresses or code locations. They act as bookmarks, so we don't have to hardcode the address in order to access data or code.

We already saw data labels in [[#.data]], then the concept should be already clear with this: you specify a name, then the data type, and some values (`message db 'Hello!$'` where `message` is the label).

And in the code, they look like this:
```Assembly
main proc near
start:
	; code for the start
printstring:
	; code for printing
exit:
	; exit setup
main endp
```
Now, let's see the instructions (or lines of code) that are used in Assembly.

### Instruction set
#### mov

```Assembly
mov destination, source
```

Copies the second operand (source operand) to the first operand (destination operand). The source operand can be an immediate value, general-purpose register, segment register, or memory location; the destination register can be a general-purpose register, segment register, or memory location. **Both operands must be the same size**.

```Assembly
; ======================
; MOVING VALUES TO REGISTERS
; ======================
mov ax, 1234h        ; AX = 0x1234 (hex)
mov bl, 100          ; BL = 100 (decimal, it's in the lower part (1 byte))
mov bh, 'A'          ; BH = ASCII 'A' (0x41 in hex)
mov cx, 0FFFFh       ; CX = 65535 (max 16-bit value)
mov bl, ah           ; BL = AH (copy high byte of AX to BL)
mov [si], dx         ; Store DX value at memory address in SI
```

Special cases:

```Assembly
mov ds, ah           ; (invalid - cannot load segment register from 8-bit register)  
mov ds, 1234h        ; (invalid - must use general register, ds is not one of those) 
mov 10h, ax          ; (invalid, why would you want to move a register to... a number? this number, 10h, it's not representing anything, it's just a plain number)
```

#### lea
```Assembly
lea register, a_region_in_memory
```

Load Effective Address calculates the memory address of an operand but doesn't access the data at that address, creating a pointer/reference to data **instead of using the data itself**, like using &var in C.

```Assembly
lea dx, message  ; dx = offset address of message (Same as "mov dx, offset message", but again more on that later)
```
For example, if `message` is at memory address 0100h, then:  
`lea DX, message` will remain in dx = 0100h

```Assembly
lea ax, [bx + si + 10]     ; AX = BX + SI + 10 (address calculation)
lea dx, [string_in_data]   ; where string_in_data is something like var db 'Hi'
lea si, [di + 2]           ; SI points to 2 bytes past DI, for array indexing

lea ax, 5          ; ERROR: 5 isn't a memory address
```

**Quick differentiation between mov and lea**
`mov ax, [bx]` _Copies the value_ stored at address bx into ax, whereas:
`lea ax, [bx]` _Copies the address_ bx into ax (basically ax = bx)

**Why would i want to use this?** To load the memory addresses of a variable that's declared inside .data segment into the DX (used for this purpose mostly), or do some calculations in order to find a region in memory to load into a register. A good thing to keep in mind is that "lea" works with addresses, not values.

#### Arithmetic add/sub
```Assembly
add destination, source
sub destination, source
```
What this does is a sum or subtraction to these two operands, resulting in destination = destination +/- source, hence the result is saved inside "destination". 
```Assembly
add ax, bx     ; AX = AX + BX
sub cl, 10     ; CL = CL - 10
add [di], al   ; int the region of memory that is at address di, sums the value of al
```

#### Arithmetic mul/div
A quick reference table:

| Operation         | Instruction | Operand Size | Input             | Output                                  |
| ----------------- | ----------- | ------------ | ----------------- | --------------------------------------- |
| Unsigned Multiply | `mul`       | 8-bit        | `AL * source`     | `AX`                                    |
| Unsigned Multiply | `mul`       | 16-bit       | `AX * source`     | `DX:AX` (high 16 bits in DX, low in AX) |
| Signed Multiply   | `imul`      | 8-bit        | `AL * source`     | `AX`                                    |
| Signed Multiply   | `imul`      | 16-bit       | `AX * source`     | `DX:AX` (high 16 bits in DX, low in AX) |
| Unsigned Divide   | `div`       | 8-bit        | `AX / divisor`    | `AL` (quotient), `AH` (remainder)       |
| Unsigned Divide   | `div`       | 16-bit       | `DX:AX / divisor` | `AX` (quotient), `DX` (remainder)       |
| Signed Divide     | `idiv`      | 8-bit        | `AX / divisor`    | `AL` (quotient), `AH` (remainder)       |
| Signed Divide     | `idiv`      | 16-bit       | `DX:AX / divisor` | `AX` (quotient), `DX` (remainder)       |
In assembly, the multiplication and division can be done with signed or unsigned values, which means that the operation can be done with signed values (can be positive or negative) or unsigned (only positive) and the output can be different in the big majority of cases.

For example, `mul` and `div`indicate unsigned operations. Depending of the size of the operation (can be saved in 8 bits or 16 bits) the behavior and output will differ.

In order to execute this instruction, it must be passed as operand a single value or either 8 or 16 bits, in this way:
`(operation) (operand)`, like `mul 0x0A` or `idiv cx`

**Examples**
```Assembly
mov al, -5     ; AL = -5 (signed)
mov bl, 3      ; BL = 3
imul bl        ; AX = (-5) * 3 = -15 (0xFFF1 in AX)
```
And you would say, why is the result FFF1 (65521 in decimal)? Because of the signed operation, and if you remember how does these numbers work, we can just apply 2's compliment (flip all ones and zeros of the binary form, then add 1) the result will be the answer (which is 15) and we just have to put the minus sign in front (-15).

With unsigned division:
```Assembly
mov dx, 0x0000     ; High word of dividend (0)
mov ax, 0x010E     ; Low word of dividend (270)
mov bx, 0x0003     ; BX = 3 (divisor)
div bx             ; AX = 90 (quotient), DX = 0 (remainder)
```


#### Register affected by arithmetic operations
In the [[#Registers (16-bit) for DOS Programming]], the FLAGS register was mentioned, here we'll start talking about the effects and purpose of it.

Since we already saw how to do basic arithmetic operations, several questions may arise, for example the case where an operation causes overflow, or is zero, perhaps if we want to know the rest of a division instead of it's integer division (or truncation). With this quick tl:dr table everything may cover some sense:
##### FLAG register representations

| Bit    | Name       | Description                                                                           |
| ------ | ---------- | ------------------------------------------------------------------------------------- |
| **0**  | **CF**     | Carry Flag (Unsigned overflow/borrow).                                                |
| **1**  | _Reserved_ | Always 1 in 8086.                                                                     |
| **2**  | **PF**     | Parity Flag (Even number of set bits in result).                                      |
| **3**  | _Reserved_ | Always 0 in 8086.                                                                     |
| **4**  | **AF**     | Auxiliary Carry Flag (binary coded decimal carry between nibbles).                    |
| **5**  | _Reserved_ | Always 0 in 8086.                                                                     |
| **6**  | **ZF**     | Zero Flag (Result is zero).                                                           |
| **7**  | **SF**     | Sign Flag (Result is negative in signed operations).                                  |
| **8**  | **TF**     | Trap Flag (Single-step mode for debuggers).                                           |
| **9**  | **IF**     | Interrupt Enable Flag (Enables "maskable" interrupts).                                |
| **10** | **DF**     | Direction Flag (String operations: `0`=forward, `1`=backward).                        |
| **11** | **OF**     | Overflow Flag (Signed overflow).                                                      |
| 12-15  | _Reserved_ | (ignore for 8086, the wiki says a lot of stuff we don't have to deal with right now). |
And now a quick explanation of the most relevant for our context:
- **CF** when an unsigned operation exceeds 8/16 bits like 255+1 = 0xFE + 0x01 in carry. For subtractions that "borrows" in the operation like 0 minus 1, or shift or rotations that "push" a bit out of the process 
- **PF** is a bit tricky to get, since represents if the result's least significant byte has an even number of "1" bits. This is mostly used for stuff like checking integrity of communications protocols for what i've read.
- **AF** Indicates if a carry or "borrow" occurs between bits 3 and 4 (counting from 0 to 7) during an arithmetic operation. Mostly for BCD (binary coded decimals), you can think of it like when the lower 4 bits communicate with the higher 4 bits. This is not that heavily used, mostly for legacy systems that wanted to correct operations or decimal representations.
- **ZF** represents if the result of an arithmetic operation is zero, mostly seen in comparisons and jumps (more on these later)
- **SG** The most significant bit is 1 (negative in signed operations).
- **OF** Signed arithmetic operations overflow (127 + 1 = -128 for 8 bits).

And a quick cheat table for all the flags affected in each operation:

| Instruction | Flags Affected             | To keep in mind                                               |
| ----------- | -------------------------- | ------------------------------------------------------------- |
| `ADD`/`SUB` | CF, PF, AF, ZF, SF, OF     |                                                               |
| `MUL`/`DIV` | CF, OF (for `MUL`), ZF, SF | `DIV` sets flags unpredictably on overflow.                   |
| `INC`/`DEC` | PF, AF, ZF, SF, OF         | Does not affect CF                                            |
| `AND`/`OR`  | CF=0, OF=0, PF, ZF, SF     |                                                               |
| `CMP`       | Same as `SUB`              | Doesn’t modify operands.                                      |
| `SHL`/`SHR` | CF, PF, ZF, SF, OF         | OF undefined for multi-bit shifts (more than 1 bit of shift). |
Also, there are a lot of instructions worth noting, but too direct to dive in detail, so keep in mind these:

```Assembly
CLC      ; Clear Carry Flag (CF = 0)  
STC      ; Set Carry Flag (CF = 1)  
CLD      ; Clear Direction Flag (DF = 0)  
STD      ; Set Direction Flag (DF = 1)  
STI      ; Set Interrupt Flag (IF = 1)  
CLI      ; Clear Interrupt Flag (IF = 0)
LAHF     ; Load AH from FLAGS (bits 7:0)  
SAHF     ; Store AH into FLAGS (bits 7:0)  
PUSHF    ; Push FLAGS onto the stack  
POPF     ; Pop FLAGS from the stack
```


#### int (interrupt)
Calls the BIOS, aka the instruction to the machine. Some instructions that are used by int require some work beforehand, like moving values to some registers that indicate the action that has to be performed, or perhaps moving values to the stack, etc.

```Assembly
int number_in_hex
```

With these interruptions, you can do basic stuff like printing to the terminal, reading characters or values as input of the user, cleaning the screen, etc etc etc.

So, the syntax, expanding from the above, could be something like this:

```Assembly
mov ah, function_number  ; Specify the service
...                      ; Set some parameters
int interruption_number  ; Call the interrupt
```

Now, with this in mind, let's see the basic DOS services we can use with interruptions.

##### int 21h
More about this interruption: https://en.wikipedia.org/wiki/DOS_API
This are the basic DOS services (software), commonly used for the terminal. In order to indicate the service we want from the int 21h, the order has to be inside "ah". With this table everything will be more clear:

| AH value | Purpose                                   | Parameters                                                                  | Return Values            |
| -------- | ----------------------------------------- | --------------------------------------------------------------------------- | ------------------------ |
| 01h      | Read character                            | nothing                                                                     | AL = ASCII char          |
| 02h      | Print character                           | "dl" = Character to print                                                   | nothing                  |
| 09h      | Print string                              | "ds:dx" = Address of string (ending with $)                                 | nothing                  |
| 0Ah      | Buffered input (multiple values of input) | "ds:dx" = Address of input buffer                                           | Buffer filled with input |
| 4Ch      | Exit program                              | "al" = return code (like in C, 0 usually is success and any other is error) | nothing                  |
Example: imagine that there is a message inside .data that looks like `message db 'Hello!$`
then, a code to print this message to the terminal (remembering that it HAS to end with a $) is:

```Assembly
mov ah, 09h
lea dx, message  
int 21h          ; checks the value at ah, 09h means print the message that points the dx register, then prints "hello!"
```

Now a more complex example, reading input: There needs to be a buffer (space in memory to occupy) available where the input will be saved, then inside .data has to be some sort of definition similar to:

```Assembly
.data
	buffer db 20          ; The maximum amount of data to receive INCLUDING "enter" key
	       db ?           ; a space that is reserved for the BIOS, here will be the amount of actual characters read, if the user inputs 10 characters, then here will be a value of 10
	       db 20 dup(0)   ; the buffer for input, all is zero
```

And in the code section:

```Assembly
.code
	mov ah, 0Ah         ; 0Ah is the function number for this action, input
	lea dx, buffer      ; loads the region of memory available for input (buffer)
	int 21h             ; reads input (like scanf in java or any other program)
```

##### int 10h
More about this interruption: https://es.wikipedia.org/wiki/Int_10h
Used for low-level screen control, mostly the terminal screen.
As with the int 21h, the function has to be indicated inside "ah", and the parameters may vary of position.

In the descriptions of the function numbers, "cursor" doesn't mean the mouse's cursor, but rather the position where we can type a value in the terminal screen.

| AH value | Function purpose       | Parameters                                                                                                                                                                                                                    |
| -------- | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 00h      | Set video mode         | AL = Mode (e.g., 03h = 80x25 text with 16 colors <br>and 13h = 320x200 with 256 colors, this is used for graphics)                                                                                                            |
| 02h      | Set cursor position    | BH = Page (if in text mode, aka 80x25, use 0), <br>DH = Row (0-24), DL = Column(0-79)                                                                                                                                         |
| 03h      | Get cursor position    | The only parameter is bh=page number, and returns dh=row and dl=column                                                                                                                                                        |
| 06h      | Scroll window up       | AL = Lines to scroll (0 is entire window), <br>BH = Attribute for blank lines (color), <br>CX/DX = Window coordinates (CX is topleft with ch=row and cl=colum, whereas DX is bottomright with dh=row and dl=column)           |
| 09h      | Write char to cursor   | AL = Character<br>BH = Page number<br>BL = Color<br>CX = Amount of times to write char                                                                                                                                        |
| 0Eh      | Teletype output        | AL = Character,<br>BH = Page number,<br>BL = Color (graphics mode only)                                                                                                                                                       |
| 13h      | Write string to screen | al = write mode (0 string with attributes, 1 string with color), <br>bh = page number,<br>bl = color/attribute,<br>cx=string length, "es" with data and "bp" with the address (or pointing to) of the string, doesn't need $. |

# Examples
## Basic operations and handling memory
With these basic examples, every aspect discussed in the guide should be more clear. There are comments that explain a bit further what is being done.

### Sum 3 numbers
```Assembly
.model small  
.stack 100h  
.data  
  numbers db 10, 20, 30   ; 3 bytes with the data (are contiguous)
  sum    db 0             ; here will be saved the result  
.code  
main proc  
  mov ax, @data  
  mov ds, ax  
  
  lea si, numbers       ; SI points to the array  
  mov al, [si]          ; AL = 10  
  add al, [si + 1]      ; AL += 20, AL = 30  
  add al, [si + 2]      ; AL += 30, AL = 60  
  mov sum, al          ; saves the result in the address "sum"  
  
  mov ax, 4C00h         ; returns with 0 code exit
  int 21h  
main endp  
end main  
```

