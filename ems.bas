DECLARE SUB Login()
DECLARE SUB AdminDashboard()
DECLARE SUB EmployeeDashboard(id)
DECLARE SUB EmployeeModule()
DECLARE SUB AdminModule()
DECLARE SUB ViewEmployee()
DECLARE SUB AddEmployee()
DECLARE SUB UpdateEmployee()
DECLARE SUB DeleteEmployee()
DECLARE SUB empSalaryDetails()
DECLARE SUB adminSalaryDetails()
DECLARE SUB Delay(seconds)
DECLARE SUB viewAdmin()
DECLARE SUB addAdmin()
DECLARE SUB updateAdmin()
DECLARE SUB deleteAdmin()
DECLARE SUB profile(empID)
DECLARE SUB salaryDetails(empID)
DECLARE FUNCTION genereateIDForEmployee()
DECLARE FUNCTION genereateIDForAdmin()

CLS
CALL Login
END

' Login
SUB Login()
    CLS
    Locate 6, 15
    Color 8
    Print String$(45, "-")
    Locate 18, 15
    Color 8
    Print String$(45, "-")

    For i = 7 To 17
        Locate i, 15
        Color 8
        Print String$(1, "|")
    Next i

    For i = 7 To 17
        Locate i, 59
        Color 8
        Print String$(1, "|")
    Next i

    Color 7
    Locate 8, 35
    COLOR 2
    Print "Login"
    Color 8
    Locate 9, 16
    Print String$(43, "-")

    Color 7
    Locate 12, 20
    Input "Enter email: ", email$
    Color 7
    Locate 14, 20
    Input "Enter password: ", password$

    let error$ = ""
    IF email$ = "" OR password$ = "" THEN 
        error$ = "Invalid credintials. Please try again."
        GOTO errors
    ENDIF

    OPEN "empAuth.dat" FOR INPUT AS #1
    OPEN "adminAuth.dat" FOR INPUT AS #2

    let verified = 0
    let user$ = ""
    let id = 0
    WHILE NOT EOF(1)
        INPUT #1, userID, userEmail$, userPassword$, userRole$
        if email$ = userEmail$ AND password$ = userPassword$ THEN  
            verified = 1
            user$ = userRole$
            id = userID
        ENDIF
    WEND

    WHILE NOT EOF(2)
        INPUT #2, userID, userEmail$, userPassword$, userRole$
        if email$ = userEmail$ AND password$ = userPassword$ THEN  
            verified = 1
            user$ = userRole$
        ENDIF
    WEND
    CLOSE #1
    CLOSE #2

    IF verified = 0 THEN 
        error$ = "Invalid credintials. Please try again."
        GOTO errors
    ENDIF

    errors:
    IF error$ <> "" THEN
        Locate 17, 19
        Color 4
        Print error$
        COLOR 7
        Delay(2)
        CALL Login
    ENDIF

    IF user$ = "employee" THEN
        CALL EmployeeDashboard(id)
    ELSEIF user$ = "admin" THEN
        CALL AdminDashboard
    ENDIF 
END SUB

' -------------------------------------------------------------------

' Admin Dashboard
Sub AdminDashboard()
    CLS
    LOCATE 6, 15
    COLOR 8
    PRINT STRING$(45, "-")

    LOCATE 18, 15
    COLOR 8
    PRINT STRING$(45, "-")

    LOCATE 7, 31
    COLOR 2
    PRINT "Admin Dashboard"

    For i = 7 To 17
        Locate i, 15
        Color 8
        Print String$(1, "|")
    Next i

    For i = 7 To 17
        Locate i, 59
        Color 8
        Print String$(1, "|")
    Next i

    COLOR 7
    LOCATE 9, 17
    PRINT "1. Employees"
    LOCATE 10, 17
    PRINT "2. Admin"
    LOCATE 11, 17
    PRINT "3. Out"
    LOCATE 14, 20
    INPUT "Enter your choice: ", choice

    let error$ = ""
    SELECT CASE choice
        CASE 1
            CALL EmployeeModule
        CASE 2
            CALL AdminModule
        CASE 3
            CALL Login
        CASE ELSE
            error$ = "Invalid choice. Please try again."
    END SELECT

    IF error$ <> "" THEN
        COLOR 4
        LOCATE 17, 22
        PRINT error$
        Delay(2)
        CALL AdminDashboard
    ENDIF
End Sub

' Employee Module
Sub EmployeeModule()
    CLS
    LOCATE 6, 15
    COLOR 8
    PRINT STRING$(45, "-")

    LOCATE 19, 15
    COLOR 8
    PRINT STRING$(45, "-")

    LOCATE 7, 31
    COLOR 2
    PRINT "Employee Module"
    
    For i = 7 To 18
        Locate i, 15
        Color 8
        Print String$(1, "|")
    Next i

    For i = 7 To 18
        Locate i, 59
        Color 8
        Print String$(1, "|")
    Next i

    COLOR 7
    LOCATE 9, 17
    PRINT "1. Employee records"
    LOCATE 10, 17
    PRINT "2. Add Employee"
    LOCATE 11, 17
    PRINT "3. Update Employee"
    LOCATE 12, 17
    PRINT "4. Delete Employee"
    LOCATE 13, 17
    PRINT "5. Main Menu"
    LOCATE 16, 20
    INPUT "Enter your choice: ", empChoice

    let error$ = ""
    SELECT CASE empChoice
        CASE 1
            CALL ViewEmployee
        CASE 2
            CALL AddEmployee
        CASE 3
            CALL UpdateEmployee
        CASE 4
            CALL DeleteEmployee
        CASE 5
            CALL AdminDashboard
        CASE ELSE
            error$ = "Invalid choice. Please try again."
    END SELECT

    IF error$ <> "" THEN
        COLOR 4
        LOCATE 17, 22
        PRINT error$
        Delay(2)
        CALL EmployeeModule
    ENDIF
