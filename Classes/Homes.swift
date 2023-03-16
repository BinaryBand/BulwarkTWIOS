/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Homes : Codable {
	let location : HomeLocation?
	let price : Price?
	let tags : [Tags]?
	let floorSpace : FloorSpace?
	let lotSize : FloorSpace?
	let tracking : [Tracking]?


	enum CodingKeys: String, CodingKey {

		case location = "location"
		case price = "price"
		case tags = "tags"
		case floorSpace = "floorSpace"
		case lotSize = "lotSize"
		case tracking = "tracking"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		location = try values.decodeIfPresent(HomeLocation.self, forKey: .location)
		price = try values.decodeIfPresent(Price.self, forKey: .price)
		tags = try values.decodeIfPresent([Tags].self, forKey: .tags)
		floorSpace = try values.decodeIfPresent(FloorSpace.self, forKey: .floorSpace)
		lotSize = try values.decodeIfPresent(FloorSpace.self, forKey: .lotSize)
		tracking = try values.decodeIfPresent([Tracking].self, forKey: .tracking)

	}

}
