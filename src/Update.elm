module Update exposing (update)

import Regex
import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchSongs searchText ->
            ( { model | searchString = searchText } |> filterResultsOnSearch, Cmd.none )

        SelectRequester requester ->
            ( { model | selectedRequester = requester } |> filterResultsOnSearch, Cmd.none )

        TabSelected tab ->
            ( { model | selectedTab = tab, selectedRequester = "Everyone", searchedRequests = model.allRequests }, Cmd.none )

        ShowMoreStats person ->
            ( { model | modalState = Shown person }, Cmd.none )

        CloseModalStats ->
            ( { model | modalState = NotShown }, Cmd.none )


filterResultsOnSearch : Model -> Model
filterResultsOnSearch model =
    { model | searchedRequests = List.filter (\i -> matchesSearch i model.searchString model.selectedRequester) model.allRequests }


matchesSearch : SongRequest -> String -> String -> Bool
matchesSearch songRequest searchSongsText selectedRequester =
    (match searchSongsText songRequest.artistName || match searchSongsText songRequest.songName)
        && (selectedRequester == "Everyone" || match selectedRequester songRequest.requesterName)


match : String -> String -> Bool
match conatined inside =
    let
        regex =
            Maybe.withDefault Regex.never <| Regex.fromStringWith { caseInsensitive = True, multiline = False } conatined
    in
    Regex.contains regex inside
