DECLARE SUB Login()
DECLARE SUB AdminDashboard()
DECLARE SUB EmployeeDashboard()
DECLARE SUB EmployeeModule()
DECLARE SUB AdminModule()
DECLARE SUB ViewEmployee()
DECLARE SUB AddEmployee()
DECLARE SUB UpdateEmployee()
DECLARE SUB DeleteEmployee()
DECLARE SUB salaryDetails()
DECLARE SUB Delay(seconds)
DECLARE SUB viewAdmin()
DECLARE SUB addAdmin()
DECLARE SUB updateAdmin()
DECLARE SUB deleteAdmin()
DECLARE FUNCTION genereateIDForEmployee()
DECLARE FUNCTION genereateIDForAdmin()

CLS
CALL AdminDashboard
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
    WHILE NOT EOF(1)
        INPUT #1, userID, userEmail$, userPassword$, userRole$
        if email$ = userEmail$ AND password$ = userPassword$ THEN  
            verified = 1
            user$ = userRole$
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
        CALL EmployeeDashboard
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
    PRINT "Welcome to the Employee Module."
    PRINT
    PRINT "1. Employee List"
    PRINT "2. Add Employee"
    PRINT "3. Update Employee"
    PRINT "4. Delete Employee"
    PRINT "5. Salary Details"
    PRINT "10. Main Menu"

    INPUT "Enter your choice: ", empChoice
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
            PRINT "Viewing Salary Details..."
            ' Call function to view salary details
        CASE 10
            CALL AdminDashboard
        CASE ELSE
            PRINT "Invalid choice. Please try again."
    END SELECT
End Sub 

' View Employees
SUB ViewEmployee()
    CLS
    PRINT "Viewing Employee Details..."
    PRINT
    OPEN "employees.dat" FOR INPUT AS #1

    isData = 0
    PRINT TAB(2); "id"; TAB(8); "Name"; TAB(20); "Designation"; TAB(35); "Address"; TAB(50); "Department"
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        isData = 1
        PRINT TAB(2); id; TAB(8); name$; TAB(20); designation$; TAB(35); address$; TAB(50); department$
    WEND
    if isData = 0 then PRINT "No employee data found."
    CLOSE #1

    DELAY(2)

    again:
    PRINT
    PRINT "1. Salary details"
    PRINT "2. Main menu"
    PRINT

    INPUT "Enter your choice: ", choice

    SELECT CASE choice
        CASE 1
            CALL salaryDetails
        CASE 2
            CALL EmployeeModule
        CASE ELSE
            PRINT "Invalid Choice. Please try again."
            GOTO again
    END SELECT
END SUB

' Add an Employee
SUB AddEmployee()
    CLS
    PRINT "Adding Employee Details..."
    PRINT
    let id = genereateIDForEmployee

    OPEN "employees.dat" FOR APPEND AS #1
    OPEN "empAuth.dat" FOR INPUT AS #2
    OPEN "empAuth.dat" FOR APPEND AS #3

    name:
    INPUT "Enter Employee Name: ", name$
    if name$ = "" THEN GOTO name

    designation:
    INPUT "Enter Designation: ", designation$
    if designation$ = "" THEN GOTO designation
    
    address:
    INPUT "Enter Address: ", address$
    if address$ = "" THEN GOTO address

    department:
    INPUT "Enter Department: ", department$
    if department$ = "" THEN GOTO department

    basicSalary:
    INPUT "Enter Basic Salary: ", basicSalary
    if basicSalary$ = "" THEN GOTO basicSalary

    CLS
    PRINT
    PRINT "Set up login credentials for the employee."
    PRINT

    email:
    INPUT "Enter email: ", email$

    if email$ = "" THEN GOTO email
    WHILE NOT EOF(2)
        INPUT #2, userID, userEmail$, userPassword$, userRole$
        if userEmail$ = email$ Then 
            PRINT "Email already exists."
            CALL Delay(2)
            GOTO email
        ENDIF
    WEND

    password:
    INPUT "Enter password: ", password$
    if len(password$) < 6 then 
        PRINT "Password must be at least 6 characters long."
        CALL Delay(2)
        GOTO password
    ENDIF

    HRA = 0.2 * basicSalary
    MA = 0.15 * basicSalary
    totalSalary = basicSalary + HRA + MA
    monthlyTax = 0

    if (totalSalary * 12) <= 500000 THEN
        monthlyTax = (0.1 * (totalSalary * 12))/12
    ELSE
        monthlyTax = (0.13 * (totalSalary * 12))/12
    ENDIF

    netSalary = totalSalary - monthlyTax

    WRITE #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
    WRITE #3, id, email$, password$, "employee"

    CLOSE #1
    CLOSE #2
    CLOSE #3

    PRINT "Employee added successfully with ID: "; id
    CALL Delay(2)

    INPUT "repeat add another employee? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL AddEmployee
    ELSE
        CALL EmployeeModule
    END IF
