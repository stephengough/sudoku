require 'text-table'

class Board

  def initialize
    @arr = Array.new(81)    
  end
  
  def initialize(arr)
    @arr = arr.map { |x| x == 0 ? nil : x }
    
  end
  
  def row(r)
    @arr[r * 9, 9]
  end
  
  def col(c)
    c.step(80, 9).map { |i| @arr[i] }
  end
  
  def quad(q)
    tl = [0,3,6,27,30,33,54,57,60]
    offsets = [0,1,2,9,10,11,18,19,20]    
    offsets.map { |i| @arr[tl[q] + i]}
  end
  
  def row_of(i)
    return i / 9
  end
  
  def col_of(i)
    return i % 9
  end
  
  def quad_of(i)
    qr = row_of(i) / 3
    qc = col_of(i) / 3
    return qr * 3 + qc
  end
  
  def candidates(i)
    row_vals = row(row_of(i))
    col_vals = col(col_of(i))
    quad_vals = quad(quad_of(i))

    Array(1..9) - row_vals - col_vals - quad_vals
  end
  
  def set(i, v)
    @arr[i] = v
  end

  def get(i)
    @arr[i]
  end
  
  def solve_obvious
    loop do
      for i in 0..80 do
        if @arr[i] == nil
          c = candidates(i)
          if c.length == 1
            @arr[i] = c[0]
            did_something = true
          end
        end
      end
      break if !did_something
    end
  end
  
  def best_guess
    
    best_ix = nil
    best_candidates = nil
    
    for i in 0..80 do
      if @arr[i] == nil
        c = candidates(i)
        if best_candidates == nil || c.length < best_candidates.length
          best_ix = i
          best_candidates = c
        end
      end
    end
    
    return {:index => best_ix, :candidates => best_candidates}
    
  end
  
  def arr
    @arr
  end
    
  def self.solve(arr)
    
    puts "Solving. I may be some time..."
    start = Time.now
        
    boards = []
    boards << Board.new(arr)

    count = 0
    while !boards.empty?
      count += 1
      board = boards.pop
      board.solve_obvious
      if board.full?
        board.dump
        puts "Solution found in #{count} steps (#{Time.now - start} seconds)"
        break
      else
        g = board.best_guess        
        for c in g[:candidates]
          b = Board.new(board.arr.dup)
          b.set(g[:index], c)
          boards << b
        end
      end
    end
    
  end
  
  def full?
    return !@arr.include?(nil)
  end

  def dump
    table = Text::Table.new
    
    @arr.each_slice(9) do | row |
      table.rows << row
      table.rows << :separator
    end
    table.rows.pop
    
    puts table.to_s
  end

end