module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url



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


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key url, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


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
            ( { model | url = url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Alexander Goussas - Software engineer"
    , body =
        [ main_ []
            [ h1 [] [ text "Hello, I am Alexander!" ]
            , h2 [] [ text "Software engineer with more than 5 years of experience" ]
            , p [] [ text "REPLACE ME - WORK" ]
            , p [] [ text "REPLACE ME - STUDIES" ]
            , p [] [ text "REPLACE ME - HOBBIES" ]
            , nav
            ]
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


nav : Html Msg
nav =
    div [ id "navigation" ]
        [ button [ class "pseudo" ] [ a [ href "/about" ] [ text "about" ] ]
        , button [ class "pseudo" ] [ a [ href "/blog" ] [ text "blog" ] ]
        , button [ class "pseudo" ] [ a [ href "/work" ] [ text "work" ] ]
        , button [ class "pseudo" ] [ a [ href "/pics" ] [ text "photography" ] ]
        ]


contactForm : Html Msg
contactForm =
    Html.form [ id "contact-form" ]
        [ h3 [] [ text "Let's work together!" ]
        , input [ type_ "text", placeholder "Your email..." ] []
        , input [ type_ "submit", value "Send", class "pseudo" ] []
        ]