END SUB

' Update Employee
SUB UpdateEmployee()
    CLS
    PRINT "Updating Employee Details..."
    PRINT

    OPEN "employees.dat" FOR INPUT AS #1
    OPEN "temp.dat" FOR OUTPUT AS #2

    INPUT "Enter Employee ID to update: ", empID
    found = 0

    PRINT TAB(2); "id"; TAB(8); "Name"; TAB(15); "Designation"; TAB(30); "Address"; TAB(45); "Department"; TAB(60); "Basic Salary"

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id = empID THEN
            found = 1
            PRINT TAB(2); id; TAB(8); name$; TAB(15); designation$; TAB(30); address$; TAB(45); department$; TAB(60); basicSalary
            PRINT

            ' Update Name
            INPUT "Do you want to update name? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new name: ", name$
            END IF

            ' Update Designation
            INPUT "Do you want to update designation? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new designation: ", designation$
            END IF

            ' Update Address
            INPUT "Do you want to update address? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new address: ", address$
            END IF

            ' Update Department
            INPUT "Do you want to update department? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new department: ", department$
            END IF

            ' Update Basic Salary
            INPUT "Do you want to update basic salary? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new basic salary: ", basicSalary

                HRA = 0.2 * basicSalary
                MA = 0.15 * basicSalary
                totalSalary = basicSalary + HRA + MA
                monthlyTax = 0

                if (totalSalary * 12) <= 500000 THEN
                    monthlyTax = (0.1 * (totalSalary * 12))/12
                ELSE
                    monthlyTax = (0.13 * (totalSalary * 12))/12
                ENDIF
                netSalary = totalSalary - monthlyTax
            END IF

            ' Update employee authentication data
            INPUT "Do you want to update authentication data? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                OPEN "empAuth.dat" FOR INPUT AS #3
                OPEN "auth-temp.dat" FOR OUTPUT AS #4

                WHILE NOT EOF(3)
                    INPUT #3, userID, userEmail$, userPassword$, userRole$
                    IF userID = empID THEN
                        ' Update email
                        INPUT "Do you want to update email? (y/n): ", rep$
                        IF LCASE$(rep$) = "y" THEN 
                            INPUT "Enter new email: ", newEmail$
                        ELSE
                            newEmail$ = userEmail$
                        ENDIF

                        ' userRole update code .....

                        WRITE #4, userID, newEmail$, userPassword$, userRole$
                    ELSE
                        WRITE #4, userID, userEmail$, userPassword$, userRole$
                    END IF
                WEND
                CLOSE #3
                CLOSE #4
                KILL "empAuth.dat"
                NAME "auth-temp.dat" AS "empAuth.dat"
            ENDIF

            WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
            PRINT "Employee details updated successfully."
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        ENDIF
    WEND

    IF found = 0 THEN PRINT "Employee ID not found."
    CLOSE #1
    CLOSE #2
    KILL "employees.dat"
    NAME "temp.dat" AS "employees.dat"

    INPUT "Main Menu? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL EmployeeModule
    END IF
END SUB