End Sub 

' View Employees
SUB ViewEmployee()
    CLS
    PRINT
    OPEN "employees.dat" FOR INPUT AS #1

    isData = 0
    COLOR 6
    PRINT TAB(2); "id"; TAB(8); "Name"; TAB(20); "Designation"; TAB(35); "Address"; TAB(50); "Department"
    COLOR 7
    LOCATE 3, 2
    PRINT STRING$(60, "-")
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        isData = 1
        PRINT TAB(2); id; TAB(8); name$; TAB(20); designation$; TAB(35); address$; TAB(50); department$
    WEND

    if isData = 0 then 
        COLOR 4
        LOCATE 4,18
        PRINT "No employee data found."
    ENDIF
    CLOSE #1

    COLOR 7
    PRINT
    PRINT STRING$(60, "-")
    DELAY(2)
    
    again:
    PRINT
    PRINT "1. Salary details"
    PRINT "2. Main menu"
    
    PRINT 
    PRINT
    INPUT "Enter your choice: ", choice
    PRINT

    SELECT CASE choice
        CASE 1
            CALL empSalaryDetails
        CASE 2
            CALL EmployeeModule
        CASE ELSE
            error$ = "Invalid Choice. Please try again."
            GOTO again
    END SELECT

    if error$ <> "" THEN
        COLOR 4
        PRINT error$
    ENDIF
END SUB

' Add an Employee
SUB AddEmployee()
    let id = genereateIDForEmployee

    OPEN "employees.dat" FOR APPEND AS #1
    OPEN "empAuth.dat" FOR INPUT AS #2
    OPEN "empAuth.dat" FOR APPEND AS #3
    OPEN "adminAuth.dat" FOR INPUT AS #4

    details:
    CLS
    LOCATE 3, 12
    PRINT STRING$(55, "-")

    LOCATE 18, 12
    PRINT STRING$(55, "-")

    FOR i = 4 TO 17
        LOCATE i, 12
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 4 TO 17
        LOCATE i, 66
        PRINT STRING$(1, "|")
    NEXT i

    COLOR 2
    LOCATE 5, 35
    PRINT "Add Employee"
    
    COLOR 7
    LOCATE 9, 15
    INPUT "Enter Employee Name: ", name$
    LOCATE 10, 15
    INPUT "Enter Designation: ", designation$
    LOCATE 11, 15
    INPUT "Enter Address: ", address$
    LOCATE 12, 15
    INPUT "Enter Department: ", department$
    LOCATE 13, 15
    INPUT "Enter Basic Salary: ", basicSalary

    IF name$ = "" OR designation$ = "" OR address$ = "" OR department$ = "" OR basicSalary = 0 THEN 
        PRINT "Something is missing"
        Delay(2)
        GOTO details
    ENDIF

    auth:
    CLS
    LOCATE 3, 12
    PRINT STRING$(55, "-")

    LOCATE 18, 12
    PRINT STRING$(55, "-")

    FOR i = 4 TO 17
        LOCATE i, 12
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 4 TO 17
        LOCATE i, 66
        PRINT STRING$(1, "|")
    NEXT i

    COLOR 2
    LOCATE 5, 35
    PRINT "Add Employee"

    COLOR 7
    LOCATE 9, 15
    INPUT "Enter email: ", email$
    WHILE NOT EOF(2)
        INPUT #2, userID, userEmail$, userPassword$, userRole$
        if userEmail$ = email$ Then 
            LOCATE 13, 15
            PRINT "Email already exists."
            CALL Delay(2)
            GOTO auth
        ENDIF
    WEND

    WHILE NOT EOF(4)
        INPUT #4, userID, userEmail$, userPassword$, userRole$
        if userEmail$ = email$ Then 
            LOCATE 13, 15
            PRINT "Email already exists."
            CALL Delay(2)
            GOTO auth
        ENDIF
    WEND

    LOCATE 11, 15
    INPUT "Enter password: ", password$
    if len(password$) < 6 then 
        LOCATE 13, 15
        PRINT "Password must be at least 6 characters long."
        CALL Delay(2)
        GOTO auth
    ENDIF

    IF email$ = "" OR password$ = "" THEN GOTO auth

    HRA = 0.2 * basicSalary
    MA = 0.15 * basicSalary
    totalSalary = basicSalary + HRA + MA
    monthlyTax = 0

    if (totalSalary * 12) <= 500000 THEN
        monthlyTax = (0.01 * (totalSalary * 12))/12
    ELSE
        monthlyTax = (0.13 * (totalSalary * 12))/12
    ENDIF

    netSalary = totalSalary - monthlyTax

    WRITE #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
    WRITE #3, id, email$, password$, "employee"

    CLOSE #1
    CLOSE #2
    CLOSE #3
    CLOSE #4

    LOCATE 13, 15
    PRINT "Employee added successfully with ID: "; id
    CALL Delay(2)

    LOCATE 15, 20
    INPUT "repeat add another employee? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL AddEmployee
    ELSE
        CALL EmployeeModule
    END IF
