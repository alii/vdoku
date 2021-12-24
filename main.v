module main

import engine

fn main() {
	mut board := engine.new_board(engine.default_shape)

	println('solving board')
	println(board)

	board.solve() ?
	println('took $board.get_iterations() attempts')
	println(board)
}
