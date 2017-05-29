module Example exposing (..)

import Test exposing (..)
import Expect
import Components.API as API
import Json.Decode as Json


profile_json : String
profile_json =
    """
{
  "result": "speakerprofile",
  "data": {
    "id": "2",
    "name": "Aaron Bedra",
    "data": {
      "youtube": [
        {
          "id": "13",
          "youtube_id": "CBL59w7fXw4",
          "name": "Aaron Bedra - clojure.web/with-security",
          "views": "7394",
          "likes": "0",
          "dislikes": "0"
        },
        {
          "id": "14",
          "youtube_id": "nEY3DtNwko4",
          "name": "Aaron Bedra discusses Clojure & the current state of languages on the JVM",
          "views": "1858",
          "likes": "16",
          "dislikes": "0"
        },
        {
          "id": "15",
          "youtube_id": "CGC0ajOBV_M",
          "name": "GOTO 2013 • Knock Knock: Understanding Who is Using Your Web Applications • Aaron Bedra",
          "views": "1077",
          "likes": "11",
          "dislikes": "0"
        },
        {
          "id": "16",
          "youtube_id": "2qkZyga-5zg",
          "name": "Clojure introduction with developers Aaron Bedra and Stuart Sierra",
          "views": "913",
          "likes": "3",
          "dislikes": "0"
        },
        {
          "id": "17",
          "youtube_id": "cp-Tr0ixCRM",
          "name": "\\"Deterministic Memory Management for Managed Runtimes\\" by Aaron Bedra",
          "views": "815",
          "likes": "2",
          "dislikes": "0"
        },
        {
          "id": "18",
          "youtube_id": "kcL3oawK0wk",
          "name": "GOTO 2014 • The Future of Security isn't Preventing Attacks • Aaron Bedra",
          "views": "582",
          "likes": "9",
          "dislikes": "0"
        },
        {
          "id": "19",
          "youtube_id": "zZtDOX9kXRU",
          "name": "RailsConf 2014 - Tales from the Crypt by Aaron Bedra, Justin Collins and Matt Konda",
          "views": "554",
          "likes": "13",
          "dislikes": "1"
        },
        {
          "id": "20",
          "youtube_id": "SdkKKmL-B_U",
          "name": "GOTO 2015 • Rock 'Em Sock 'Em Robots: Bot Swatting Like the Pros • Aaron Bedra",
          "views": "368",
          "likes": "7",
          "dislikes": "0"
        },
        {
          "id": "21",
          "youtube_id": "9AyaVxzqYoA",
          "name": "Behavior Based Security with Repsheet: Aaron Bedra @nginxconf 2014",
          "views": "334",
          "likes": "2",
          "dislikes": "0"
        },
        {
          "id": "22",
          "youtube_id": "wAyrdJ2qfIo",
          "name": "Unleash Your Inner Hacker",
          "views": "329",
          "likes": "1",
          "dislikes": "0"
        },
        {
          "id": "23",
          "youtube_id": "7F6g-BT3nqk",
          "name": "It starts and ends with you - Aaron Bedra (Eligible)",
          "views": "338",
          "likes": "2",
          "dislikes": "0"
        },
        {
          "id": "24",
          "youtube_id": "K0_DDxLxbvI",
          "name": "GOTO 2013 • Interview with Aaron Bedra & Michael Feathers",
          "views": "301",
          "likes": "2",
          "dislikes": "0"
        },
        {
          "id": "25",
          "youtube_id": "Nzldf081Hco",
          "name": "N. Korea Sony Hack: \\"It Doesn't Quite Add Up.\\" Cyber Security Expert Aaron Bedra W/ Brian Engelman",
          "views": "291",
          "likes": "1",
          "dislikes": "0"
        },
        {
          "id": "26",
          "youtube_id": "x0VjEoNh6Dk",
          "name": "YOW! 2015 - Aaron Bedra - Adaptive Security",
          "views": "237",
          "likes": "0",
          "dislikes": "0"
        },
        {
          "id": "27",
          "youtube_id": "bLfYF4JvfbM",
          "name": "Edward Snowden, NSA, & Spying With Information Security Professional Aaron Bedra & Brian Engelman",
          "views": "148",
          "likes": "0",
          "dislikes": "1"
        },
        {
          "id": "28",
          "youtube_id": "WU0lg6coB2g",
          "name": "Lambda Jam 2015 - Aaron Bedra - Formal Verification of Secure Software Systems",
          "views": "144",
          "likes": "3",
          "dislikes": "0"
        },
        {
          "id": "29",
          "youtube_id": "YzPpGANDvGU",
          "name": "OWASP00 Software Security Cryptography Aaron Bedra",
          "views": "132",
          "likes": "2",
          "dislikes": "0"
        },
        {
          "id": "30",
          "youtube_id": "JEZtr_C9ZdE",
          "name": "The Eligible Dream Team: Aaron Bedra, Chief Security Officer",
          "views": "121",
          "likes": "0",
          "dislikes": "0"
        },
        {
          "id": "31",
          "youtube_id": "VZe1cD6gFvI",
          "name": "Securing the Rails by Aaron Bedra fixed",
          "views": "117",
          "likes": "2",
          "dislikes": "0"
        },
        {
          "id": "32",
          "youtube_id": "AA4t3EJeNH0",
          "name": "GOTO 2014 • Interview with Aaron Bedra",
          "views": "117",
          "likes": "0",
          "dislikes": "0"
        },
        {
          "id": "33",
          "youtube_id": "pHtElgAcnK8",
          "name": "Encryption & Privacy Suggestions Discussed By Aaron Bedra & Brian Engelman",
          "views": "113",
          "likes": "2",
          "dislikes": "0"
        },
        {
          "id": "34",
          "youtube_id": "Ik1VHadfmZA",
          "name": "COIS DC06 Formal Verification of Secure Software Systems Aaron Bedra",
          "views": "93",
          "likes": "2",
          "dislikes": "0"
        },
        {
          "id": "35",
          "youtube_id": "mG27q36zPjI",
          "name": "Eligible's Security in Healthcare Event 2016",
          "views": "82",
          "likes": "1",
          "dislikes": "0"
        },
        {
          "id": "36",
          "youtube_id": "yE-aLqaQCZ8",
          "name": "Aaron and Curt - Flimsee Match.m4v",
          "views": "79",
          "likes": "0",
          "dislikes": "0"
        },
        {
          "id": "37",
          "youtube_id": "djtWGCaLFR0",
          "name": "Ruby Conference 2007 Sploitin' with Ruby (Point, Click, Root) by Aaron Bedra",
          "views": "66",
          "likes": "1",
          "dislikes": "0"
        },
        {
          "id": "38",
          "youtube_id": "1YqZMSPGo3M",
          "name": "Layered Security - Aaron Bedra, Eligible - WindyCityRails 2016",
          "views": "45",
          "likes": "0",
          "dislikes": "0"
        },
        {
          "id": "39",
          "youtube_id": "AuHFaJuO7EU",
          "name": "DevNexus 2016 - Formal Verification of Secure Software Systems - Aaron Bedra",
          "views": "31",
          "likes": "0",
          "dislikes": "0"
        },
        {
          "id": "40",
          "youtube_id": "cFmI9sqGfF4",
          "name": "Philly ETE 2015 #21 - Rock ‘Em Sock ‘Em Robots: Bot Swatting Like the Pros - Aaron Bedra",
          "views": "29",
          "likes": "0",
          "dislikes": "0"
        },
        {
          "id": "41",
          "youtube_id": "CqONMff_ZHk",
          "name": "OWASP, Nov 2016 - CSO Aaron Bedra on Data Classification",
          "views": "27",
          "likes": "1",
          "dislikes": "0"
        },
        {
          "id": "42",
          "youtube_id": "3c0RUl_paNE",
          "name": "COIS DC06 Formal Verification of Secure Software Systems Aaron Bedra",
          "views": "17",
          "likes": "1",
          "dislikes": "0"
        },
        {
          "id": "2307",
          "youtube_id": "ABXhpgBCE2o",
          "name": "Aaron Bedra",
          "views": "5",
          "likes": "0",
          "dislikes": "0"
        },
        {
          "id": "2306",
          "youtube_id": "YTtO_TGV2fU",
          "name": "GOTO 2017 • Adaptive Threat Modelling • Aaron Bedra",
          "views": "697",
          "likes": "13",
          "dislikes": "1"
        }
      ],
      "lanyrd": [
        {
          "id": "12",
          "name": "AIT Workshop 2016",
          "location": "Anguilla Anguilla",
          "date": "6th–10th November 2016"
        },
        {
          "id": "2",
          "name": "GOTO Chicago 2016",
          "location": "United States United States, Chicago",
          "date": "23rd–26th May 2016"
        },
        {
          "id": "13",
          "name": "Craft Conf 2016",
          "location": "Hungary Hungary, Budapest",
          "date": "26th–29th April 2016"
        },
        {
          "id": "14",
          "name": "YOW! Developer Conference 2015 - Sydney",
          "location": "Australia Australia, Sydney",
          "date": "10th–11th December 2015"
        },
        {
          "id": "15",
          "name": "YOW! Developer Conference 2015 - Brisbane",
          "location": "Australia Australia, South Brisbane",
          "date": "7th–8th December 2015"
        },
        {
          "id": "16",
          "name": "YOW! Developer Conference 2015 - Melbourne",
          "location": "Australia Australia, Albert Park",
          "date": "3rd–4th December 2015"
        },
        {
          "id": "3",
          "name": "GOTO Chicago 2015",
          "location": "United States United States, Chicago",
          "date": "11th–14th May 2015"
        },
        {
          "id": "17",
          "name": "Philly Emerging Technologies for the Enterprise Conference",
          "location": "United States United States, Philadelphia",
          "date": "7th–8th April 2015"
        },
        {
          "id": "18",
          "name": "nginx.conf 2014",
          "location": "United States United States, San Francisco",
          "date": "20th–22nd October 2014"
        },
        {
          "id": "19",
          "name": "AirConf",
          "location": "Online conference",
          "date": "4th–31st August 2014"
        },
        {
          "id": "20",
          "name": "DBCx",
          "location": "United States United States, Chicago",
          "date": "26th June 2014"
        },
        {
          "id": "21",
          "name": "Refactor::Chicago",
          "location": "United States United States, Chicago",
          "date": "18th June 2014"
        },
        {
          "id": "8",
          "name": "GOTO Chicago 2014",
          "location": "United States United States, Chicago",
          "date": "20th–23rd May 2014"
        },
        {
          "id": "22",
          "name": "Secure360",
          "location": "United States United States, St. Paul",
          "date": "12th–13th May 2014"
        },
        {
          "id": "23",
          "name": "Infosec Summit",
          "location": "United States United States, Columbus",
          "date": "5th–6th May 2014"
        },
        {
          "id": "24",
          "name": "RailsConf 2014",
          "location": "United States United States, Chicago",
          "date": "22nd–25th April 2014"
        },
        {
          "id": "25",
          "name": "Clojure/West 2014",
          "location": "United States United States, San Francisco",
          "date": "24th–26th March 2014"
        },
        {
          "id": "26",
          "name": "DevNexus 2014",
          "location": "United States United States, Atlanta",
          "date": "24th–25th February 2014"
        },
        {
          "id": "27",
          "name": "Functional Programming With The Stars 2013",
          "location": "Australia Australia, Brisbane",
          "date": "7th December 2013"
        },
        {
          "id": "28",
          "name": "YOW! Melbourne 2013",
          "location": "Australia Australia, Melbourne",
          "date": "3rd–6th December 2013"
        },
        {
          "id": "29",
          "name": "GOTO Aarhus 2013",
          "location": "Denmark Denmark, Arhus",
          "date": "30th September to 4th October 2013"
        },
        {
          "id": "30",
          "name": "Strange Loop 2013",
          "location": "United States United States, St. Louis City",
          "date": "18th–20th September 2013"
        },
        {
          "id": "9",
          "name": "GOTO Chicago 2013",
          "location": "United States United States, Chicago",
          "date": "23rd–26th April 2013"
        },
        {
          "id": "31",
          "name": "speakerconf 2013",
          "location": "Aruba Aruba, Aruba",
          "date": "4th–8th March 2013"
        },
        {
          "id": "32",
          "name": "YOW! Melbourne",
          "location": "Australia Australia, Melbourne",
          "date": "27th–30th November 2012"
        },
        {
          "id": "33",
          "name": "Software Craftsmanship North America 2012",
          "location": "United States United States, Chicago",
          "date": "9th–10th November 2012"
        },
        {
          "id": "34",
          "name": "Strange Loop 2012",
          "location": "United States United States, St. Louis",
          "date": "23rd–25th September 2012"
        },
        {
          "id": "35",
          "name": "speakerconf Munich 2012",
          "location": "Germany Germany, Munich",
          "date": "5th–8th August 2012"
        },
        {
          "id": "36",
          "name": "Mid Atlantic Developer Expo 2012",
          "location": "United States United States, Hampton",
          "date": "27th–29th June 2012"
        },
        {
          "id": "37",
          "name": "Future Insights Live 2012",
          "location": "United States United States, Las Vegas",
          "date": "30th April to 4th May 2012"
        },
        {
          "id": "38",
          "name": "RailsConf 2012",
          "location": "United States United States, Austin",
          "date": "23rd–25th April 2012"
        },
        {
          "id": "39",
          "name": "Clojure/West 2012",
          "location": "United States United States, San Jose",
          "date": "16th–17th March 2012"
        },
        {
          "id": "11",
          "name": "QCon San Francisco 2011",
          "location": "United States United States, San Francisco",
          "date": "14th–18th November 2011"
        },
        {
          "id": "40",
          "name": "Strange Loop 2011",
          "location": "United States United States, St. Louis",
          "date": "18th–20th September 2011"
        },
        {
          "id": "41",
          "name": "OSCON Java 2011",
          "location": "United States United States, Portland",
          "date": "25th–27th July 2011"
        },
        {
          "id": "42",
          "name": "Great Lakes Software Symposium",
          "location": "United States United States, Chicago",
          "date": "12th–14th November 2010"
        },
        {
          "id": "43",
          "name": "(first clojure-conj)",
          "location": "United States United States, Durham",
          "date": "22nd–23rd October 2010"
        },
        {
          "id": "44",
          "name": "Commercial Users of Functional Programming",
          "location": "United States United States, Baltimore",
          "date": "1st–2nd October 2010"
        },
        {
          "id": "45",
          "name": "DevNation DC",
          "location": "United States United States, Falls Church",
          "date": "28th August 2010"
        },
        {
          "id": "46",
          "name": "Palmetto Open Source Software Conference 2010",
          "location": "United States United States, Columbia",
          "date": "15th–17th April 2010"
        },
        {
          "id": "47",
          "name": "WindyCityRails 2008",
          "location": "United States United States, Chicago",
          "date": "11th September 2008"
        }
      ],
      "github": [
        {
          "id": "2",
          "name": "abedra/emacs.d",
          "language": "Emacs Lisp",
          "stargazers": 27,
          "subscribers": 5,
          "forks": 8,
          "watchers": 8,
          "from_organisation": false
        },
        {
          "id": "3",
          "name": "abedra/north_shore_ruby",
          "language": "JavaScript",
          "stargazers": 0,
          "subscribers": 1,
          "forks": 2,
          "watchers": 2,
          "from_organisation": false
        },
        {
          "id": "4",
          "name": "abedra/codemash2017",
          "language": "JavaScript",
          "stargazers": 2,
          "subscribers": 1,
          "forks": 5,
          "watchers": 5,
          "from_organisation": false
        },
        {
          "id": "5",
          "name": "abedra/fair_notebook",
          "language": "Jupyter Notebook",
          "stargazers": 3,
          "subscribers": 1,
          "forks": 0,
          "watchers": 0,
          "from_organisation": false
        },
        {
          "id": "6",
          "name": "abedra/routinator",
          "language": "Go",
          "stargazers": 5,
          "subscribers": 1,
          "forks": 1,
          "watchers": 1,
          "from_organisation": false
        },
        {
          "id": "7",
          "name": "eligible/eligible-CSharp",
          "language": "C#",
          "stargazers": 3,
          "subscribers": 11,
          "forks": 2,
          "watchers": 2,
          "from_organisation": true
        },
        {
          "id": "8",
          "name": "luca3m/redis3m",
          "language": "C++",
          "stargazers": 114,
          "subscribers": 21,
          "forks": 49,
          "watchers": 49,
          "from_organisation": false
        },
        {
          "id": "9",
          "name": "eligible/eligible-java",
          "language": "Java",
          "stargazers": 33,
          "subscribers": 15,
          "forks": 1,
          "watchers": 1,
          "from_organisation": true
        },
        {
          "id": "10",
          "name": "eligible/eligible-ruby",
          "language": "Ruby",
          "stargazers": 19,
          "subscribers": 11,
          "forks": 6,
          "watchers": 6,
          "from_organisation": true
        },
        {
          "id": "11",
          "name": "abedra/dotfiles",
          "language": "Shell",
          "stargazers": 1,
          "subscribers": 1,
          "forks": 0,
          "watchers": 0,
          "from_organisation": false
        },
        {
          "id": "12",
          "name": "repsheet/librepsheet",
          "language": "C",
          "stargazers": 7,
          "subscribers": 3,
          "forks": 6,
          "watchers": 6,
          "from_organisation": true
        }
      ]
    }
  }
}
  """