END SUB

' Update Employee
SUB UpdateEmployee()
    OPEN "employees.dat" FOR INPUT AS #1
    OPEN "temp.dat" FOR OUTPUT AS #2

    CLS
    LOCATE 3, 12
    PRINT STRING$(55, "-")

    LOCATE 7, 12
    PRINT STRING$(55, "-")

    FOR i = 4 TO 6
        LOCATE i, 12
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 4 TO 6
        LOCATE i, 66
        PRINT STRING$(1, "|")
    NEXT i

    LOCATE 5, 17
    INPUT "Enter Employee ID to update: ", empID
    found = 0

    LOCATE 9, 1
    COLOR 6
    PRINT TAB(2); "id"; TAB(8); "Name"; TAB(17); "Designation"; TAB(32); "Address"; TAB(47); "Department"; TAB(62); "Basic Salary"

    COLOR 7
    LOCATE 10, 3
    PRINT STRING$(70, "-")

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id = empID THEN
            found = 1
            PRINT TAB(2); id; TAB(8); name$; TAB(17); designation$; TAB(32); address$; TAB(47); department$; TAB(62); basicSalary
            
            PRINT TAB(2); STRING$(70, "-")
            PRINT
            PRINT
            PRINT TAB(4);
            DELAY(3)

            INPUT "Confirm employee update (y/n): ", answer$
            IF answer$ = "Y" OR answer$ = "y" THEN 
                CLS
                LOCATE 3, 13
                PRINT STRING$(53, "-")

                ' Update Name
                LOCATE 4, 15
                COLOR 3
                INPUT "Do you want to update name? (y/n): ", ans$
                COLOR  7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 5, 15
                    INPUT "Enter new name: ", name$
                END IF
                LOCATE 7, 13
                PRINT STRING$(53, "-")

                ' Update Designation
                LOCATE 8, 15
                COLOR 3
                INPUT "Do you want to update designation? (y/n): ", ans$
                COLOR 7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 9, 15
                    INPUT "Enter new designation: ", designation$
                END IF
                LOCATE 11, 13
                PRINT STRING$(53, "-")

                ' Update Address
                LOCATE 12, 15
                COLOR 3
                INPUT "Do you want to update address? (y/n): ", ans$
                COLOR 7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 13, 15
                    INPUT "Enter new address: ", address$
                END IF
                LOCATE 15, 13
                PRINT STRING$(53, "-")

                ' Update Department
                LOCATE 16, 15
                COLOR 3
                INPUT "Do you want to update department? (y/n): ", ans$
                COLOR 7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 17, 15
                    INPUT "Enter new department: ", department$
                END IF
                LOCATE 19, 13
                PRINT STRING$(53, "-")

                ' Update Basic Salary
                LOCATE 20, 15
                COLOR 3
                INPUT "Do you want to update basic salary? (y/n): ", ans$
                COLOR 7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 21, 15
                    INPUT "Enter new basic salary: ", basicSalary

                    HRA = 0.2 * basicSalary
                    MA = 0.15 * basicSalary
                    totalSalary = basicSalary + HRA + MA
                    monthlyTax = 0

                    if (totalSalary * 12) <= 500000 THEN
                        monthlyTax = (0.01 * (totalSalary * 12))/12
                    ELSE
                        monthlyTax = (0.13 * (totalSalary * 12))/12
                    ENDIF
                    netSalary = totalSalary - monthlyTax
                END IF
                LOCATE 23, 13
                PRINT STRING$(53, "-")

                ' Update employee authentication data
                CLS
                LOCATE 3, 13
                PRINT STRING$(53, "-")

                LOCATE 15, 13
                PRINT STRING$(53, "-")

                FOR i = 4 TO 14
                    LOCATE i, 13
                    PRINT STRING$(1, "|")
                NEXT i

                FOR i = 4 TO 14
                    LOCATE i, 65
                    PRINT STRING$(1, "|")
                NEXT i

                LOCATE 4, 15
                COLOR 3
                INPUT "Do you want to update authentication data? (y/n): ", ans$
                COLOR 6

                IF ans$ = "y" OR ans$ = "Y" THEN
                    OPEN "empAuth.dat" FOR INPUT AS #3
                    OPEN "auth-temp.dat" FOR OUTPUT AS #4

                    WHILE NOT EOF(3)
                        INPUT #3, userID, userEmail$, userPassword$, userRole$
                        IF userID = empID THEN
                            ' Update email
                            LOCATE 6, 15
                            INPUT "Do you want to update email? (y/n): ", rep$
                            COLOR 7
                            IF LCASE$(rep$) = "y" THEN 
                                LOCATE 8, 15
                                INPUT "Enter new email: ", newEmail$
                            ELSE
                                newEmail$ = userEmail$
                            ENDIF

                            WRITE #4, userID, newEmail$, userPassword$, userRole$
                        ELSE
                            WRITE #4, userID, userEmail$, userPassword$, userRole$
                        END IF
                    WEND
                    CLOSE #3
                    CLOSE #4
                    KILL "empAuth.dat"
                    NAME "auth-temp.dat" AS "empAuth.dat"
                    LOCATE 11, 15
                    COLOR 2
                    PRINT "Employee details updated successfully."
                ENDIF

                WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
                LOCATE 11, 15
                COLOR 2
                PRINT "Employee details updated successfully."
            ELSE
                WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
            ENDIF
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        ENDIF
    WEND

    IF found = 0 THEN LOCATE 8, 15: PRINT "Employee ID not found."
    CLOSE #1
    CLOSE #2
    KILL "employees.dat"
    NAME "temp.dat" AS "employees.dat"

    COLOR 7
    LOCATE 19, 11
    PRINT STRING$(45, "-")

    LOCATE 23, 11
    PRINT STRING$(45, "-")

    FOR i = 20 TO 22
        LOCATE i, 11
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 20 TO 22
        LOCATE i, 55
        PRINT STRING$(1, "|")
    NEXT i

    LOCATE 21, 15
    INPUT "Update another employee? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL UpdateEmployee
    ELSE
        CALL EmployeeModule
    END IF
