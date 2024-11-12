import random

# Define registers and immediate range
registers = [f"x{i}" for i in range(1, 32)]  # Exclude x0 as it's hard-wired to 0
register_codes = {f"x{i}": i for i in range(32)}
immediate_range = range(-2048, 2047)

# RISC-V Instruction opcodes and funct codes
R_TYPE_INSTRUCTIONS = {
    "add": (0b0110011, 0b000, 0b0000000),
    "sub": (0b0110011, 0b000, 0b0100000),
    "xor": (0b0110011, 0b100, 0b0000000),
    "or": (0b0110011, 0b110, 0b0000000),
    "and": (0b0110011, 0b111, 0b0000000)
}

I_TYPE_INSTRUCTIONS = {
    "addi": (0b0010011, 0b000),
    "xori": (0b0010011, 0b100),
    "ori": (0b0010011, 0b110),
    "andi": (0b0010011, 0b111)
}

S_TYPE_INSTRUCTIONS = {
    "sb": (0b0100011, 0b000),
    "sh": (0b0100011, 0b001),
    "sw": (0b0100011, 0b010)
}

B_TYPE_INSTRUCTIONS = {
    "beq": (0b1100011, 0b000),
    "bne": (0b1100011, 0b001)
}


# Helper to format in hexadecimal
def to_hex(val, bits=32):
    return f"{val & ((1 << bits) - 1):08x}"


# R-type encoding
def encode_r_type(inst, rd, rs1, rs2):
    opcode, funct3, funct7 = R_TYPE_INSTRUCTIONS[inst]
    rd_code = register_codes[rd]
    rs1_code = register_codes[rs1]
    rs2_code = register_codes[rs2]
    return (funct7 << 25) | (rs2_code << 20) | (rs1_code << 15) | (funct3 << 12) | (rd_code << 7) | opcode


# I-type encoding
def encode_i_type(inst, rd, rs1, imm):
    opcode, funct3 = I_TYPE_INSTRUCTIONS[inst]
    rd_code = register_codes[rd]
    rs1_code = register_codes[rs1]
    imm = imm & 0xFFF  # 12-bit immediate
    return (imm << 20) | (rs1_code << 15) | (funct3 << 12) | (rd_code << 7) | opcode


# S-type encoding
def encode_s_type(inst, rs1, rs2, imm):
    opcode, funct3 = S_TYPE_INSTRUCTIONS[inst]
    rs1_code = register_codes[rs1]
    rs2_code = register_codes[rs2]
    imm_low = imm & 0x1F
    imm_high = (imm >> 5) & 0x7F
    return (imm_high << 25) | (rs2_code << 20) | (rs1_code << 15) | (funct3 << 12) | (imm_low << 7) | opcode


# B-type encoding
def encode_b_type(inst, rs1, rs2, imm):
    opcode, funct3 = B_TYPE_INSTRUCTIONS[inst]
    rs1_code = register_codes[rs1]
    rs2_code = register_codes[rs2]
    imm = imm & 0x1FFF
    imm_11 = (imm >> 11) & 0x1
    imm_4_1 = (imm >> 1) & 0xF
    imm_10_5 = (imm >> 5) & 0x3F
    imm_12 = (imm >> 12) & 0x1
    return (imm_12 << 31) | (imm_10_5 << 25) | (rs2_code << 20) | (rs1_code << 15) | (funct3 << 12) | (imm_4_1 << 8) | (
                imm_11 << 7) | opcode


# Generate initial register values
def initialize_registers(num_init=5):
    init_instructions = []
    initialized_regs = []
    for _ in range(num_init):
        rd = random.choice(registers)
        imm = random.randint(-2048, 2047)
        encoded = encode_i_type("addi", rd, "x0", imm)
        init_instructions.append(to_hex(encoded))
        initialized_regs.append(rd)
    return init_instructions, initialized_regs


# Generate random R-type instruction
def generate_r_type(initialized_regs):
    inst = random.choice(list(R_TYPE_INSTRUCTIONS.keys()))
    rd, rs1, rs2 = random.sample(initialized_regs, 3)
    encoded = encode_r_type(inst, rd, rs1, rs2)
    return to_hex(encoded)


# Generate random I-type instruction
def generate_i_type(initialized_regs):
    inst = random.choice(list(I_TYPE_INSTRUCTIONS.keys()))
    rd, rs1 = random.sample(initialized_regs, 2)
    imm = random.randint(-2048, 2047)
    encoded = encode_i_type(inst, rd, rs1, imm)
    return to_hex(encoded)


# Generate random S-type instruction
def generate_s_type(initialized_regs):
    inst = random.choice(list(S_TYPE_INSTRUCTIONS.keys()))
    rs1, rs2 = random.sample(initialized_regs, 2)
    imm = random.randint(-2048, 2047)
    encoded = encode_s_type(inst, rs1, rs2, imm)
    return to_hex(encoded)


# Generate random B-type instruction
def generate_b_type(initialized_regs):
    inst = random.choice(list(B_TYPE_INSTRUCTIONS.keys()))
    rs1, rs2 = random.sample(initialized_regs, 2)
    imm = random.randint(-2048, 2047) & ~1  # Ensure imm is even for B-type
    encoded = encode_b_type(inst, rs1, rs2, imm)
    return to_hex(encoded)


# Main function to generate a test program with initialized registers
def generate_test_program(num_instructions=10):
    program = []
    init_instructions, initialized_regs = initialize_registers()
    program.extend(init_instructions)  # Add initialization instructions

    # Generate remaining instructions using initialized registers
    for _ in range(num_instructions):
        inst_type = random.choice(["R", "I", "S", "B"])
        if inst_type == "R":
            hex_inst = generate_r_type(initialized_regs)
        elif inst_type == "I":
            hex_inst = generate_i_type(initialized_regs)
        elif inst_type == "S":
            hex_inst = generate_s_type(initialized_regs)
        elif inst_type == "B":
            hex_inst = generate_b_type(initialized_regs)
        program.append(hex_inst)
    return program


# Generate and print a sample test program in hex only
if __name__ == "__main__":
    test_program = generate_test_program(10)
    for hex_inst in test_program:
        print(hex_inst)