recommendations_json : String
recommendations_json =
    """
  {
  "result": "recommendations",
  "data": [
    {
      "id": "16",
      "name": "Brian Leroux",
      "total": 2,
      "sources": [
        {
          "name": "youtube",
          "rating": 3,
          "references": [
            {
              "text": "Brian LeRoux: PhoneGap: Mobile Applications with HTML, CSS, and JavaScript",
              "href": "https://www.youtube.com/watch?v=B6TfflHYmPI"
            }
          ],
          "details": []
        },
        {
          "name": "github",
          "rating": 0,
          "references": [],
          "details": []
        },
        {
          "name": "lanyrd",
          "rating": 0,
          "references": [],
          "details": []
        }
      ]
    },
    {
      "id": "92",
      "name": "Tim Gross",
      "total": 3.33,
      "sources": [
        {
          "name": "youtube",
          "rating": 5,
          "references": [
            {
              "text": "Tim Gross - J Hole",
              "href": "https://www.youtube.com/watch?v=uaJD7XNnMGs"
            }
          ],
          "details": []
        },
        {
          "name": "github",
          "rating": 0,
          "references": [],
          "details": []
        },
        {
          "name": "lanyrd",
          "rating": 0,
          "references": [],
          "details": []
        }
      ]
    },
    {
      "id": "30",
      "name": "David Giard",
      "total": 1.67,
      "sources": [
        {
          "name": "youtube",
          "rating": 0,
          "references": [
            {
              "text": "Microsoft Azure Without Microsoft - David Giard",
              "href": "https://www.youtube.com/watch?v=XLKpCgB_XnA"
            }
          ],
          "details": []
        },
        {
          "name": "github",
          "rating": 0,
          "references": [],
          "details": []
        },
        {
          "name": "lanyrd",
          "rating": 5,
          "references": [
            {
              "text": "TechBash",
              "href": "http://lanyrd.com/"
            },
            {
              "text": "DetroitDevDay",
              "href": "http://lanyrd.com/"
            },
            {
              "text": "ITCAMP 2016",
              "href": "http://lanyrd.com/"
            },
            {
              "text": "CloudDevelop",
              "href": "http://lanyrd.com/"
            },
            {
              "text": "NDC Sydney 2016",
              "href": "http://lanyrd.com/"
            }
          ],
          "details": []
        }
      ]
    }
  ]
}
"""


suite : Test
suite =
    describe "Json Decoders"
        [ describe "profile results"
            [ test "No Matches" <|
                \_ ->
                    Expect.pass
            , test "SpeakerProfile match" <|
                \_ ->
                    let
                        result =
                            Json.decodeString API.decodeSearch profile_json
                    in
                        case result of
                            Ok (API.SpeakerProfile { name }) ->
                                name |> Expect.equal "Aaron Bedra"

                            Err e ->
                                Expect.fail e

                            e ->
                                Expect.fail (toString e)
            , test "Recommendations match" <|
                \_ ->
                    let
                        result =
                            Json.decodeString API.decodeSearch recommendations_json
                    in
                        case result of
                            Ok (API.Recommendations data) ->
                                Expect.equal (List.length data) 3

                            Err e ->
                                Expect.fail e

                            e ->
                                Expect.fail (toString e)
            ]
        ]