' Delete Employee
SUB DeleteEmployee()
    CLS
    OPEN "employees.dat" FOR INPUT AS #1
    OPEN "temp.dat" FOR OUTPUT AS #2
    OPEN "empAuth.dat" FOR INPUT AS #3
    OPEN "auth-temp.dat" FOR OUTPUT AS #4

    INPUT "Enter Employee ID to delete: ", empID
    found = 0

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id = empID THEN
            found = 1
            PRINT
            PRINT TAB(2); "id"; TAB(8); "Name"; TAB(15); "Designation"; TAB(30); "Address"; TAB(45); "Department"; TAB(60); "Basic Salary"
            PRINT
            PRINT TAB(2); id; TAB(8); name$; TAB(15); designation$; TAB(30); address$; TAB(45); department$; TAB(60); basicSalary
            PRINT
            INPUT "Are you sure you want to delete this employee? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                ' Delete from authentication data
                WHILE NOT EOF(3)
                    INPUT #3, authID, userEmail$, userPassword$, role$
                    IF authID <> empID THEN
                        WRITE #4, authID, userEmail$, userPassword$, role$
                    END IF
                WEND
                PRINT
                PRINT "Employee deleted successfully."
            ELSE
                WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
            END IF
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        ENDIF
    WEND

    PRINT
    IF found = 0 THEN PRINT "Employee ID not found."
    CLOSE #1
    CLOSE #2
    CLOSE #3
    CLOSE #4
    KILL "empAuth.dat"
    KILL "employees.dat"
    NAME "temp.dat" AS "employees.dat"
    NAME "auth-temp.dat" AS "empAuth.dat"

    INPUT "Delete another employee? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL DeleteEmployee
    ELSE
        CALL EmployeeModule
    END IF
END SUB

' Create Salary details for Employee
SUB salaryDetails()
    OPEN "employees.dat" FOR INPUT AS #1

    CLS
    PRINT TAB(2); "id"; TAB(8); "Basic Salary"; TAB(23); "Total Salary"; TAB(38); "Monthly Salary"; TAB(55); "Net Salary"
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        PRINT TAB(2); id; TAB(8); basicSalary; TAB(23); totalSalary; TAB(38); monthlyTax; TAB(55); netSalary
    WEND
    CLOSE #1

    ' Main Menu
    INPUT "Main Menu (y/n): ", ans$
    If ans$ = "Y" OR ans$ = "y" THEN 
        CALL ViewEmployee
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
    PRINT "Welcome to the Admin Module."
    PRINT
    PRINT "1. Admin List"
    PRINT "2. Add Admin"
    PRINT "3. Update Admin"
    PRINT "4. Delete Admin"
    PRINT "5. Main Menu"

    INPUT "Enter your choice: ", adminChoice

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
            PRINT "Invalid choice. Please try again."
    END SELECT
End Sub

' View Admin
SUB viewAdmin()
    CLS
    PRINT "Viewing Admin Details..."
    PRINT
    OPEN "admin.dat" FOR INPUT AS #1

    isData = 0 
    PRINT "id", "Name", "Designation", "Address", "Department", "Basic Salary", "Total Salary", "Monthly Tax", "Net Salary"
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        isData = 1
        PRINT id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
    WEND

    IF isData = 0 THEN PRINT "No records found."
    CLOSE #1
    ' Main menu
    INPUT "Main Menu? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL AdminModule
    END IF
END SUB

' Add Admin
SUB addAdmin()
    CLS
    PRINT "Adding New Admin..."
    let id = genereateIDForAdmin

    OPEN "admin.dat" FOR APPEND AS #1
    OPEN "adminAuth.dat" FOR INPUT AS #2
    OPEN "adminAuth.dat" FOR APPEND AS #3

    name:
    INPUT "Enter Admin Name: ", name$
    if name$ = "" THEN GOTO name

    designation:
    INPUT "Enter Designation: ", designation$
    if designation$ = "" THEN GOTO designation
    
    address:
    INPUT "Enter Address: ", address$
    if address$ = "" THEN GOTO address

    department:
    INPUT "Enter Department: ", department$
    if department$ = "" THEN GOTO department

    basicSalary:
    INPUT "Enter Basic Salary: ", basicSalary
    if basicSalary$ = "" THEN GOTO basicSalary

    CLS
    PRINT
    PRINT "Set up login credentials for the admin."
    PRINT

    email:
    INPUT "Enter email: ", email$
    if email$ = "" THEN GOTO email
    WHILE NOT EOF(2)
        INPUT #2, userID, userEmail$, userPassword$, userRole$
        if userEmail$ = email$ Then 
            PRINT "Email already exists."
            CALL Delay(2)
            GOTO email
        ENDIF
    WEND

    password:
    INPUT "Enter password: ", password$
    if len(password$) < 6 then 
        PRINT "Password must be at least 6 characters long."
        CALL Delay(2)
        GOTO password
    ENDIF

    HRA = 0.2 * basicSalary
    MA = 0.15 * basicSalary
    totalSalary = basicSalary + HRA + MA
    monthlyTax = 0

    if (totalSalary * 12) <= 500000 THEN
        monthlyTax = (0.1 * (totalSalary * 12))/12
    ELSE
        monthlyTax = (0.13 * (totalSalary * 12))/12
    ENDIF
    netSalary = totalSalary - monthlyTax

    WRITE #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
    WRITE #3, id, email$, password$, "admin"

    CLOSE #1
    CLOSE #2   
    CLOSE #3

    PRINT "Admin added successfully with ID: "; id
    CALL Delay(2)

    INPUT "repeat add another admin? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL addAdmin
    ELSE
        CALL AdminModule
    END IF
