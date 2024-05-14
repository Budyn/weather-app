struct CoordinatesResponse {
    let latitude: Double
    let longitude: Double
}

extension CoordinatesResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
