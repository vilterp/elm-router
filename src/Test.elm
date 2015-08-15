module Test where

import Router exposing (..)


type Page
  = FrontPage
  | BlogPost String
  | MonthIndex Int Int -- year, month


router : Router page
router =
  [ root FrontPage
  , route1 (\_ slug -> BlogPost slug) (literal "post") string
  , route2 (\year month -> MonthIndex year month) int int
  ]
