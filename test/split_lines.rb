#!/usr/bin/env ruby

# Just a simple file that splits each row of the csv into it's own file with
# headers from the original file. used for testing individual rows to debug
# weird problems on a more granular level

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
