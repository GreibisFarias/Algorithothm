//
//  MultipleChoiceMock.swift
//  Algorithothm
//
//  Mock "trace the code" exercises, one or more of each question kind.
//

import Foundation

extension MultipleChoiceExercise {

    static let all: [MultipleChoiceExercise] = [countIncreases, firstRepeated, maxSubArrayTrace, twoPointersTrace]

    // MARK: Return value

    static let countIncreases = MultipleChoiceExercise(
        id: "count-increases",
        title: "Count the increases",
        kind: .returnValue,
        scenario: "We run the function with nums = [5, 7, 6, 5, 6]",
        snippets: [
            CodeSnippet(language: .swift, code: """
            func countIncreases(_ nums: [Int]) -> Int {
                var count = 0
                for i in 1..<nums.count {
                    if nums[i] > nums[i - 1] {
                        count += 1
                    }
                }
                return count
            }
            """),
            CodeSnippet(language: .python, code: """
            def count_increases(nums):
                count = 0
                for i in range(1, len(nums)):
                    if nums[i] > nums[i - 1]:
                        count += 1
                return count
            """),
            CodeSnippet(language: .java, code: """
            public int countIncreases(int[] nums) {
                int count = 0;
                for (int i = 1; i < nums.length; i++) {
                    if (nums[i] > nums[i - 1]) {
                        count++;
                    }
                }
                return count;
            }
            """)
        ],
        question: "What will the function return?",
        answer: "2",
        wrongAnswers: ["1", "3", "4"],
        explanation: "Only 5 → 7 and 5 → 6 go up. 7 → 6 and 6 → 5 go down, so count ends at 2."
    )

    static let firstRepeated = MultipleChoiceExercise(
        id: "first-repeated",
        title: "First repeated number",
        kind: .returnValue,
        scenario: "We run the function with nums = [5, 7, 6, 5, 6]",
        snippets: [
            CodeSnippet(language: .swift, code: """
            func firstRepeated(_ nums: [Int]) -> Int? {
                var seen: Set<Int> = []
                for num in nums {
                    if seen.contains(num) {
                        return num
                    }
                    seen.insert(num)
                }
                return nil
            }
            """),
            CodeSnippet(language: .python, code: """
            def first_repeated(nums):
                seen = set()
                for num in nums:
                    if num in seen:
                        return num
                    seen.add(num)
                return None
            """),
            CodeSnippet(language: .java, code: """
            public int firstRepeated(int[] nums) {
                Set<Integer> seen = new HashSet<>();
                for (int num : nums) {
                    if (seen.contains(num)) {
                        return num;
                    }
                    seen.add(num);
                }
                return -1;
            }
            """)
        ],
        question: "What will the function return?",
        answer: "5",
        wrongAnswers: ["6", "7", "No number repeats"],
        explanation: "seen grows to {5, 7, 6}. The fourth number, 5, is already in seen, so it returns 5 before reaching the second 6."
    )

    // MARK: Variable value

    static let maxSubArrayTrace = MultipleChoiceExercise(
        id: "max-subarray-trace",
        title: "Maximum subarray (Kadane)",
        kind: .variableValue,
        scenario: "We run the function with nums = [2, -3, 4, -1, 2]",
        snippets: [
            CodeSnippet(language: .swift, code: """
            func maxSubArray(_ nums: [Int]) -> Int {
                var current = nums[0]
                var best = nums[0]
                for num in nums.dropFirst() {
                    current = max(num, current + num)
                    best = max(best, current)
                }
                return best
            }
            """),
            CodeSnippet(language: .python, code: """
            def max_sub_array(nums):
                current = nums[0]
                best = nums[0]
                for num in nums[1:]:
                    current = max(num, current + num)
                    best = max(best, current)
                return best
            """),
            CodeSnippet(language: .java, code: """
            public int maxSubArray(int[] nums) {
                int current = nums[0];
                int best = nums[0];
                for (int i = 1; i < nums.length; i++) {
                    current = Math.max(nums[i], current + nums[i]);
                    best = Math.max(best, current);
                }
                return best;
            }
            """)
        ],
        question: "What is the value of current after the second iteration of the loop?",
        answer: "4",
        wrongAnswers: ["-1", "3", "6"],
        explanation: "1st iteration: max(-3, 2 + -3) = -1. 2nd iteration: max(4, -1 + 4) = 4, starting the subarray again at 4."
    )

    // MARK: Pointer position

    static let twoPointersTrace = MultipleChoiceExercise(
        id: "two-pointers-trace",
        title: "Pair with target sum",
        kind: .pointerPosition,
        scenario: "We run the function with nums = [1, 2, 3, 5, 8, 12] and target = 11",
        snippets: [
            CodeSnippet(language: .swift, code: """
            func pairWithSum(_ nums: [Int], _ target: Int) -> [Int] {
                var left = 0
                var right = nums.count - 1
                while left < right {
                    let sum = nums[left] + nums[right]
                    if sum == target {
                        return [left, right]
                    } else if sum < target {
                        left += 1
                    } else {
                        right -= 1
                    }
                }
                return []
            }
            """),
            CodeSnippet(language: .python, code: """
            def pair_with_sum(nums, target):
                left, right = 0, len(nums) - 1
                while left < right:
                    total = nums[left] + nums[right]
                    if total == target:
                        return [left, right]
                    elif total < target:
                        left += 1
                    else:
                        right -= 1
                return []
            """),
            CodeSnippet(language: .java, code: """
            public int[] pairWithSum(int[] nums, int target) {
                int left = 0;
                int right = nums.length - 1;
                while (left < right) {
                    int sum = nums[left] + nums[right];
                    if (sum == target) {
                        return new int[] { left, right };
                    } else if (sum < target) {
                        left++;
                    } else {
                        right--;
                    }
                }
                return new int[] {};
            }
            """)
        ],
        question: "Which index is right pointing to when left reaches index 2?",
        answer: "4",
        wrongAnswers: ["2", "3", "5"],
        explanation: "1 + 12 = 13 > 11, so right moves to 4. Then 1 + 8 = 9 and 2 + 8 = 10 are too small, so left moves twice and reaches index 2 while right is still at 4."
    )
}
