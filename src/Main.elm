port module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser as P exposing ((</>), Parser, oneOf, parse, top)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias FileName =
    String


type alias BlogContents =
    String


type alias BlogPosts =
    Dict FileName BlogContents


posts : BlogPosts
posts =
    Dict.fromList
        [ ( "pwc-398-hs", "REPLACE ME - pwc-398-hs" ) ]


type Route
    = Home
    | Work
    | About
    | Blog
    | BlogPost FileName


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , route : Route
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key url (parseUrl url), maybeLoadPost (parseUrl url) )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ P.map Home top
        , P.map Home (P.s "home")
        , P.map Work (P.s "work")
        , P.map About (P.s "about")
        , P.map Blog (P.s "blog")
        , P.map BlogPost (P.s "blog" </> P.string)
        ]


parseUrl : Url.Url -> Route
parseUrl url =
    case parse routeParser url of
        Nothing ->
            Home

        Just route ->
            route


port injectBlogPost : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            let
                newRoute =
                    parseUrl url
            in
            ( { model | url = url, route = newRoute }, maybeLoadPost newRoute )


maybeLoadPost : Route -> Cmd msg
maybeLoadPost route =
    case route of
        BlogPost fileName ->
            case Dict.get fileName posts of
                Nothing ->
                    Cmd.none

                Just contents ->
                    injectBlogPost contents

        _ ->
            Cmd.none



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Alexander Goussas - Software engineer"
    , body =
        [ main_ [] (viewMain model)
        , footer []
            [ h3 [] [ text "contact me" ]
            , div []
                [ ul []
                    [ li [] [ a [ href "https://linkedin.com/in/alexander-goussas" ] [ text "LinkedIn" ] ]
                    , li [] [ a [ href "https://github.com/aloussase", title "See my repos on GitHub" ] [ text "GitHub" ] ]
                    , li [] [ a [ href "", title "I teach English and Spanish at italki" ] [ text "italki" ] ]
                    , li [] [ a [ href "https://youtube.com/@aloussase", title "Sometimes I make videos on programming and languages" ] [ text "YouTube" ] ]
                    ]
                , contactForm
                ]
            ]
        ]
    }


viewMain : Model -> List (Html Msg)
viewMain model =
    case model.route of
        Home ->
            home

        Work ->
            work

        About ->
            about

        Blog ->
            blog

        BlogPost _ ->
            viewBlogPost


home : List (Html Msg)
home =
    [ h1 [] [ text "Hello, I am Alexander!" ]
    , h2 [] [ text "Software engineer with more than 5 years of experience" ]
    , p [] [ text "REPLACE ME - WORK" ]
    , p [] [ text "REPLACE ME - STUDIES" ]
    , p [] [ text "REPLACE ME - HOBBIES" ]
    , nav
    ]


work : List (Html Msg)
work =
    [ nav
    , h1 [] [ text "My Work" ]
    , p [] [ text "I try to participate actively in OSS and my local software community. Here you'll find some of that." ]
    , h2 [] [ text "Personal projects" ]
    , ul []
        [ li [] [ text "AzuRoomie A digital solution for co-location aiming at helping students find affordable housing in the city of Cuenca, Ecuador" ]
        , li [] [ text "Gaya An interpreted programming language with a Ruby-like syntax and optimizations such as NaN-boxing" ]
        , li [] [ text "Alexandria An open source native Android app for downloading EBooks", a [ href "https://apt.izzysoft.de/fdroid/index/apk/io.github.aloussase.booksdownloader?repo=archive" ] [ text "Link" ] ]
        ]
    , h2 [] [ text "OSS contributions" ]
    , ul []
        [ li [] [ text "Added multiple dependency selection to Spring initializer site", a [ href "https://github.com/spring-io/start.spring.io/commits/main/?author=aloussase" ] [ text "Link" ] ]
        , li [] [ text "Added configuration file and semantic release for dotenv-hs", a [ href "https://github.com/stackbuilders/dotenv-hs/commits/main/?author=aloussase" ] [ text "Link" ] ]
        , li [] [ text "Maintainer of Haskell packages, from-env, wai-problem-details" ]
        , li [] [ text "... and others" ]
        ]
    , h2 [] [ text "Academic career" ]
    , ul []
        [ li [] [ text "President of open source and free software club Kokoa, ESPOL" ] ]
    , h2 [] [ text "Talks" ]
    , ul []
        [ li [] [ text "Domain Driven Design and Tagless Final at Software Freedom Day 2026" ]
        , li [] [ text "Functors demistified at FLiSoL 2023", a [ href "https://www.youtube.com/watch?v=EvCStORPTTc" ] [ text "Link" ] ]
        ]
    , h2 [] [ text "Language teacher" ]
    , ul []
        [ li [] [ text "English teacher at italki " ] ]
    ]


about : List (Html Msg)
about =
    [ nav
    , h1 [] [ text "About Me" ]
    , p [] [ text "REPLACE ME - ABOUT" ]
    , h2 [] [ text "My Interests" ]
    , ul []
        [ li [] [ text "Software architecture" ]
        , li [] [ text "Functional programming" ]
        , li [] [ text "Compilers & Interpreters" ]
        , li [] [ text "Distributed Systems" ]
        , li [] [ text "Motorcycles" ]
        , li [] [ text "Bass" ]
        , li [] [ text "Photography" ]
        , li [] [ text "Languages, both natural and computer" ]
        ]
    , h2 [] [ text "I speak:" ]
    , ul []
        [ li [] [ text "Spanish" ]
        , li [] [ text "English" ]
        , li [] [ text "French" ]
        , li [] [ text "Portuguese" ]
        , li [] [ text "German (learning)" ]
        , li [] [ text "Java" ]
        , li [] [ text "Go" ]
        , li [] [ text "Haskell" ]
        , li [] [ text "C" ]
        , li [] [ text "C++" ]
        ]
    ]


blog : List (Html Msg)
blog =
    [ nav
    , h1 [] [ text "Posts" ]
    , ul []
        [ blogPost "Nov 5 2026" "PWC 398 - Haskell" "/blog/pwc-398-hs"
        ]
    ]


blogPost : String -> String -> String -> Html Msg
blogPost date title link =
    li [ class "blog-post" ]
        [ text date, a [ href link ] [ text title ] ]


viewBlogPost : List (Html Msg)
viewBlogPost =
    [ nav, div [ id "blog-post" ] [] ]


nav : Html Msg
nav =
    div [ id "navigation" ]
        [ button [ class "pseudo" ] [ a [ href "/" ] [ text "/home" ] ]
        , button [ class "pseudo" ] [ a [ href "/about" ] [ text "/about" ] ]
        , button [ class "pseudo" ] [ a [ href "/blog" ] [ text "/blog" ] ]
        , button [ class "pseudo" ] [ a [ href "/work" ] [ text "/work" ] ]
        , button [ class "pseudo" ] [ a [ href "https://pin.it/59268OJYu", target "_blank" ] [ text "/photography" ] ]
        ]


contactForm : Html Msg
contactForm =
    Html.form [ id "contact-form" ]
        [ h3 [] [ text "Let's work together!" ]
        , input [ type_ "text", placeholder "Your email..." ] []
        , input [ type_ "submit", value "Send", class "pseudo" ] []
        ]
