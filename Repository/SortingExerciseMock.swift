//
//  SortingExerciseMock.swift
//  Algorithothm
//
//  Mock loop-ordering exercises. The setup and the ending are fixed,
//  the user only orders the blocks inside the loop.
//  The body blocks are written without indentation, LoopSolution adds it.
//

import Foundation

extension SortingExercise {

    static let all: [SortingExercise] = [twoSum, reverseLinkedList, climbingStairs]

    // MARK: Two Sum

    static let twoSum = SortingExercise(
        id: "two-sum",
        title: "Two Sum",
        description: "Return the indices of the two numbers that add up to target. Order the lines inside the loop.",
        examples: [
            "twoSum([2, 7, 11, 15], 9)  → [0, 1]",
            "twoSum([3, 2, 4], 6)       → [1, 2]",
            "twoSum([3, 3], 6)          → [0, 1]"
        ],
        solutions: [
            LoopSolution(
                language: .swift,
                setup: """
                func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
                    var seen: [Int: Int] = [:]
                    for (i, num) in nums.enumerated() {
                """,
                loopBody: [
                    "let complement = target - num",
                    """
                    if let j = seen[complement] {
                        return [j, i]
                    }
                    """,
                    "seen[num] = i"
                ],
                ending: """
                    }
                    return []
                }
                """
            ),
            LoopSolution(
                language: .python,
                setup: """
                def two_sum(nums, target):
                    seen = {}
                    for i, num in enumerate(nums):
                """,
                loopBody: [
                    "complement = target - num",
                    """
                    if complement in seen:
                        return [seen[complement], i]
                    """,
                    "seen[num] = i"
                ],
                ending: """
                    return []
                """
            ),
            LoopSolution(
                language: .java,
                setup: """
                public int[] twoSum(int[] nums, int target) {
                    Map<Integer, Integer> seen = new HashMap<>();
                    for (int i = 0; i < nums.length; i++) {
                """,
                loopBody: [
                    "int complement = target - nums[i];",
                    """
                    if (seen.containsKey(complement)) {
                        return new int[] { seen.get(complement), i };
                    }
                    """,
                    "seen.put(nums[i], i);"
                ],
                ending: """
                    }
                    return new int[] {};
                }
                """
            )
        ]
    )

    // MARK: Reverse Linked List

    static let reverseLinkedList = SortingExercise(
        id: "reverse-linked-list",
        title: "Reverse Linked List",
        description: "Reverse the list by pointing every node to the previous one. Order the lines inside the loop.",
        examples: [
            "reverseList(1 → 2 → 3 → 4 → 5)  → 5 → 4 → 3 → 2 → 1",
            "reverseList(1 → 2)              → 2 → 1",
            "reverseList(nil)                → nil"
        ],
        solutions: [
            LoopSolution(
                language: .swift,
                setup: """
                func reverseList(_ head: ListNode?) -> ListNode? {
                    var previous: ListNode? = nil
                    var current = head
                    while let node = current {
                """,
                loopBody: [
                    "let next = node.next",
                    "node.next = previous",
                    "previous = node",
                    "current = next"
                ],
                ending: """
                    }
                    return previous
                }
                """
            ),
            LoopSolution(
                language: .python,
                setup: """
                def reverse_list(head):
                    previous = None
                    current = head
                    while current:
                """,
                loopBody: [
                    "next_node = current.next",
                    "current.next = previous",
                    "previous = current",
                    "current = next_node"
                ],
                ending: """
                    return previous
                """
            ),
            LoopSolution(
                language: .java,
                setup: """
                public ListNode reverseList(ListNode head) {
                    ListNode previous = null;
                    ListNode current = head;
                    while (current != null) {
                """,
                loopBody: [
                    "ListNode next = current.next;",
                    "current.next = previous;",
                    "previous = current;",
                    "current = next;"
                ],
                ending: """
                    }
                    return previous;
                }
                """
            )
        ]
    )

    // MARK: Climbing Stairs

    static let climbingStairs = SortingExercise(
        id: "climbing-stairs",
        title: "Climbing Stairs",
        description: "You can climb 1 or 2 steps at a time. Count the distinct ways to reach step n. Order the lines inside the loop.",
        examples: [
            "climbStairs(2)  → 2",
            "climbStairs(3)  → 3",
            "climbStairs(5)  → 8"
        ],
        solutions: [
            LoopSolution(
                language: .swift,
                setup: """
                func climbStairs(_ n: Int) -> Int {
                    var previous = 1
                    var current = 1
                    for _ in 1..<n {
                """,
                loopBody: [
                    "let next = previous + current",
                    "previous = current",
                    "current = next"
                ],
                ending: """
                    }
                    return current
                }
                """
            ),
            LoopSolution(
                language: .python,
                setup: """
                def climb_stairs(n):
                    previous, current = 1, 1
                    for _ in range(1, n):
                """,
                loopBody: [
                    "next_count = previous + current",
                    "previous = current",
                    "current = next_count"
                ],
                ending: """
                    return current
                """
            ),
            LoopSolution(
                language: .java,
                setup: """
                public int climbStairs(int n) {
                    int previous = 1;
                    int current = 1;
                    for (int i = 1; i < n; i++) {
                """,
                loopBody: [
                    "int next = previous + current;",
                    "previous = current;",
                    "current = next;"
                ],
                ending: """
                    }
                    return current;
                }
                """
            )
        ]
    )
}
