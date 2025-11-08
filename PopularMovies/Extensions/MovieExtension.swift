//
//  MovieExtension.swift
//  PopularMovies
//
//  Created by Marcio Habigzang Brufatto on 08/11/25.
//

import Foundation

extension Movie {
    var overviewText: String {
        if let overview, !overview.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return overview
        } else {
            return "Sem resumo"
        }
    }
}
