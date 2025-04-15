# Assembly 16-bit
16-bit assembly language is _a family of low-level programming languages_ that are used to produce object code for quite old processors (80s, or even 90s).

A really cool guide for pretty much everything, although in x86, but everything pretty much can be followed along: https://www.cs.virginia.edu/~evans/cs216/guides/x86.html

The full instruction set is **STUPIDLY** large and complex (Intel's x86 instruction set manuals comprise **over 2900 pages**). For example, there is a 16-bit subset of the x86 instruction set. Using the 16-bit programming model can be quite complex. It has a segmented memory model, more restrictions on register usage, and so on.

We will limit our attention to the aspects of 16-bit asm programming, and delve into the instruction set only in enough detail to get a basic feel for coding in this language and survive the semester.  

**Quick note:** 16-bit assembly works in **Real mode**, meaning we have complete access to the memory and instructions. In modern assembly, the instruction set is defined by an API or by Syscalls. In Windows is used the win32API, whereas in Linux we make syscalls to communicate with the intructions. That thing is called protected mode.

Also, the syntax we'll follow is Intel's. There is also AT&T syntax and some more standards, but these two are the most common. AT&T is in fact more used in Unix systems, but we are going out of topic, let's go back to the assembly part.

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
| Register | High Byte | Low Byte |
|----------|-----------|----------|
| AX       | AH        | AL       |
| BX       | BH        | BL       |
| CX       | CH        | CL       |
| DX       | DH        | DL       |

## Memory

The RAM is the memory where all the loaded data will be saved and then accessed for our programs. 

TO-DO: fill this :,3


### Basic structure of a 16-bit assembly program
#### Comments
Let's begin with a very easy concept. Keep a good practice to comment the lines of code you write since we are in a low level programming language. To do a comment, use the semicolon **;**.

E.g: 

``` Assembly
; This is a comment, everything that is to the right of the semicolon will be ignored, is just like any other language with // or #.
; mov ax, bx is ignored, because is to the right of a semicolon.
; It's not necessary to write a semicolon at the end of each line, but is generally a good idea to keep them in order to document the code.
```

#### Basic instructions, headers, and information for the file
Some people call this boilerplate, some others fillers, but in general every programming language has these sort of stuff.

Every 16-bit assembly language has the following:

```Assembly
.model small
.stack 100h
```

What does these two lines mean, is:

* ".model" defines that the file has some sort of scope and limits. Depending on the argument that it has (in this case, "small") will define characteristics in the overall program. The arguments that it can have are: "tiny", "small", "medium" and "large". For the great majority of the stuff we'll do, small will be ok.
* ".stack" defines the property of the stack of memory, and the argument is a hex value that indicates the amount of bytes that it will have. For now, 100h bytes of stack (256 bytes) is the standard and will work for simple examples.

#### Segments
We already saw segments that are for basic definitions in the program and file, now these are the two segments that will be used almost always:

```
.data
	;stuff

.code
	;stuff
```

These two represent:
##### .data
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

```
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

```
mov ds, ah           ; (valid, more on this later)  
mov ds, 1234h        ; (invalid - must use general register, ds is not one of those) 
```

#### lea
```
lea register, a_region_in_memory
```

Load Effective Address calculates the memory address of an operand but doesn't access the data at that address, creating a pointer/reference to data **instead of using the data itself**, like using &var in C.

```
lea dx, message  ; dx = offset address of message (Same as mov dx, offset message, but again more on that later)
```
For example, if `message` is at memory address 0100h, then:  
`lea DX, message` will remain in dx = 0100h

```
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
```
add destination, source
sub destination, source
```
What this does is a sum or subtraction to these two operands, resulting in destination = destination +/- source, hence the result is saved inside "destination". 
```
add ax, bx     ; AX = AX + BX
sub cl, 10     ; CL = CL - 10
add [di], al   ; int the region of memory that is at address di, sums the value of al
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
This are the basic DOS services, commonly used for the terminal. In order to indicate the service we want from the int 21h, the order has to be inside "ah". With this table everything will be more clear:

| AH value | Purpose                                   | Parameters                                                               | Return Values            |
| -------- | ----------------------------------------- | ------------------------------------------------------------------------ | ------------------------ |
| 01h      | Read character                            | nothing                                                                  | AL = ASCII char          |
| 02h      | Print character                           | "dl" = Character to print                                                | nothing                  |
| 09h      | Print string                              | "ds:dx" = Address of string (ending with $)                              | nothing                  |
| 0Ah      | Buffered input (multiple values of input) | "ds:dx" = Address of input buffer                                        | Buffer filled with input |
| 4Ch      | Exit program                              | "al" = return code (like in C, 0 is exit and any other is an error code) | nothing                  |
Example: imagine that there is a message inside .data that looks like `message db 'Hello!$`
then, a code to print this message to the terminal (remembering that it HAS to end with a $) is:

```
mov ah, 09h
lea dx, message  
int 21h          ; checks the value at ah, 09h means print the message that points the dx register, then prints "hello!"
```

Now a more complex example, reading input: There needs to be a buffer (space in memory to occupy) available where the input will be saved, then inside .data has to be some sort of definition similar to:

```
.data
	buffer db 20          ; The maximum amount of data to receive
	       db ?           ; a space that is reserved for the BIOS, here will be the amount of actual characters read, if the user inputs 10 characters, then here will be a value of 10
	       db 20 dup(0)   ; the buffer for input, all is zero
```

And in the code section:

```
.code
	mov ah, 0Ah         ; 0Ah is the function number for this action, input
	lea dx, buffer      ; loads the region of memory available for input (buffer)
	int 21h             ; reads input (like scanf in java or any other program)
```

##### int 10h
Used for low-level screen control, mostly the terminal screen.
As with the int 21h, the function has to be indicated inside "ah", and the parameters may vary of position.

| AH value | Function purpose       | Parameters                                                                                                                                                                                                          |
| -------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 00h      | Set video mode         | AL = Mode (e.g., 03h = 80x25 text with 16 colors and 13h = 320x200 with 256 colors, this is used for graphics)                                                                                                      |
| 02h      | Set cursor position    | BH = Page (if in text mode, aka 80x25, use 0), DH = Row (0-24), DL = Column(0-79)                                                                                                                                   |
| 03h      | Get cursor position    | The only parameter is bh=page number, and returns dh=row and dl=column                                                                                                                                              |
| 06h      | Scroll window up       | AL = Lines to scroll (0 is entire window), BH = Attribute for blank lines (color), CX/DX = Window coordinates (CX is topleft with ch=row and cl=colum, whereas DX is bottomright with dh=row and dl=column)         |
| 0Eh      | Teletype output        | AL = Character, BH = Page number, BL = Color (graphics mode only)                                                                                                                                                   |
| 13h      | Write string to screen | al = write mode (0 string with attributes, 1 string with color), bh = page number, bl = color/attribute, cx=string length, "es" with data and "bp" with the address (or pointing to) of the string, doesn't need $. |


