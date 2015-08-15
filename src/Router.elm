module Router
    ( Router, Path
    , match
    , int, string, literal
    , root, route1, route2, route3, route4
    ) where

{-| Match URL paths, turning them into values representing the different pages
of your app.

# Match
@docs match, Router, Path

# Segments
@docs int, string, literal

# Routes
@docs root, route1, route2, route3, route4
-}

import String
import Debug

{-|-}
type alias Router a =
  List (Route a)


{-|-}
type alias Path =
  String


{-|-}
match : Router a -> Path -> Maybe a
match router path =
  let
    withoutLeadingSlash =
      case String.uncons path of
        Nothing ->
          Debug.crash "path must have leading slash"

        Just (_, without) ->
          without

  in
    case String.split "/" withoutLeadingSlash of
      [""] ->
        firstJust [] router

      segments ->
        firstJust segments router


firstJust : a -> List (a -> Maybe b) -> Maybe b
firstJust input list =
  -- is there an HOF for this?
  case list of
    [] ->
      Nothing

    (f::fs) ->
      case f input of
        Just val ->
          Just val

        Nothing ->
          firstJust input fs


-- SEGMENTS

{-|-}
type alias Segment a =
  String -> Maybe a


{-|-}
int : Segment Int
int input =
  input |> String.toInt |> Result.toMaybe


{-|-}
string : Segment String
string =
  Just


{-|-}
literal : String -> Segment String
literal expected input =
  if expected == input then
    Just expected
  else
    Nothing


-- ROUTES


{-|-}
type alias Route a =
  List String -> Maybe a


{-|-}
root : value -> Route value
root value pieces =
  case pieces of
    [] ->
      Just value

    _ ->
      Nothing


{-|-}
route1 : (a -> value) -> Segment a -> Route value
route1 fun segment pieces =
  case pieces of
    [piece] ->
      piece |> segment |> Maybe.map fun

    _ ->
      Nothing


{-|-}
route2 : (a -> b -> value) -> Segment a -> Segment b -> Route value
route2 fun segment1 segment2 pieces =
  case pieces of
    [piece1, piece2] ->
      case (segment1 piece1, segment2 piece2) of
        (Just res1, Just res2) ->
          Just (fun res1 res2)

        _ ->
          Nothing

    _ ->
      Nothing


{-|-}
route3 : (a -> b -> c -> value) -> Segment a -> Segment b -> Segment c -> Route value
route3 fun segment1 segment2 segment3 pieces =
  case pieces of
    [piece1, piece2, piece3] ->
      case (segment1 piece1, segment2 piece2, segment3 piece3) of
        (Just res1, Just res2, Just res3) ->
          Just (fun res1 res2 res3)

        _ ->
          Nothing

    _ ->
      Nothing


{-|-}
route4 : (a -> b -> c -> d -> value) -> Segment a -> Segment b -> Segment c -> Segment d -> Route value
route4 fun segment1 segment2 segment3 segment4 pieces =
  case pieces of
    [piece1, piece2, piece3, piece4] ->
      case (segment1 piece1, segment2 piece2, segment3 piece3, segment4 piece4) of
        (Just res1, Just res2, Just res3, Just res4) ->
          Just (fun res1 res2 res3 res4)

        _ ->
          Nothing

    _ ->
      Nothing


{-|-}
route5 : (a -> b -> c -> d -> e -> value) -> Segment a -> Segment b -> Segment c -> Segment d -> Segment e -> Route value
route5 fun segment1 segment2 segment3 segment4 segment5 pieces =
  case pieces of
    [piece1, piece2, piece3, piece4, piece5] ->
      case (segment1 piece1, segment2 piece2, segment3 piece3, segment4 piece4, segment5 piece5) of
        (Just res1, Just res2, Just res3, Just res4, Just res5) ->
          Just (fun res1 res2 res3 res4 res5)

        _ ->
          Nothing

    _ ->
      Nothing
