//
//  WebServiceTests.swift
//  AlexanderPaniaguaCodeChallengeTests
//
//  Created by Alexander Paniagua on 26/10/22.
//

import XCTest
@testable import Alamofire
@testable import AlexanderPaniaguaCodeChallenge

class WebServiceTests: XCTestCase {
    
    //private var sut: WebService!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Integration test for offers endpoint
    func testGetOffers_WhenGivenSuccessfullResponse_ReturnSuccess() {
        //Arrange
        let sut = WebService()
        let expectation = self.expectation(description: "Get Offers Response expectation")
        
        //Act
        sut.performRequest(endpointUrl: WebServiceConstants.offersEndpoint, type: OffersResponseModel.self) { (offersResponseModel, succeded) in
            print(offersResponseModel!)
            //Assert
            XCTAssertTrue(succeded)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    // Unit test for offer details
    func testGetOfferDetails_WhenGivenSuccessfullResponse_ReturnSuccess() {
        
        //Arrange
        let manager: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                //configuration.httpAdditionalHeaders = [ "Content-Type": "application/json", "Accept": "application/json" ]
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
                
            }()
            return Session(configuration: configuration)
        }()
        
        let sut = WebService(sessionManager: manager)
        
        let jsonMockDataString = "{\"title\":\"OfferDetails\",\"offerDetails\":{\"offerId\":\"offer001\",\"imageUrl\":\"https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1125&h=750&q=80\",\"brand\":\"BURGUER JOINT\",\"favoriteCount\":125,\"title\":\"2 sandwiches + fries + Pepsi for EGP 69!\",\"description\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Pretium aenean pharetra magna ac placerat vestibulum lectus. Dictumst quisque sagittis purus sit amet volutpat consequat mauris. Vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt ornare. Viverra aliquet eget sit amet tellus. Sit amet justo donec enim diam vulputate ut. Vel facilisis volutpat est velit egestas dui id. A scelerisque purus semper eget. Volutpat commodo sed egestas egestas fringilla phasellus. Urna molestie at elementum eu facilisis sed. Velit ut tortor pretium viverra. Sit amet volutpat consequat mauris nunc congue. Accumsan in nisl nisi scelerisque eu. Duis at consectetur lorem donec massa sapien faucibus et.\",\"hasDiscount\":true,\"currency\":\"EGP\",\"price\":450,\"discountPrice\":300,\"startDate\":\"2022-10-21T00:00:00Z\",\"expDate\":\"2022-10-21T00:00:00Z\",\"redemptionsCap\":4}}"
        
        MockURLProtocol.responseWithStatusCodeAndData(url: "http://any.com", code: 200, data: jsonMockDataString.data(using: .utf8)!)
        
        let offerDetailsRequestModel = OfferDetailsRequestModel(offerId: "offer001")
        
        let queryString = "/\(offerDetailsRequestModel.offerId ?? "")"
        
        let expectation = self.expectation(description: "Get Offer Details Response expectation")
        
        let params = try? offerDetailsRequestModel.asDictionary()
        
        //Act
        sut.performRequest(endpointUrl: WebServiceConstants.offerDetailsEndpoint, queryString: queryString, parameters: params, httpMethod: .get, type: OfferDetailsResponseModel.self) { (offerDetailsResponseModel, succeded) in
            //Assert
            XCTAssertTrue(succeded)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
        
    }

}
