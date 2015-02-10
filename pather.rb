#!/usr/bin/ruby

class PatherSolver

	attr_reader :paths, :path_checkpoints, :rows_with_checkpoints, :starting_row, :starting_position

	def initialize(input)
		@paths = create_paths(input)
		@path_checkpoints = determine_checkpoints_in_paths
		@rows_with_checkpoints = determine_rows_with_checkpoints
		@starting_row = row_containing_first_checkpoint
		@starting_position = get_starting_position
	end

	def solve
		@rows_with_checkpoints.each_with_index do |checkpoint_row_number, index|
			if self.has_another_checkpoint_in_same_row?(checkpoint_row_number)
				fill_in_row(@starting_position, last_checkpoint_in_row(checkpoint_row_number), checkpoint_row_number)
				set_starting_position(last_checkpoint_in_row(checkpoint_row_number))
			end
			if no_more_checkpoints?(index)
				return @paths
			else
				fill_in_column(checkpoint_row_number, row_containing_next_checkpoint(index), @starting_position)
				do_the_checkpoint_slide!(row_containing_next_checkpoint(index))
			end
		end
		return @paths
	end

	# _____________________________________________________________________________

	# private


	def fill_in_column(start, finish, position)
		@paths.each_with_index do |subpath, index|
			if subpath[position] == "." && (index >= start && index <= finish)
				subpath[position].replace("*")
			end
		end
	end

	def fill_in_row(start, finish, position)
		@paths[position].each_with_index do |element, index|
			if element == "." && (index >= start && index <= finish)
				element.replace("*")
			end
		end
	end

	def do_the_checkpoint_slide!(row_position)
		if last_checkpoint_in_row(row_position) > @starting_position
			fill_in_row(@starting_position, last_checkpoint_in_row(row_position), row_position)
			fill_in_row(last_checkpoint_in_row(row_position), first_checkpoint_in_row(row_position), row_position) if self.has_another_checkpoint_in_same_row?(row_position)
			set_starting_position(first_checkpoint_in_row(row_position))
		elsif last_checkpoint_in_row(row_position) < @starting_position
			fill_in_row(first_checkpoint_in_row(row_position), @starting_position, row_position)
			set_starting_position(first_checkpoint_in_row(row_position))
		end
	end

	def create_paths(input)
		input.each {|character| character.gsub!("\n", "")}
		input.join.split("").each_slice(24).to_a
  end

  def determine_checkpoints_in_paths
  	hash_of_paths = {}
		@paths.each_with_index do |subpath, index|
			hash_of_paths[index] = subpath.size.times.select {|index| subpath[index] == "#"}
		end
		isolate_checkpoints(hash_of_paths)
  end

  def determine_rows_with_checkpoints
  	@path_checkpoints.keys
  end

	def isolate_checkpoints(hash)
		hash.delete_if {|key, value| value.empty?}
	end

	def row_containing_first_checkpoint
		@path_checkpoints.keys.first
	end

	def get_starting_position
		@path_checkpoints[@starting_row].first
	end

	def get_row_containing_last_checkpoint
		@path_checkpoints.keys.last
	end

	def set_starting_position(position)
		@starting_position = position
	end

	def has_another_checkpoint_in_same_column?(value)
		other_checkpoints_in_column = @path_checkpoints.select {|key, values| values.include?(value) }
		other_checkpoints_in_column.length > 1
	end

	def has_another_checkpoint_in_same_row?(row)
		other_checkpoints_in_row = @path_checkpoints[row]
		other_checkpoints_in_row.length > 1
	end

	def first_checkpoint_in_row(row)
		other_checkpoints_in_row = @path_checkpoints[row]
		other_checkpoints_in_row.first		
	end

	def last_checkpoint_in_row(row)
		other_checkpoints_in_row = @path_checkpoints[row]
		other_checkpoints_in_row.last
	end

	def no_more_checkpoints?(position)
		@rows_with_checkpoints[position + 1].nil?
	end

	def row_containing_next_checkpoint(position)
		@rows_with_checkpoints[position + 1]
	end

end



	# if ARGV.any?
	# input = [] 
	# if ARGV.length < 2
	# 	file = File.open(ARGV[0], "r")
	# 	file.each_line do |line|
	# 		input << line 
	# 	end
	# 	file.close
	# 	p = PatherSolver.new(input)
	# 	file = File.open("output.txt", "w+")
	# 	output = p.solve.map! {|row| row.join}
	# 	output.each do |row|
	# 		file.puts row
	# 	end
	# end
	# elsif ARGV.length == 2
	# 	file = File.open(ARGV[0], "r")
	# 	file.each_line do |line|
	# 		input << line 
	# 	end
	# 	file.close
	# 	p = PatherSolver.new(input)
	# 	file = File.new(ARGV[1], "w+")
	# 	output = p.solve.map {|row| row.join + "\n"}.join
	# 	file.write(output)
	# 	file.close
	# 	end
	# end
# end
