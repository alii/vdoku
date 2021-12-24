module main

import engine

fn main() {
	mut board := engine.Board{}
	println('solving board')
	println(board)

	board.solve() ?
	println('took $board.get_iterations() attempts')
	println(board)
}
