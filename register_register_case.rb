def switch_direction_byte(bytes)
  direction_byte = bytes[0][-2]

  if direction_byte == '0'
    bytes[0][-2] = '1'
  else
    bytes[0][-2] = '0'
  end

  byte_string = [bytes.join].pack('B*')


  byte_string
end

def register_register_case
  results = []

  File.readlines('valid_instructions/register_register.txt').each do |ins|
    ins = ins.chomp
    bytes =  assembly(ins)
    result_orig = disassembly(bytes)

    bytes = switch_direction_byte(result_orig[0][1].map(&:clone))

    result_switched_byte = disassembly(bytes)

    # next if mnemonics not equal after switch byte
    next unless mnemonics_equal?(result_orig, result_switched_byte)

    results << [result_orig, result_switched_byte]
  rescue
    puts "Switch direction byte error: #{result_orig}"
  end

  results
end

def mnemonics_equal?(result_1, result_2)
    ins1 = result_1[0][2].to_s
    ins2 = result_2[0][2].to_s

    oper1 = result_1[0][3].to_s
    oper2 = result_2[0][3].to_s


    (ins1 == ins2) && (oper1 == oper2)
end