END SUB

' Delete Employee
SUB DeleteEmployee()
    OPEN "employees.dat" FOR INPUT AS #1
    OPEN "temp.dat" FOR OUTPUT AS #2
    OPEN "empAuth.dat" FOR INPUT AS #3
    OPEN "auth-temp.dat" FOR OUTPUT AS #4

    CLS
    LOCATE 3, 12
    PRINT STRING$(55, "-")

    LOCATE 7, 12
    PRINT STRING$(55, "-")

    FOR i = 4 TO 6
        LOCATE i, 12
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 4 TO 6
        LOCATE i, 66
        PRINT STRING$(1, "|")
    NEXT i

    LOCATE 5, 17
    INPUT "Enter Employee ID to delete: ", empID
    found = 0

    LOCATE 9, 1
    COLOR 6
    PRINT TAB(2); "id"; TAB(8); "Name"; TAB(17); "Designation"; TAB(32); "Address"; TAB(47); "Department"; TAB(62); "Basic Salary"

    COLOR 7
    LOCATE 10, 3
    PRINT STRING$(70, "-")

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id = empID THEN
            found = 1
            PRINT TAB(2); id; TAB(8); name$; TAB(15); designation$; TAB(30); address$; TAB(45); department$; TAB(60); basicSalary
            LOCATE 15, 10
            INPUT "Are you sure you want to delete this employee? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                ' Delete from authentication data
                WHILE NOT EOF(3)
                    INPUT #3, authID, userEmail$, userPassword$, role$
                    IF authID <> empID THEN
                        WRITE #4, authID, userEmail$, userPassword$, role$
                    END IF
                WEND
                COLOR 2
                LOCATE 17, 25
                PRINT "Employee deleted successfully."
            ELSE
                WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
            END IF
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        ENDIF
    WEND

    COLOR 4
    LOCATE 11, 27
    IF found = 0 THEN PRINT "Employee ID not found."
    CLOSE #1
    CLOSE #2
    CLOSE #3
    CLOSE #4
    KILL "empAuth.dat"
    KILL "employees.dat"
    NAME "temp.dat" AS "employees.dat"
    NAME "auth-temp.dat" AS "empAuth.dat"

    COLOR 7
    LOCATE 19, 11
    PRINT STRING$(45, "-")

    LOCATE 23, 11
    PRINT STRING$(45, "-")

    FOR i = 20 TO 22
        LOCATE i, 11
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 20 TO 22
        LOCATE i, 55
        PRINT STRING$(1, "|")
    NEXT i

    LOCATE 21, 15
    INPUT "Delete another employee? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL DeleteEmployee
    ELSE
        CALL EmployeeModule
    END IF
END SUB

' Create Salary details for Employee
SUB empSalaryDetails()
    CLS
    PRINT
    OPEN "employees.dat" FOR INPUT AS #1

    isData = 0
    COLOR 6
    PRINT TAB(2); "id"; TAB(8); "Basic Salary"; TAB(23); "Total Salary"; TAB(38); "Monthly Salary"; TAB(55); "Net Salary"
    COLOR 7
    LOCATE 3, 2
    PRINT STRING$(60, "-")

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        isData = 1
        PRINT TAB(2); id; TAB(8); basicSalary; TAB(23); totalSalary; TAB(38); monthlyTax; TAB(55); netSalary
    WEND
    
    if isData = 0 then 
        COLOR 4
        LOCATE 4,18
        PRINT "No employee data found."
    ENDIF
    CLOSE #1

    COLOR 7
    PRINT
    PRINT STRING$(60, "-")
    DELAY(2)

    ' Main Menu
    INPUT "Main Menu (y/n): ", ans$
    If ans$ = "Y" OR ans$ = "y" THEN 
        CALL ViewEmployee
    ELSE
        CALL empSalaryDetails
    ENDIF
