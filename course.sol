pragma solidity 0.5.11.;

contract LaureaCourse {
    
    address schoolWallet;
    string schoolName;
    string principalName;
    string courseName;
    string coordinatorName;
    string local;
    string startDate;
    string finishDate;
    uint256 certificateDate;
    uint256 amountOfHours;
    uint256 numberOfClasses;
    uint256 minimumAchievement;
    bool active;
    
    Student[] public students;
    Class[] public classes;
    
    struct Student {
        address studentWallet;
        string studentName;
        uint256 nationalID;
        uint256 numberOfClasses;
        //mapping (uint256 => Class[]) classList;
        bool active;
        bool laurated;
    }
    
    struct Class {
        string className;
        string professorName;
        uint256 classDate;
        uint256 classHours;
        bool active;
    }
    
    event CourseCreated(uint256 indexed courseID, string indexed courseName);
    event ClassCreated(uint256 indexed classID, string indexed className);
    event ClassOpened(uint256 indexed classID, uint256 now);
    event ClassClosed(uint256 indexed classID, uint256 now);
    event StudentCreated(uint256 indexed studentID, uint256 indexed nationalID, string indexed studentName);
    event AttendanceRegistered(uint256 indexed studentID, uint256 indexed classID, uint256 now);
    event StudentLaurated(uint256 indexed courseID, uint256 indexed nationalID, uint256 indexed studentID);
    
    constructor(string memory _schoolName, string memory _principalName ) public {
        schoolWallet = msg.sender;
        schoolName = _schoolName;
        principalName = _principalName;
        active = true;
    }
    
    function editCoursesDetails (
        string memory _courseName,
        string memory _coordinatorName,
        string memory _local,
        string memory _startDate,
        string memory _finishDate,
        uint256 _amountOfHours,
        uint256 _numberOfClasses,
        uint256 _minimumAchievement
        ) public 
    {
        require (msg.sender == schoolWallet);
        courseName = _courseName;
        coordinatorName = _coordinatorName;
        local = _local;
        startDate = _startDate;
        finishDate = _finishDate;
        amountOfHours = _amountOfHours;
        numberOfClasses = _numberOfClasses;
        minimumAchievement = _minimumAchievement;
    }
    
    function createClass (
        string memory _className,
        string memory _professorName,
        uint256 _classDate,
        uint256 _classHours
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Class memory c = Class(_className, _professorName, _classDate, _classHours, false);
        classes.push(c);
        emit ClassCreated(classes.length-1, _className);
        return true;
    }
    
    function addStudent (
        address _studentWallet,
        string memory _studentName,
        uint256 _nationalID
        ) public returns (bool)
    {
        require (msg.sender == schoolWallet);
        Student memory s = Student( _studentWallet, _studentName, _nationalID, 0, true, false);
        students.push(s);
        emit StudentCreated(students.length-1, _nationalID, _studentName);
        return true;
    }
    
    function openClass (uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        classes[classID].active = true;
        emit ClassOpened(classID, now);
        return true;
    }
    
    function closeClass (uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        classes[classID].active = false;
        emit ClassClosed(classID, now);
        return true;
    }
    
    function registerAttendance (uint256 studentID, uint256 classID) public returns(bool) {
        require (msg.sender == students[studentID].studentWallet);
        require (classes[classID].active == true);
        students[studentID].numberOfClasses ++;
        emit AttendanceRegistered(studentID, studentID, now);
        return true;
    }
    
    function registerAttendanceForAStudent (uint256 studentID, uint256 classID) public returns(bool) {
        require (msg.sender == schoolWallet);
        require (classes[classID].active == true);
        students[studentID].numberOfClasses ++;
        emit AttendanceRegistered(studentID, studentID, now);
        return true;
    }
    
    //function laurateStudents ()
    //loop certificadndo os Students com numberOfClasses >= minimumAchievement
    
}
