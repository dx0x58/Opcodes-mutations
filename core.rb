X86_CONST =  Crabstone::X86.constants.freeze

def assembly(code)
  ks = Ks.new(KS_ARCH_X86, KS_MODE_16)
  bytes, count = ks.asm(code)

  bytes
end

def disassembly(bytes_str)
  cs = Disassembler.new(ARCH_X86, MODE_16)
  disasm = cs.disasm(bytes_str, 0x1000)

  disasm.map do |i|
    binary_string = i.bytes.pack('c*')

    # binding.pry
    hex_string = binary_string.unpack('H*').first.split('').each_slice(2).to_a.map(&:join).join(' ')
    bytes_string = binary_string.unpack('B*').first.split('').each_slice(8).to_a.map(&:join)

    puts "#{hex_string} | #{bytes_string} | #{i.mnemonic} #{i.op_str}"
    [hex_string, bytes_string, i.mnemonic.to_s, i.op_str.to_s]
  end
end

def registers
  X86_CONST
    .select { |name| name.to_s.start_with? 'REG' }
    .map { |name| name.to_s.split('_').last.downcase }
end

def instructions
  X86_CONST
    .select { |name| name.to_s.start_with? 'INS' }
    .map { |name| name.to_s.split('_').last.downcase }
end