END SUB

' Generate id for employee
FUNCTIOn genereateIDForEmployee()
    OPEN "employees.dat" FOR INPUT AS #1
    maxID = 0
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id > maxID THEN
            maxID = id
        END IF
    WEND
    CLOSE #1
    genereateIDForEmployee = maxID + 1
END FUNCTION

' Delay
SUB Delay(seconds)
    start = TIMER
    DO WHILE TIMER - start < seconds
        ' Do nothing - just wait
    LOOP
END SUB

' -------------------------------------------------------------------

' Admin Module
Sub AdminModule()
    CLS
    LOCATE 6, 15
    COLOR 8
    PRINT STRING$(45, "-")

    LOCATE 19, 15
    COLOR 8
    PRINT STRING$(45, "-")

    LOCATE 7, 31
    COLOR 2
    PRINT "Admin Module"
    
    For i = 7 To 18
        Locate i, 15
        Color 8
        Print String$(1, "|")
    Next i

    For i = 7 To 18
        Locate i, 59
        Color 8
        Print String$(1, "|")
    Next i

    COLOR 7
    LOCATE 9, 17
    PRINT "1. Admin records"
    LOCATE 10, 17
    PRINT "2. Add Admin"
    LOCATE 11, 17
    PRINT "3. Update Admin"
    LOCATE 12, 17
    PRINT "4. Delete Admin"
    LOCATE 13, 17
    PRINT "5. Main Menu"
    LOCATE 16, 20
    INPUT "Enter your choice: ", adminChoice

    let error$ = ""
    SELECT CASE adminChoice
        CASE 1
            CALL viewAdmin
        CASE 2
            CALL addAdmin
        CASE 3
            CALL updateAdmin
        CASE 4
            CALL deleteAdmin
        CASE 5
            CALL AdminDashboard
        CASE ELSE
            error$ = "Invalid choice. Please try again."
    END SELECT

    IF error$ <> "" THEN
        COLOR 4
        LOCATE 17, 22
        PRINT error$
        Delay(2)
        CALL AdminModule
    ENDIF
End Sub

' View Admin
SUB viewAdmin()
    CLS
    PRINT
    OPEN "admin.dat" FOR INPUT AS #1

    isData = 0 
    COLOR 6
    PRINT TAB(2); "id"; TAB(8); "Name"; TAB(20); "Designation"; TAB(35); "Address"; TAB(50); "Department"
    COLOR 7
    LOCATE 3, 2
    PRINT STRING$(60, "-")
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        isData = 1
        PRINT TAB(2); id; TAB(8); name$; TAB(20); designation$; TAB(35); address$; TAB(50); department$
    WEND

    if isData = 0 then 
        COLOR 4
        LOCATE 4,18
        PRINT "No admin data found."
    ENDIF
    CLOSE #1

    COlOR 7
    PRINT
    PRINT STRING$(60, "-")
    DELAY(2)
    
    again:
    PRINT
    PRINT "1. Salary details"
    PRINT "2. Main menu"
    
    PRINT 
    PRINT
    INPUT "Enter your choice: ", choice
    PRINT

    SELECT CASE choice
        CASE 1
            CALL adminSalaryDetails
        CASE 2
            CALL AdminModule
        CASE ELSE
            error$ = "Invalid Choice. Please try again."
            GOTO again
    END SELECT

    if error$ <> "" THEN
        COLOR 4
        PRINT error$
    ENDIF
END SUB

