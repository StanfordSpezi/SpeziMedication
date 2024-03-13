//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import SpeziMedication
import XCTest


final class SpeziMedicationTests: XCTestCase {
    // swiftlint:disable:next function_body_length
    
    func testScheduleDecodingWithAndWithoutTimes() throws {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601

        // Test decoding without times
        let noTimesJSON = """
        {
            "frequency": {
                "asNeeded": true
            },
            "startDate": "2023-12-07T08:00:00Z"
        }
        """.data(using: .utf8)!
        let noTimesSchedule = try jsonDecoder.decode(Schedule.self, from: noTimesJSON)
        XCTAssertEqual(noTimesSchedule.times, nil)

        // Test decoding with times
        let withTimesJSON = """
        {
            "frequency": {
                "regularDayIntervals": 2
            },
            "startDate": "2023-12-07T08:00:00Z",
            "times": [
                {
                    "time": {
                        "hour": 8,
                        "minute": 0
                    }
                },
                {
                    "time": {
                        "hour": 15,
                        "minute": 0
                    }
                }
            ]
        }
        """.data(using: .utf8)!
        let withTimesSchedule = try jsonDecoder.decode(Schedule.self, from: withTimesJSON)
        XCTAssertNotNil(withTimesSchedule.times)
    }
    
    
    func testScheduleEncoding() throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        jsonEncoder.dateEncodingStrategy = .iso8601
        
        let asNeeded = Schedule(
            frequency: .asNeeded,
            startDate: try Calendar.current.startOfDay(for: Date("2023-12-08T00:00:00Z", strategy: .iso8601))
        )
        let asNeededJSON = try XCTUnwrap(String(data: jsonEncoder.encode(asNeeded), encoding: .utf8))
        XCTAssertEqual(
            """
            {
              "frequency" : {
                "asNeeded" : true
              },
              "startDate" : "2023-12-07T08:00:00Z"
            }
            """,
            asNeededJSON
        )
        
        let regularDayIntervals = Schedule(
            frequency: .regularDayIntervals(2),
            times: [
                ScheduledTime(time: DateComponents(hour: 8, minute: 0)),
                ScheduledTime(time: DateComponents(hour: 15, minute: 0))
            ],
            startDate: try Calendar.current.startOfDay(for: Date("2023-12-08T00:00:00Z", strategy: .iso8601))
        )
        let regularDayIntervalsJSON = try XCTUnwrap(String(data: jsonEncoder.encode(regularDayIntervals), encoding: .utf8))
        XCTAssertEqual(
            """
            {
              "frequency" : {
                "regularDayIntervals" : 2
              },
              "startDate" : "2023-12-07T08:00:00Z",
              "times" : [
                {
                  "dosage" : 1,
                  "time" : {
                    "hour" : 8,
                    "minute" : 0
                  }
                },
                {
                  "dosage" : 1,
                  "time" : {
                    "hour" : 15,
                    "minute" : 0
                  }
                }
              ]
            }
            """,
            regularDayIntervalsJSON
        )
        
        let specificDaysOfWeek = Schedule(
            frequency: .specificDaysOfWeek([.monday, .tuesday, .wednesday, .thursday, .friday]),
            times: [
                ScheduledTime(time: DateComponents(hour: 8, minute: 0)),
                ScheduledTime(time: DateComponents(hour: 15, minute: 0))
            ],
            startDate: try Calendar.current.startOfDay(for: Date("2023-12-08T00:00:00Z", strategy: .iso8601))
        )
        let specificDaysOfWeekJSON = try XCTUnwrap(String(data: jsonEncoder.encode(specificDaysOfWeek), encoding: .utf8))
        XCTAssertEqual(
            """
            {
              "frequency" : {
                "specificDaysOfWeek" : 62
              },
              "startDate" : "2023-12-07T08:00:00Z",
              "times" : [
                {
                  "dosage" : 1,
                  "time" : {
                    "hour" : 8,
                    "minute" : 0
                  }
                },
                {
                  "dosage" : 1,
                  "time" : {
                    "hour" : 15,
                    "minute" : 0
                  }
                }
              ]
            }
            """,
            specificDaysOfWeekJSON
        )
    }
}
