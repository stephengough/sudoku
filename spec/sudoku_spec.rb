require 'sudoku'

describe 'Board' do
  
  def index_board
    return Board.new(Array(1..81))
  end
  
  it 'should return a row' do
    b = index_board
    expect(b.row(0)).to eq([1,2,3,4,5,6,7,8,9])
    expect(b.row(8)).to eq([73,74,75,76,77,78,79,80,81])
    
  end
  
  it 'should return a column' do
    b = index_board
    expect(b.col(0)).to eq([1,10,19,28,37,46,55,64,73])
    expect(b.col(8)).to eq([9,18,27,36,45,54,63,72,81])

  end
  
  it 'should return a quadrant' do
    b = index_board    
    expect(b.quad(0)).to eq([1,2,3,10,11,12,19,20,21])
    expect(b.quad(8)).to eq([61,62,63,70,71,72,79,80,81])
        
  end
  
  it 'should return row for an index' do
    b = index_board    
    expect(b.row_of(0)).to eq(0)
    expect(b.row_of(80)).to eq(8)
    
  end
  
  it 'should return col for an index' do
    b = index_board    
    expect(b.col_of(0)).to eq(0)
    expect(b.col_of(80)).to eq(8)
    
  end
  
  it 'should return quadrant for an index' do
    b = index_board    
    expect(b.quad_of(0)).to eq(0)
    expect(b.quad_of(40)).to eq(4)
    expect(b.quad_of(80)).to eq(8)
    
  end
  
  
  it 'should return candidate entries for a space' do

    arr = [
      0,9,8,7,6,5,4,3,2,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
    ]
    
    b = Board.new(arr)    
    
    expect(b.candidates(0)).to eq([1])
    
  end

  it 'should return candidate entries for a space' do

    arr = [
      0,9,8,7,0,0,0,0,0,
      6,0,0,0,0,0,0,0,0,
      5,0,0,0,0,0,0,0,0,
      4,0,0,0,0,0,0,0,0,
      2,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
    ]

    b = Board.new(arr)
            
    expect(b.candidates(0)).to eq([1,3])
    
  end
  
  it 'should be able to get and set a grid value' do
    b = Board.new(Array.new(81))
    
    b.set(0, 9)
    
    expect(b.get(0)).to eq(9)
  end
  
  it 'should know when the grid is full' do
    b = index_board
    expect(b.full?).to be_truthy
  end

  it 'should know when the grid is not full' do
    b = index_board
    b.set(0, nil)
    expect(b.full?).to be_falsy
  end
  
  it 'should be able to solve unambiguous cases' do

    arr = [
      0,2,3,4,5,6,7,8,9,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
    ]

    b = Board.new(arr)
    
    b.solve_obvious
    
    expect(b.get(0)).to eq(1)    
  end
  
  it 'should be able to solve dependent unambiguous cases' do

    arr = [
      0,0,0,0,0,0,0,0,0,
      0,2,3,4,5,6,7,8,9,
      5,0,0,0,0,0,0,0,0,
      6,0,0,0,0,0,0,0,0,
      7,0,0,0,0,0,0,0,0,
      8,0,0,0,0,0,0,0,0,
      9,0,0,0,0,0,0,0,0,
      2,0,0,0,0,0,0,0,0,
      3,0,0,0,0,0,0,0,0,
    ]

    b = Board.new(arr)
            
    b.solve_obvious
    
    expect(b.get(9)).to eq(1)    
    expect(b.get(0)).to eq(4)    
    
  end
  
  it 'should identify the best guess candidate' do

    arr = [
      0,0,0,4,5,6,7,8,9,
      1,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
    ]

    b = Board.new(arr)
    
    g = b.best_guess

    expect(g[:index]).to eq(0)
    expect(g[:candidates]).to eq([2,3])

  end
  
  it 'should solve a real example' do

    arr = [
      5,0,0,9,4,1,8,7,2,
      0,0,1,0,0,0,4,0,3,
      0,8,4,0,0,0,0,0,0,
      0,0,0,6,0,0,1,0,0,
      0,7,0,0,8,0,0,4,0,
      0,0,5,0,0,2,0,0,0,
      0,0,0,0,1,0,9,8,0,
      3,0,0,0,5,0,0,0,0,
      6,0,0,0,0,7,0,0,0
    ]
                
    Board.solve(arr)

  end

  it 'should handle an empty board' do
            
    Board.solve(Array.new(81))

  end
  
  # it 'should solve the Telegraph "really hard" example' do
  #
  #   arr = [
  #     8,0,0,0,0,0,0,0,0,
  #     0,0,3,6,0,0,0,0,0,
  #     0,7,0,0,9,0,2,0,0,
  #     0,5,0,0,0,7,0,0,0,
  #     0,0,0,0,4,5,7,0,0,
  #     0,0,0,1,0,0,0,3,0,
  #     0,0,1,0,0,0,0,6,8,
  #     0,0,8,5,0,0,0,1,0,
  #     0,9,0,0,0,0,4,0,0
  #   ]
  #
  #   Board.solve(arr)
  #
  # end

  # it 'should solve a case with 17 givens' do
  #   arr = [
  #     0,0,0,0,0,0,0,1,0,
  #     0,0,0,0,0,2,0,0,3,
  #     0,0,0,4,0,0,0,0,0,
  #     0,0,0,0,0,0,5,0,0,
  #     4,0,1,6,0,0,0,0,0,
  #     0,0,7,1,0,0,0,0,0,
  #     0,5,0,0,0,0,2,0,0,
  #     0,0,0,0,8,0,0,4,0,
  #     0,3,0,9,1,0,0,0,
  #   ]
  #
  #   Board.solve(arr)
  #
  # end
  
end