' Add Admin
SUB addAdmin()
    let id = genereateIDForAdmin
    OPEN "admin.dat" FOR APPEND AS #1
    OPEN "adminAuth.dat" FOR INPUT AS #2
    OPEN "adminAuth.dat" FOR APPEND AS #3
    OPEN "empAuth.dat" FOR INPUT AS #4

    details:
    CLS
    LOCATE 3, 12
    PRINT STRING$(55, "-")

    LOCATE 18, 12
    PRINT STRING$(55, "-")

    FOR i = 4 TO 17
        LOCATE i, 12
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 4 TO 17
        LOCATE i, 66
        PRINT STRING$(1, "|")
    NEXT i

    COLOR 2
    LOCATE 5, 35
    PRINT "Add Admin"
    
    COLOR 7
    LOCATE 9, 15
    INPUT "Enter Admin Name: ", name$
    LOCATE 10, 15
    INPUT "Enter Designation: ", designation$
    LOCATE 11, 15
    INPUT "Enter Address: ", address$
    LOCATE 12, 15
    INPUT "Enter Department: ", department$
    LOCATE 13, 15
    INPUT "Enter Basic Salary: ", basicSalary

    IF name$ = "" OR designation$ = "" OR address$ = "" OR department$ = "" OR basicSalary = 0 THEN 
        PRINT "Something is missing"
        Delay(2)
        GOTO details
    ENDIF

    auth:
    CLS
    LOCATE 3, 12
    PRINT STRING$(55, "-")

    LOCATE 18, 12
    PRINT STRING$(55, "-")

    FOR i = 4 TO 17
        LOCATE i, 12
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 4 TO 17
        LOCATE i, 66
        PRINT STRING$(1, "|")
    NEXT i

    COLOR 2
    LOCATE 5, 35
    PRINT "Add Admin"

   COLOR 7
    LOCATE 9, 15
    INPUT "Enter email: ", email$
    WHILE NOT EOF(2)
        INPUT #2, userID, userEmail$, userPassword$, userRole$
        if userEmail$ = email$ Then 
            LOCATE 13, 15
            PRINT "Email already exists."
            CALL Delay(2)
            GOTO auth
        ENDIF
    WEND

    WHILE NOT EOF(4)
        INPUT #4, userID, userEmail$, userPassword$, userRole$
        if userEmail$ = email$ Then 
            LOCATE 13, 15
            PRINT "Email already exists."
            CALL Delay(2)
            GOTO auth
        ENDIF
    WEND

    LOCATE 11, 15
    INPUT "Enter password: ", password$
    if len(password$) < 6 then 
        LOCATE 13, 15
        PRINT "Password must be at least 6 characters long."
        CALL Delay(2)
        GOTO auth
    ENDIF

    IF email$ = "" OR password$ = "" THEN GOTO auth

    HRA = 0.2 * basicSalary
    MA = 0.15 * basicSalary
    totalSalary = basicSalary + HRA + MA
    monthlyTax = 0

    if (totalSalary * 12) <= 500000 THEN
        monthlyTax = (0.01 * (totalSalary * 12))/12
    ELSE
        monthlyTax = (0.13 * (totalSalary * 12))/12
    ENDIF
    netSalary = totalSalary - monthlyTax

    WRITE #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
    WRITE #3, id, email$, password$, "admin"

    CLOSE #1
    CLOSE #2   
    CLOSE #3
    CLOSE #4

    LOCATE 13, 15
    PRINT "Admin added successfully with ID: "; id
    CALL Delay(2)

    LOCATE 15, 20
    INPUT "repeat add another admin? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL addAdmin
    ELSE
        CALL AdminModule
    END IF
END SUB