END SUB

' Update Admin
SUB updateAdmin()
    CLS
    PRINT "Updating Admin Details..."

    OPEN "admin.dat" FOR INPUT AS #1
    OPEN "temp.dat" FOR OUTPUT AS #2

    INPUT "Enter admin ID to update: ", adminID
    found = 0

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id = adminID THEN
            found = 1
            PRINT id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
            PRINT

            ' Update Name
            INPUT "Do you want to update name? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new name: ", name$
            END IF

            ' Update Designation
            INPUT "Do you want to update designation? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new designation: ", designation$
            END IF

            ' Update Address
            INPUT "Do you want to update address? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new address: ", address$
            END IF

            ' Update Department
            INPUT "Do you want to update department? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new department: ", department$
            END IF

            ' Update Basic Salary
            INPUT "Do you want to update basic salary? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                INPUT "Enter new basic salary: ", basicSalary

                HRA = 0.2 * basicSalary
                MA = 0.15 * basicSalary
                totalSalary = basicSalary + HRA + MA
                monthlyTax = 0

                if (totalSalary * 12) <= 500000 THEN
                    monthlyTax = (0.1 * (totalSalary * 12))/12
                ELSE
                    monthlyTax = (0.13 * (totalSalary * 12))/12
                ENDIF
                netSalary = totalSalary - monthlyTax
            END IF

            ' Update admin authentication data
            INPUT "Do you want to update authentication data? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                OPEN "adminAuth.dat" FOR INPUT AS #3
                OPEN "auth-temp.dat" FOR OUTPUT AS #4

                WHILE NOT EOF(3)
                    INPUT #3, userID, userEmail$, userPassword$, userRole$
                    IF userID = empID THEN
                        ' Update email
                        INPUT "Do you want to update email? (y/n): ", rep$
                        IF LCASE$(rep$) = "y" THEN 
                            INPUT "Enter new email: ", newEmail$
                        ELSE
                            newEmail$ = userEmail$
                        ENDIF

                        ' userRole update code .....

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
            PRINT "Employee details updated successfully."
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        ENDIF
    WEND

    IF found = 0 THEN PRINT "Admin ID not found."
    CLOSE #1
    CLOSE #2
    KILL "admin.dat"
    NAME "temp.dat" AS "admin.dat"

    ' Main menu
    INPUT "Main Menu? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
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

    INPUT "Enter Admin ID to delete: ", adminID
    found = 0
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        IF id = adminID THEN
            found = 1
            PRINT
            PRINT TAB(2); "id"; TAB(8); "Name"; TAB(15); "Designation"; TAB(30); "Address"; TAB(45); "Department"; TAB(60); "Basic Salary"
            PRINT
            PRINT TAB(2); id; TAB(8); name$; TAB(15); designation$; TAB(30); address$; TAB(45); department$; TAB(60); basicSalary
            PRINT
            INPUT "Are you sure you want to delete this admin? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                ' Delete from authentication data
                WHILE NOT EOF(3)
                    INPUT #3, authID, userEmail$, userPassword$, role$
                    IF authID <> adminID THEN
                        WRITE #4, authID, userEmail$, userPassword$, role$
                    END IF
                WEND

                PRINT
                PRINT "Admin deleted successfully."
            ELSE
                WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
            END IF
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary, totalSalary, monthlyTax, netSalary
        ENDIF
    WEND

    PRINT
    IF found = 0 THEN PRINT "Admin ID not found."
    CLOSE #1
    CLOSE #2
    CLOSE #3
    CLOSE #4

    KILL "admin.dat"
    KILL "adminAuth.dat"
    NAME "temp.dat" AS "admin.dat"
    NAME "auth-temp.dat" AS "adminAuth.dat"

    INPUT "Delete another employee? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL deleteAdmin
    ELSE
        CALL AdminModule
    END IF
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
Sub EmployeeDashboard()
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
            PRINT "Salary details"
        CASE 2
            PRINT "Profile"
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
        CALL EmployeeDashboard
    ENDIF
End Sub