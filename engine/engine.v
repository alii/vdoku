module engine

import rand.util

const (
	size          = 9
	square_size   = 3
	default_shape = [
		[3, 0, 6, 5, 0, 8, 4, 0, 0],
		[5, 2, 0, 0, 0, 0, 0, 0, 0],
		[0, 8, 7, 0, 0, 0, 0, 3, 1],
		[0, 0, 3, 0, 1, 0, 0, 8, 0],
		[9, 0, 0, 8, 6, 3, 0, 0, 5],
		[0, 5, 0, 0, 9, 0, 6, 0, 0],
		[1, 3, 0, 0, 0, 0, 2, 5, 0],
		[0, 0, 0, 0, 0, 0, 0, 7, 4],
		[0, 0, 5, 2, 0, 6, 3, 0, 0],
	].map(fn (row []int) []i8 {
		return row.map(fn (x int) i8 {
			return i8(x)
		})
	})
)

pub fn any(nums []i8) []i8 {
	return util.sample_nr(nums, nums.len)
}

pub fn pattern(r i8, c i8) i8 {
	return (engine.square_size * (r % engine.square_size) + r / engine.square_size + c) % engine.size
}

pub struct Board {
mut:
	iterations i64
	shape      [][]i8 = engine.default_shape
}

pub fn (b Board) get_shape() [][]i8 {
	return b.shape
}

pub fn (b Board) get_iterations() i64 {
	return b.iterations
}

pub fn (b Board) can_insert(x i8, y i8) bool {
	return b.shape[x][y] == 0
}

pub fn (b Board) find_empty_cell() ?(i8, i8) {
	for row in 0 .. engine.size {
		for col in 0 .. engine.size {
			if b.shape[row][col] == 0 {
				return row, col
			}
		}
	}

	return error('no empty cells found')
}

pub fn (b Board) row_has(row i8, num i8) bool {
	for x in 0 .. engine.size {
		if b.shape[row][x] == num {
			return true
		}
	}

	return false
}

pub fn (b Board) col_has(col i8, num i8) bool {
	for y in 0 .. engine.size {
		if b.shape[y][col] == num {
			return true
		}
	}

	return false
}

pub fn (b Board) square_has(row i8, col i8, num i8) bool {
	row_start := row - (row % engine.square_size)
	col_start := col - (col % engine.square_size)

	for x := 0; x < engine.square_size; x++ {
		for y := 0; y < engine.square_size; y++ {
			if b.shape[x + row_start][y + col_start] == num {
				return true
			}
		}
	}

	return false
}

pub fn (b Board) location_safe(row i8, col i8, num i8) bool {
	return !b.col_has(col, num) && !b.row_has(row, num) && !b.square_has(row, col, num)
}

pub fn (mut b Board) solve() ?bool {
	b.iterations++

	row, col := b.find_empty_cell() or { return true }

	for num in 1 .. engine.size + 1 {
		if !b.location_safe(row, col, num) {
			continue
		}

		b.fill_cell(row, col, num)

		if b.solve() or { false } {
			return true
		}

		b.shape[row][col] = 0
	}

	return error('no solution found')
}

pub fn (mut b Board) fill_cell(row i8, col i8, value i8) {
	b.shape[row][col] = value
}

pub fn (b Board) render() string {
	mut result := ''

	for i := 0; i < engine.size; i++ {
		row := b.shape[i].map(fn (v i8) string {
			if v == 0 {
				return '.'
			}

			return v.str()
		})

		result += row.join(' ')
		result += '\n'
	}

	return result
}

pub fn (b Board) str() string {
	return b.render()
}
