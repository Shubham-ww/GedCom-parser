#!/usr/bin/ruby
$LOAD_PATH << '.'
require "hash_to_xml"
require 'xmlsimple'

@temp = Hash.new
@res = Hash.new
$res_var = 0
$x = 1
$var = 0
$last_level = 1
#[level, id, tag, data]
case1, case2, case3 = false
$zero_level1, $zero_level2, $zero_level3 = false

$case1Regex = /^(\d{1})[\ ]*([A-Z]{3,4})[\ ]*([^@]{1}[A-z0-9\-\:\,\!\~\#\$\%\^\&\*\>\(\)\'\;\?\"\<\>\@\.\:\ \/]*[^@]{1}$)/
$case2Regex = /^(\d{1})[\ ]*(@[A-z0-9]*@)[\ ]*([A-Z]{3,4})$/
$case3Regex = /^(\d{1})[\ ]*([A-Z]{3,4})[\ ]*(@[A-z0-9]*@)$/
$case4Regex = /^(\d{1})[\ ]*([A-Z]{3,4})$/
$zero_levelRegex1 = /^(0)[\ ]*(@[A-z0-9]*@)[\ ]*([A-Z]{3,4})$/
$zero_levelRegex2 = /^(0)[\ ]*([A-Z]{3,4})[\ ]*(@[A-z0-9]*@)$/
$zero_levelRegex3 = /^(0)[\ ]*([A-Z]{3,4})$/

def check_child(r_hash, values, level)
  flag = ($last_level == values[0].to_i - 1)
  var = r_hash.count - 2
  if level < (values[0].to_i)
    check_child(r_hash[var-1], values, level + 1)
  else
    r_hash[var] = Hash.new
    r_hash[var]["id"] = values[1] if !values[1].nil?
    r_hash[var]["tag"] = values[2] if !values[2].nil?
    r_hash[var]["data"] = values[3] if !values[3].nil?
    $last_level = values[0].to_i
  end
end

def update_hash(parts)
  $var = @temp.count - 2
  if $last_level < parts[0].to_i || parts[0].to_i > 1
    $var -= 1
    check_child(@temp, parts, $x)
  elsif @temp[$var].nil?
    @temp[$var] = Hash.new
    @temp[$var]["id"] = parts[1] if !parts[1].nil?
    @temp[$var]["tag"] = parts[2] if !parts[2].nil?
    @temp[$var]["data"] = parts[3] if !parts[3].nil?
    $last_level = parts[0].to_i
  end
end

def zero_level(line)
  parts = line.chomp.split(" ")

  case $zero_level1|$zero_level2|$zero_level3
  when $zero_level1
    level = parts[0]
    id = parts[1]
    tag = parts[2]
    parts.clear
    parts << level << id << tag << nil 
  when $zero_level2
    level = parts[0]
    id = parts[2]
    tag = parts[1]
    parts.clear
    parts << level << id << tag << nil
  when $zero_level3
    level = parts[0]
    tag = parts[1]
    parts.clear
    parts << level << nil << tag << nil 
  end
  if !@temp.empty?
    @res[$res_var] = @temp
    $res_var += 1
    @temp = Hash.new
  end
  @temp["id"] = parts[1] if !parts[1].nil?
  @temp["tag"] = parts[2] if !parts[2].nil?
end

def case_1(line)
  line.match($case1Regex)
  parts = Array.new
  parts << $1 << nil << $2 << $3
  update_hash(parts)
end

def case_2(line)
  line.match($case2Regex)
  parts = Array.new
  parts << $1 << $2 << $3 << nil
  update_hash(parts)
end

def case_3(line)
  line.match($case3Regex)
  parts = Array.new
  parts << $1 << $3 << $2 << nil
  update_hash(parts)
end

def case_4(line)
  line.match($case4Regex)
  parts = Array.new
  parts << $1 << nil << $2 << nil
  update_hash(parts)
end

while line = gets
  line.chomp!
  case1 = !line.match($case1Regex).nil?
  case2 = !line.match($case2Regex).nil?
  case3 = !line.match($case3Regex).nil?
  case4 = !line.match($case4Regex).nil?
  $zero_level1 = !line.match($zero_levelRegex1).nil?
  $zero_level2 = !line.match($zero_levelRegex2).nil?
  $zero_level3 = !line.match($zero_levelRegex3).nil?
  if case1||case2||case3||case4
    if $zero_level1 || $zero_level2 || $zero_level3
      zero_level(line)
    else
      case case1|case2|case3|case4
      when case1
        case_1(line)
      when case2
        case_2(line)
      when case3
        case_3(line)
      when case4
        case_4(line)
      else
        p "impossible"
      end
    end
  else
    if !line.empty?
      p "Invalid GEDCOM file!"
      exit
    end
  end
end
@res[$res_var] = @temp
HashToXml.convert(@res)