import gleam/int
import lustre
import lustre/attribute.{src, style}
import lustre/element
import lustre/element/html
import lustre/event

pub type Model {
  Counter(value: Int)
}

pub type Msg {
  Increment
  Decrement
}

@external(javascript, "./parse_url_ffi.mjs", "getUrl")
pub fn urly() -> String

pub fn update(model: Model, msg: Msg) -> Model {
  let new_number = case urly() {
    "http://localhost:1234/go?inpy=" <> rest ->
      case int.parse(rest) {
        Ok(val) -> val
        Error(_) -> 0
      }
    _ -> -1
  }
  case msg {
    Increment -> {
      let assert Counter(value) = model
      Counter(value + new_number)
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
    html.h1([style([#("color", "blue")])], [element.text("It's your life.")]),
    html.h2([], [
      element.text("Do not let it get clubbed into dank submission!"),
    ]),
    html.form([attribute.action("/go")], [
      html.label(
        [
          attribute.for("inpy"),
          style([#("display", "block"), #("margin-bottom", "5px")]),
        ],
        [html.text("inpy")],
      ),
      html.input([
        attribute.name("inpy"),
        attribute.id("inpy"),
        attribute.type_("text"),
      ]),
      html.button([], [html.text("submitty")]),
    ]),
    html.figure([], [
      html.img([src("https://cataas.com/cat")]),
      html.figcaption([], [element.text("A cat!")]),
    ]),
  ])
}
