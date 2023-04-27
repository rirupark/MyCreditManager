//
//  main.swift
//  MyCreditManager
//
//  Created by 박민주 on 2023/04/27.
//

import Foundation

var input = "" // 입력값 초기화
let gradeStandard = [("A+", 4.5), ("A", 4.0), ("B+", 3.5), ("B", 3.0), ("C+", 2.5), ("C", 2.0), ("D+", 1.5), ("D", 1.0), ("F", 0.0)]
var students = [Student]()

// MARK: - 메뉴
while input != "X" { // 메뉴 반복 (X가 아닐 때까지)
    print("원하는 기능을 입력해주세요\n1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료") // 메뉴 문구 출력
    input = readLine()! // 입력 받기
    switch (input) { // 입력값에 따른 메뉴 반환
    case "1":
        addStudent()
    case "2":
        deleteStudent()
    case "3":
        addGrade()
    case "4":
        deleteGrade()
    case "5":
        showAverage()
    case "X":
        print("프로그램을 종료합니다...")
    default:
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
}

// MARK: - 학생추가
func addStudent() {
    print("추가할 학생의 이름을 입력해주세요")
    let inputName = readLine()! // 이름 입력 받기
    // 입력 예외 처리
    if inputName == "" { // 공백 입력했을 경우
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    } else if students.filter({$0.name == inputName}).count != 0 { // 이미 존재할 경우
        print("\(inputName)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
    } else { students.append(Student(name: inputName)) } // 학생 추가
}

// MARK: - 학생삭제
func deleteStudent() {
    print("삭제할 학생의 이름을 입력해주세요")
    let inputName = readLine()! // 이름 입력 받기
    // 입력 예외 처리
    if inputName == "" { // 공백 입력했을 경우
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    } else if students.filter({$0.name == inputName}).count != 0 { // 학생이 존재할 경우
        for _ in students { // students에 존재하는 학생의 모든 정보 삭제를 위해 전체 탐색
            if let index = students.firstIndex(where: { $0.name == inputName }) { // 인덱스 옵셔널 바인딩
                students.remove(at: index) // 해당 인덱스 삭제
            }
        }
        print("\(inputName) 학생을 삭제하였습니다.")
    } else { // 학생이 존재하지 않을 경우
        print("\(inputName) 학생을 찾지 못했습니다.")
    }
}

// MARK: - 성적추가
func addGrade() {
    print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift A+\n만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
    let inputInfo = readLine()!.split(separator:" ").map{String($0)}
    // 입력 예외 처리
    if inputInfo.isEmpty || inputInfo.count != 3 || !gradeStandard.contains(where: { $0.0 == inputInfo[2] }) {
        // 공백이거나 정보를 덜 입력했거나 성적이 이상하게 입력됐을 경우
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    } else if let index = students.firstIndex(where: { $0.name == inputInfo[0] && $0.subject == inputInfo[1] }) { // 기존에 학생이 존재하면서 과목, 성적이 존재할 경우
        students[index].grade = inputInfo[2] // 성적 갱신
    } else { // 기존에 학생과 과목이 존재하지 않을 경우
        students.append(Student(name: inputInfo[0], subject: inputInfo[1], grade: inputInfo[2]))
    }
}

// MARK: - 성적삭제
func deleteGrade() {
    print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift")
    let inputInfo = readLine()!.split(separator:" ").map{String($0)}
    // 입력 예외 처리
    if (inputInfo.isEmpty) || (inputInfo.count != 2) { // 공백이거나 정보를 덜 입력했을 경우
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    } else if let index = students.firstIndex(where: { $0.name == inputInfo[0] }) { // 기존에 학생이 존재할 경우
        students[index].grade = nil // 성적 삭제
        print("\(inputInfo[0]) 학생의 \(inputInfo[1]) 과목의 성적이 삭제되었습니다.")
    } else { // 학생이 존재하지 않을 경우
        print("\(inputInfo[0]) 학생을 찾지 못했습니다.")
    }
}

// MARK: - 평점보기
func showAverage() {
    print("평점을 알고싶은 학생의 이름을 입력해주세요")
    let inputName = readLine()!
    // 입력 예외 처리
    if inputName == "" { // 공백일 경우
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    } else if students.filter({$0.name == inputName}).count != 0 { // 학생이 존재할 경우
        let filteredStudents = students.filter({$0.name == inputName}) // 입력한 이름으로 필터링
        var sum = 0.0 // 평점 구하기 위한 합계 변수

        // students에 존재하는 학생 전체 탐색 (한 학생의 모든 과목 정보에 접근하기 위함)
        for value in filteredStudents {
            print("\(value.subject ?? "과목 미기입"): \(value.grade ?? "성적 미기입")")
            // gradeStandard에 해당하는 학점 옵셔널 바인딩
            if let tupleIndex = gradeStandard.firstIndex(where: { $0.0 == value.grade }) {
                sum += gradeStandard[tupleIndex].1 // 학점에 대한 점수 할당하여 합계 누적
            }
        }
        // 평점 구하기
        print("평점 :", removeZerosFromEnd(Double(sum) / Double(filteredStudents.count)))
    } else { // 학생이 존재하지 않을 경우
        print("\(inputName) 학생을 찾지 못했습니다.")
    }
}

// MARK: - 소수점 처리
func removeZerosFromEnd(_ number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    return String(formatter.string(from: number as NSNumber) ?? "")
}
