import random


registers = [f"x{i}" for i in range(32)]
register_codes = {f"x{i}": i for i in range(32)}


R_TYPE_INSTRUCTIONS = {
    "add": (0b0110011, 0b000, 0b0000000),
    "sub": (0b0110011, 0b000, 0b0100000),
    "xor": (0b0110011, 0b100, 0b0000000),
    "or": (0b0110011, 0b110, 0b0000000),
    "and": (0b0110011, 0b111, 0b0000000),
    "sll": (0b0110011, 0b001, 0b0000000),
    "srl": (0b0110011, 0b101, 0b0000000),
    "sra": (0b0110011, 0b101, 0b0100000),
    "slt": (0b0110011, 0b010, 0b0000000),
    "sltu": (0b0110011, 0b011, 0b0000000),
}

I_TYPE_INSTRUCTIONS = {
    "lw": 0b0000011,
    "sw": 0b0100011,
    "addi": 0b0010011,
    "xori": 0b0010011,
    "andi": 0b0010011,
    "ori": 0b0010011,
    "slti": 0b0010011,
    "jalr": 0b1100111,
}

B_TYPE_INSTRUCTIONS = {
    "beq": 0b1100011,
    "bne": 0b1100011,
    "blt": 0b1100011,
    "bge": 0b1100011,
}

J_TYPE_INSTRUCTIONS = {
    "jal": 0b1101111,
}

U_TYPE_INSTRUCTIONS = {
    "lui": 0b0110111,
    "auipc": 0b0010111,
}

def generate_r_type_instruction(opcode, func3, func7, rd, rs1, rs2):

    return (func7 << 25) | (register_codes[rs2] << 20) | (register_codes[rs1] << 15) | \
           (register_codes[rd] << 7) | (func3 << 12) | (opcode << 0)

def generate_i_type_instruction(opcode, func3, imm, rd, rs1):

    return (imm & 0xFFF) | (register_codes[rs1] << 15) | (register_codes[rd] << 7) | \
           (func3 << 12) | (opcode << 0)

def generate_b_type_instruction(opcode, func3, imm, rs1, rs2):

    imm12 = (imm >> 12) & 0x1
    imm10_5 = (imm >> 5) & 0x3F
    imm4_1 = (imm >> 1) & 0xF
    imm11 = (imm >> 11) & 0x1
    return (imm12 << 31) | (imm11 << 7) | (imm10_5 << 25) | (register_codes[rs2] << 20) | \
           (register_codes[rs1] << 15) | (func3 << 12) | (opcode << 0)

def generate_j_type_instruction(opcode, imm, rd):

    imm20 = (imm >> 20) & 0x1
    imm10_1 = (imm >> 1) & 0x3FF
    imm11 = (imm >> 11) & 0x1
    imm19_12 = (imm >> 12) & 0xFF
    return (imm20 << 31) | (imm19_12 << 12) | (imm11 << 20) | (imm10_1 << 1) | \
           (register_codes[rd] << 7) | (opcode << 0)

def generate_instruction():

    instruction_type = random.choice(["R", "I", "S", "B", "U", "J"])

    if instruction_type == "R":
        func3, func7 = random.choice(list(R_TYPE_INSTRUCTIONS.values()))[1:3]
        rd = random.choice(registers)
        rs1 = random.choice(registers)
        rs2 = random.choice(registers)
        opcode = 0b0110011  # R-type opcode
        return generate_r_type_instruction(opcode, func3, func7, rd, rs1, rs2)

    elif instruction_type == "I":
        instr = random.choice(list(I_TYPE_INSTRUCTIONS.keys()))
        imm = random.randint(-128, 127)
        rs1 = random.choice(registers)
        rd = random.choice(registers)
        opcode = I_TYPE_INSTRUCTIONS[instr]
        func3 = 0b000
        return generate_i_type_instruction(opcode, func3, imm, rd, rs1)

    elif instruction_type == "S":
        instr = random.choice(list(I_TYPE_INSTRUCTIONS.keys()))
        imm = random.randint(-128, 127)
        rs1 = random.choice(registers)
        rs2 = random.choice(registers)
        opcode = I_TYPE_INSTRUCTIONS[instr]
        func3 = 0b010
        return generate_i_type_instruction(opcode, func3, imm, rs1, rs2)

    elif instruction_type == "B":
        instr = random.choice(list(B_TYPE_INSTRUCTIONS.keys()))
        imm = random.randint(-32, 32) * 2
        rs1 = random.choice(registers)
        rs2 = random.choice(registers)
        opcode = B_TYPE_INSTRUCTIONS[instr]
        func3 = 0b000
        return generate_b_type_instruction(opcode, func3, imm, rs1, rs2)

    elif instruction_type == "U":
        instr = random.choice(list(U_TYPE_INSTRUCTIONS.keys()))
        imm = random.randint(0, 0xFFFFF)
        rd = random.choice(registers)
        opcode = U_TYPE_INSTRUCTIONS[instr]
        return generate_i_type_instruction(opcode, 0b000, imm, rd, "x0")  # U-type doesn't need rs1

    elif instruction_type == "J":
        instr = random.choice(list(J_TYPE_INSTRUCTIONS.keys()))
        imm = random.randint(-32, 32) * 2
        rd = random.choice(registers)
        opcode = J_TYPE_INSTRUCTIONS[instr]
        return generate_j_type_instruction(opcode, imm, rd)

def generate_instructions(n):

    instructions = []
    for _ in range(n):
        instructions.append(generate_instruction())
    return instructions

def write_hex_file(instructions, filename="instructions.hex"):

    with open(filename, "w") as f:
        for instr in instructions:
            f.write(f"{instr:08x}\n")


instructions = generate_instructions(32)
write_hex_file(instructions)
