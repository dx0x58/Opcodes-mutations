require 'keystone_engine'
require 'keystone_engine/keystone_const'
require 'pry-byebug'
require 'crabstone'
require_relative './core'
require_relative './register_register_case.rb'

include Crabstone
include KeystoneEngine

## Case 1. Register - Register

results = register_register_case

File.open('output/register_register_output.txt', 'w') do |file|
  results.each do |result_orig, result_switched_byte|
    next if result_switched_byte.nil?

    result_orig = result_orig[0]
    result_switched_byte = result_switched_byte[0]

    file.puts("#{result_orig[0]} | #{result_orig[1].join(' ')} | #{result_orig[2]} #{result_orig[3]}")
    file.puts("#{result_switched_byte[0]} | #{result_switched_byte[1].join(' ')} | #{result_switched_byte[2]} #{result_switched_byte[3]}")

  end
end


### Case 2. Register - Memory

def change_mem_bytes(bytes, replacement)
  bytes[1][0..1] = replacement
  changed_bytes = [bytes.join].pack('B*')
  disassembly(changed_bytes)
end

def mnemonics_equal?(result_1, result_2, result_3)
    ins1 = result_1[0][2].to_s
    ins2 = result_2[0][2].to_s
    ins3 = result_3[0][2].to_s

    oper1 = result_1[0][3].to_s
    oper2 = result_2[0][3].to_s
    oper3 = result_2[0][3].to_s

    [ins1, ins2, ins3].uniq.size == 1 && [oper1, oper2, oper3].uniq.size == 1
end

def register_memory_case
  results = []
  File.readlines('valid_instructions/register_memory.txt').each do |ins|
      ins = ins.chomp
      bytes =  assembly(ins)
      result = disassembly(bytes)

      change_mem_result_1 = change_mem_bytes(result[0][1].map(&:clone), '00')
      change_mem_result_2 = change_mem_bytes(result[0][1].map(&:clone), '01')
      change_mem_result_3 = change_mem_bytes(result[0][1].map(&:clone), '10')

      next unless mnemonics_equal?(change_mem_result_1, change_mem_result_2, change_mem_result_3)


      results << [change_mem_result_1, change_mem_result_2, change_mem_result_3]
    rescue
    end


    File.open('output/register_memory_output.txt', 'w') do |file|
      results.each do |items|
        items.each do |item|
          item = item[0]
          next if item.nil?

          file.puts("#{item[0]} | #{item[1].join(' ')} | #{item[2]} #{item[3]}")
        end
      end
    end
  end


register_memory_case