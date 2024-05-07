import lustre
import lustre/attribute.{src}
import lustre/event
import lustre/element/html
import lustre/element
import gleam/int

pub type Model {
  Counter(value: Int)
}

pub type Msg {
  Increment
  Decrement
}

pub fn update(model: Model, msg: Msg) -> Model {
  case msg {
    Increment -> {
      let assert Counter(value) = model
      Counter(value + 1)
    }
    Decrement -> {
      let assert Counter(value) = model
      Counter(value - 1)
    }
  }
}

fn init(_flags) -> Model {
  Counter(1)
}

pub fn view(model: Model) -> element.Element(Msg) {
  let count = case model {
    Counter(val) -> int.to_string(val)
  }

  html.div([], [
    html.button([event.on_click(Increment)], [element.text("+")]),
    element.text(count),
    html.button([event.on_click(Decrement)], [element.text("-")]),
    hello_world(),
  ])
}

/// This is the main function
pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

fn hello_world() {
  html.div([], [
    html.h1([], [element.text("It's your life.")]),
    html.h2([], [
      element.text("Do not let it get clubbed into dank submission!"),
    ]),
    html.figure([], [
      html.img([src("https://cataas.com/cat")]),
      html.figcaption([], [element.text("A cat!")]),
    ]),
  ])
}