' Update Admin
SUB updateAdmin()
    OPEN "admin.dat" FOR INPUT AS #1
    OPEN "temp.dat" FOR OUTPUT AS #2

    CLS
    LOCATE 3, 12
    PRINT STRING$(55, "-")

    LOCATE 7, 12
    PRINT STRING$(55, "-")

    FOR i = 4 TO 6
        LOCATE i, 12
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 4 TO 6
        LOCATE i, 66
        PRINT STRING$(1, "|")
    NEXT i

    LOCATE 5, 17
    INPUT "Enter Employee ID to update: ", adminID
    found = 0

    LOCATE 9, 1
    COLOR 6
    PRINT TAB(2); "id"; TAB(8); "Name"; TAB(17); "Designation"; TAB(32); "Address"; TAB(47); "Department"; TAB(62); "Basic Salary"

    COLOR 7
    LOCATE 10, 3
    PRINT STRING$(70, "-")

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id = adminID THEN
            PRINT TAB(2); id; TAB(8); name$; TAB(17); designation$; TAB(32); address$; TAB(47); department$; TAB(62); basicSalary
            PRINT TAB(2); STRING$(70, "-")
            PRINT
            PRINT
            PRINT TAB(4);
            DELAY(3)
            found = 1

            INPUT "Confirm employee update (y/n): ", answer$
            IF answer$ = "y" OR answer$ = "Y" THEN
                CLS
                LOCATE 3, 13
                PRINT STRING$(53, "-")

                ' Update Name
                LOCATE 4, 15
                COLOR 3
                INPUT "Do you want to update name? (y/n): ", ans$
                COLOR  7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 5, 15
                    INPUT "Enter new name: ", name$
                END IF
                LOCATE 7, 13
                PRINT STRING$(53, "-")

                ' Update Designation
                LOCATE 8, 15
                COLOR 3
                INPUT "Do you want to update designation? (y/n): ", ans$
                COLOR 7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 9, 15
                    INPUT "Enter new designation: ", designation$
                END IF
                LOCATE 11, 13
                PRINT STRING$(53, "-")

                ' Update Address
                LOCATE 12, 15
                COLOR 3
                INPUT "Do you want to update address? (y/n): ", ans$
                COLOR 7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 13, 15
                    INPUT "Enter new address: ", address$
                END IF
                LOCATE 15, 13
                PRINT STRING$(53, "-")

                ' Update Department
                LOCATE 16, 15
                COLOR 3
                INPUT "Do you want to update department? (y/n): ", ans$
                COLOR 7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 17, 15
                    INPUT "Enter new department: ", department$
                END IF
                LOCATE 19, 13
                PRINT STRING$(53, "-")

                ' Update Basic Salary
                LOCATE 20, 15
                COLOR 3
                INPUT "Do you want to update basic salary? (y/n): ", ans$
                COLOR 7
                IF ans$ = "y" OR ans$ = "Y" THEN
                    LOCATE 21, 15
                    INPUT "Enter new basic salary: ", basicSalary

                    HRA = 0.2 * basicSalary
                    MA = 0.15 * basicSalary
                    totalSalary = basicSalary + HRA + MA
                    monthlyTax = 0

                    if (totalSalary * 12) <= 500000 THEN
                        monthlyTax = (0.01 * (totalSalary * 12))/12
                    ELSE
                        monthlyTax = (0.13 * (totalSalary * 12))/12
                    ENDIF
                    netSalary = totalSalary - monthlyTax
                END IF
                LOCATE 23, 13
                PRINT STRING$(53, "-")

                ' Update admin authentication data
                CLS
                LOCATE 3, 13
                PRINT STRING$(53, "-")

                LOCATE 15, 13
                PRINT STRING$(53, "-")

                FOR i = 4 TO 14
                    LOCATE i, 13
                    PRINT STRING$(1, "|")
                NEXT i

                FOR i = 4 TO 14
                    LOCATE i, 65
                    PRINT STRING$(1, "|")
                NEXT i

                LOCATE 4, 15
                COLOR 3
                INPUT "Do you want to update auth data? (y/n): ", ans$
                COLOR 6
                IF ans$ = "y" OR ans$ = "Y" THEN
                    OPEN "adminAuth.dat" FOR INPUT AS #3
                    OPEN "auth-temp.dat" FOR OUTPUT AS #4

                    WHILE NOT EOF(3)
                        INPUT #3, userID, userEmail$, userPassword$, userRole$
                        IF userID = adminID THEN
                            ' Update email
                            LOCATE 6, 15
                            INPUT "Do you want to update email? (y/n): ", rep$
                            COLOR 7

                            IF LCASE$(rep$) = "y" THEN 
                                LOCATE 8, 15
                                INPUT "Enter new email: ", newEmail$
                            ELSE
                                newEmail$ = userEmail$
                            ENDIF

                            WRITE #4, userID, newEmail$, userPassword$, userRole$
                        ELSE
                            WRITE #4, userID, userEmail$, userPassword$, userRole$
                        END IF
                    WEND

                    CLOSE #3
                    CLOSE #4
                    KILL "adminAuth.dat"
                    NAME "auth-temp.dat" AS "adminAuth.dat"
                ENDIF

                WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
                LOCATE 11, 15
                COLOR 2
                PRINT "Admin details updated successfully."
            ELSE
                WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
            ENDIF
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        ENDIF
    WEND

    IF found = 0 THEN 
        LOCATE 8, 15
        COLOR 4
        PRINT "Admin ID not found."
    ENDIF

    CLOSE #1
    CLOSE #2
    KILL "admin.dat"
    NAME "temp.dat" AS "admin.dat"

    COLOR 7
    LOCATE 19, 11
    PRINT STRING$(45, "-")

    LOCATE 23, 11
    PRINT STRING$(45, "-")

    FOR i = 20 TO 22
        LOCATE i, 11
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 20 TO 22
        LOCATE i, 55
        PRINT STRING$(1, "|")
    NEXT i

    LOCATE 21, 15
    INPUT "Update another admin? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL UpdateAdmin
    ELSE
        CALL AdminModule
    END IF
END SUB

' Delete Admin
SUB deleteAdmin()
    CLS
    PRINT "Deleting Admin..."
    OPEN "admin.dat" FOR INPUT AS #1
    OPEN "temp.dat" FOR OUTPUT AS #2
    OPEN "adminAuth.dat" FOR INPUT AS #3
    OPEN "auth-temp.dat" FOR OUTPUT AS #4

        CLS
    LOCATE 3, 12
    PRINT STRING$(55, "-")

    LOCATE 7, 12
    PRINT STRING$(55, "-")

    FOR i = 4 TO 6
        LOCATE i, 12
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 4 TO 6
        LOCATE i, 66
        PRINT STRING$(1, "|")
    NEXT i

    LOCATE 5, 17
    INPUT "Enter Admin ID to delete: ", adminID
    found = 0

    LOCATE 9, 1
    COLOR 6
    PRINT TAB(2); "id"; TAB(8); "Name"; TAB(17); "Designation"; TAB(32); "Address"; TAB(47); "Department"; TAB(62); "Basic Salary"

    COLOR 7
    LOCATE 10, 3
    PRINT STRING$(70, "-")
    found = 0
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id = adminID THEN
            found = 1
            PRINT TAB(2); id; TAB(8); name$; TAB(15); designation$; TAB(30); address$; TAB(45); department$; TAB(60); basicSalary
            LOCATE 15, 10
            INPUT "Are you sure you want to delete this admin? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                ' Delete from authentication data
                WHILE NOT EOF(3)
                    INPUT #3, authID, userEmail$, userPassword$, role$
                    IF authID <> adminID THEN
                        WRITE #4, authID, userEmail$, userPassword$, role$
                    END IF
                WEND

                COLOR 2
                LOCATE 17, 25
                PRINT "Admin deleted successfully."
            ELSE
                WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
            END IF
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        ENDIF
    WEND

    COLOR 4
    LOCATE 11, 27
    IF found = 0 THEN PRINT "Admin ID not found."
    CLOSE #1
    CLOSE #2
    CLOSE #3
    CLOSE #4

    KILL "admin.dat"
    KILL "adminAuth.dat"
    NAME "temp.dat" AS "admin.dat"
    NAME "auth-temp.dat" AS "adminAuth.dat"

    COLOR 7
    LOCATE 19, 11
    PRINT STRING$(45, "-")

    LOCATE 23, 11
    PRINT STRING$(45, "-")

    FOR i = 20 TO 22
        LOCATE i, 11
        PRINT STRING$(1, "|")
    NEXT i

    FOR i = 20 TO 22
        LOCATE i, 55
        PRINT STRING$(1, "|")
    NEXT i

    LOCATE 21, 15
    INPUT "Delete another admin? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL deleteAdmin
    ELSE
        CALL AdminModule
    END IF
