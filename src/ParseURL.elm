module ParseURL where

{-| See https://url.spec.whatwg.org/ for actual spec
-}

import Parser exposing (..)
import String


type alias RelativeUrl =
  { path : List String
  , fragment : Maybe String
  , queryString : List (String, Maybe String)
  }


parse : String -> Result String RelativeUrl
parse input =
  Parser.parse relativeUrl input


relativeUrl : Parser RelativeUrl
relativeUrl =
  RelativeUrl
    `map` path
    `and` optional (fragment |> Parser.map Just) Nothing
    `and` optional queryString []


pathUnit =
  some (satisfy (\c -> c /= '/' && c /= '#' && c /= '?'))
    |> Parser.map String.fromList


path : Parser (List String)
path =
  symbol '/' *> separatedBy pathUnit (symbol '/')


fragment : Parser String
fragment =
  let
    body =
      some (satisfy (\c -> c /= '?'))
        |> Parser.map String.fromList
  in
    symbol '#' *> body


queryString : Parser (List (String, Maybe String))
queryString =
  let
    segment =
      some (satisfy (\c -> c /= '=' && c /= '&'))
        |> Parser.map String.fromList

    queryParam =
      (,)
        `map` segment
        `and` (optional (symbol '=' *> segment |> Parser.map Just) Nothing)
  in
    symbol '?' *> separatedBy queryParam (symbol '&')
