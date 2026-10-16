//
//  TemporaryMock.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation

enum ProgrammingLenguages: String, CaseIterable, Identifiable{
    case swift = "Swift"
    case python = "Python"
    case java = "Java"
    
    var id: String {rawValue}

    /// Where the language the user picked is saved (`@AppStorage`). Every deck reads it from here.
    static let storageKey = "selectedProgrammingLanguage"
}

struct flashRapid{
    var title: String
    let codeByLenguage: [ProgrammingLenguages: String]
}


struct mockData{
    static let HELLOBEO = flashRapid (
        title: "Joder",
        codeByLenguage: [.swift: """
            func binarySearch(_ list: [Int], target: Int) -> Int? {
                var low = 0
                var high = list.count - 1
                
                while low <= high {
                    let mid = (low + high) / 2
                    if list[mid] == target { return mid }
                    if list[mid] < target { low = mid + 1 }
                    else { high = mid - 1 }
                }
                return nil
            }
            """,
                         .python :
            """
            def binary_search(lst, target):
                low, high = 0, len(lst) - 1
                
                while low <= high:
                    mid = (low + high) // 2
                    if lst[mid] == target:
                        return mid
                    elif lst[mid] < target:
                        low = mid + 1
                    else:
                        high = mid - 1
                return None
            """,
            .java:
            """
            int binarySearch(int arr[], int size, int target) {
                int low = 0, high = size - 1;
                
                while (low <= high) {
                    int mid = low + (high - low) / 2;
                    if (arr[mid] == target) return mid;
                    if (arr[mid] < target) low = mid + 1;
                    else high = mid - 1;
                }
                return -1;
            }
            """])
}




