/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Location : Codable {
	let encodedPolygon : [String]?
	let locationId : Int?
	let __typename : String?

	enum CodingKeys: String, CodingKey {

		case encodedPolygon = "encodedPolygon"
		case locationId = "locationId"
		case __typename = "__typename"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		encodedPolygon = try values.decodeIfPresent([String].self, forKey: .encodedPolygon)
		locationId = try values.decodeIfPresent(Int.self, forKey: .locationId)
		__typename = try values.decodeIfPresent(String.self, forKey: .__typename)
	}

}
struct HomeLocation : Codable {
    let coordinates: Coordinates?
    let __typename : String?
    let city : String?
    let stateCode : String?
    let zipCode:String?
    let fullLocation:String?
    let partialLocation:String?

    enum CodingKeys: String, CodingKey {
        case coordinates = "coordinates"
        case city = "city"
        case stateCode = "stateCode"
        case __typename = "__typename"
        case zipCode = "zipCode"
        case fullLocation = "fullLocation"
        case partialLocation = "partialLocation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coordinates = try values.decodeIfPresent(Coordinates.self, forKey: .coordinates)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        __typename = try values.decodeIfPresent(String.self, forKey: .__typename)
        stateCode = try values.decodeIfPresent(String.self, forKey: .stateCode)
        zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
        fullLocation = try values.decodeIfPresent(String.self, forKey: .fullLocation)
        partialLocation = try values.decodeIfPresent(String.self, forKey: .partialLocation)
        
    }

}