END SUB

' Create Salary details for Employee
SUB adminSalaryDetails()
    CLS
    PRINT
    OPEN "admin.dat" FOR INPUT AS #1

    isData = 0
    COLOR 6
    PRINT TAB(2); "id"; TAB(8); "Basic Salary"; TAB(23); "Total Salary"; TAB(38); "Monthly Salary"; TAB(55); "Net Salary"
    COLOR 7
    LOCATE 3, 2
    PRINT STRING$(60, "-")

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        isData = 1
        PRINT TAB(2); id; TAB(8); basicSalary; TAB(23); totalSalary; TAB(38); monthlyTax; TAB(55); netSalary
    WEND
    
    if isData = 0 then 
        COLOR 4
        LOCATE 4,18
        PRINT "No admin data found."
    ENDIF
    CLOSE #1

    COLOR 7
    PRINT
    PRINT STRING$(60, "-")
    DELAY(2)

    ' Main Menu
    INPUT "Main Menu (y/n): ", ans$
    If ans$ = "Y" OR ans$ = "y" THEN 
        CALL ViewAdmin
    ELSE
        CALL adminSalaryDetails
    ENDIF
END SUB

' Generate id for admin
FUNCTIOn genereateIDForAdmin()
    OPEN "admin.dat" FOR INPUT AS #1
    maxID = 0
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id > maxID THEN
            maxID = id
        END IF
    WEND
    CLOSE #1
    genereateIDForAdmin = maxID + 1
END FUNCTION

' -------------------------------------------------------------------

' Employee Dashboard
Sub EmployeeDashboard(id)
    CLS
    LOCATE 6, 15
    COLOR 8
    PRINT STRING$(45, "-")

    LOCATE 18, 15
    COLOR 8
    PRINT STRING$(45, "-")

    LOCATE 7, 31
    COLOR 2
    PRINT "Employee Dashboard"

    For i = 7 To 17
        Locate i, 15
        Color 8
        Print String$(1, "|")
    Next i

    For i = 7 To 17
        Locate i, 59
        Color 8
        Print String$(1, "|")
    Next i

    COLOR 7
    LOCATE 9, 17
    PRINT "1. View Salary details"
    LOCATE 10, 17
    PRINT "2. Profile"
    LOCATE 11, 17
    PRINT "3. Out"
    LOCATE 14, 20
    INPUT "Enter your choice: ", choice

    let error$ = ""
    SELECT CASE choice
        CASE 1
            CALL salaryDetails(id)
        CASE 2
            CALL Profile(id)
        CASE 3
            CALL Login
        CASE ELSE
            error$ = "Invalid choice. Please try again."
    END SELECT

    IF error$ <> "" THEN
        COLOR 4
        LOCATE 17, 22
        PRINT error$
        Delay(2)
        CALL EmployeeDashboard(id)
    ENDIF
End Sub

' Employee Profile
SUB Profile(empID)
    CLS
    PRINT "====================================="
    PRINT "           PROFILE SECTION           "
    PRINT "====================================="
    OPEN "employees.dat" FOR INPUT AS #1
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        
        IF empID = id THEN
            PRINT "Name: "; name$
            PRINT "Designation: "; designation$
            PRINT "Address: "; address$
            PRINT "Department: "; department$
        PRINT "-------------------------------------"
        ENDIF
    WEND
    CLOSE #1
    PRINT
    INPUT "Main Menu (y/n): ", ans$

    IF ans$ = "y" OR ans$ = "Y" THEN 
        CALL EmployeeDashboard(empID)
    ENDIF
END SUB

' Employee salaryDetails
SUB salaryDetails(empID)
    CLS
    PRINT "====================================="
    PRINT "          SALARY DETAILS             "
    PRINT "====================================="
    OPEN "employees.dat" FOR INPUT AS #1
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        
        IF empID = id THEN
            PRINT "Name: "; name$
            PRINT "Department: "; department$
            PRINT "Basic Salary: "; basicSalary
            PRINT "Total Salary: "; totalSalary
            PRINT "Monthly Tax: "; monthlyTax
            PRINT "Net Salary: "; netSalary
        PRINT "-------------------------------------"
        ENDIF
    WEND
    CLOSE #1
    PRINT
    INPUT "Main Menu (y/n): ", ans$

    IF ans$ = "y" OR ans$ = "Y" THEN 
        CALL EmployeeDashboard(empID)
    ENDIF
END SUB