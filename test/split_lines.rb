#!/usr/bin/env ruby

csv_file = open('new_test2.csv', "r")
header_line = csv_file.readline
Dir.mkdir "split_files"
index = 1
csv_file.each_line do |line|
  file = open("split_files/#{index}.csv", "w")
  file.write header_line
  file.write line
  file.close
  index += 1
end
csv_file.close
