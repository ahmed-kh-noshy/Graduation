//
//  Urls.swift
//  BasicStructure
//
//  Created by Noshy on 04/07/2022.
//

import Foundation

struct UrlService {
    var endPoint : String = ""
    var url : String {
        return "https://7d67dd63dc90e18fce08d1f7746e9f41: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@ios-q3-mansoura.myshopify.com/admin/api/2022-01/\(endPoint)"
    }
}
