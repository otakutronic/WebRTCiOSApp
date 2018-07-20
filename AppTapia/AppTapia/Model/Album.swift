//
//  Album.swift
//  AppTapia
//
//  Created by Andy 01/09/17.
//

import Foundation

struct Album {
  let title : String
  let artist : String
  let genre : String
  let coverUrl : String
  let year : String
}

extension Album: CustomStringConvertible {
  var description: String {
    return "title: \(title)" +
      " artist: \(artist)" +
      " genre: \(genre)" +
      " coverUrl: \(coverUrl)" +
    " year: \(year)"
  }
}

typealias AlbumData = (title: String, value: String)

extension Album {
  var tableRepresentation: [AlbumData] {
    return [
      ("Artist", artist),
      ("Album", title),
      ("Genre", genre),
      ("Year", year)
    ]
  }
}
