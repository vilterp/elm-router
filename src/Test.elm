module Test where

import Router exposing (..)


type Page
  = FrontPage
  | BlogPost String
  | MonthIndex Int Int -- year, month


router : Router Page
router =
  [ root FrontPage
  , route2 (\_ slug -> BlogPost slug) (literal "post") string
  , route2 (\year month -> MonthIndex year month) int int
  ]


urlFor : Page -> Path
urlFor page =
  case page of
    FrontPage ->
      "/"

    BlogPost slug ->
      "/post/" ++ slug

    MonthIndex year month ->
      "/" ++ toString year ++ "/" ++ toString month
