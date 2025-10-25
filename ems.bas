DECLARE SUB AdminDashboard()
DECLARE SUB EmployeeModule()
DECLARE SUB AdminModule()
DECLARE SUB ViewEmployee()
DECLARE SUB AddEmployee()
DECLARE SUB UpdateEmployee()
DECLARE SUB DeleteEmployee()
DECLARE SUB Delay(seconds)

DECLARE SUB viewAdmin()
DECLARE SUB addAdmin()
DECLARE SUB updateAdmin()
DECLARE SUB deleteAdmin()

DECLARE FUNCTION genereateIDForEmployee()
DECLARE FUNCTION genereateIDForAdmin()
DECLARE FUNCTION generateIDForAuth()

CLS
PRINT "Welcome to the Employee Management System"
PRINT
CALL AdminDashboard
END

' Admin Dashboard
Sub AdminDashboard()
    CLS
    PRINT "1. Employees"
    PRINT "2. Admin"

    INPUT "Enter your choice: ", choice

    SELECT CASE choice
        CASE 1
            CALL EmployeeModule
        CASE 2
            CALL AdminModule
        CASE ELSE
            PRINT "Invalid choice. Please try again."
    END SELECT
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
    PRINT "5. Assign Task"
    PRINT "6. View ongoing Tasks"
    PRINT "7. Completed Tasks"
    PRINT "8. Overdue Tasks"
    PRINT "9. Salary Details"
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
            PRINT "Assigning Task to Employee..."
            ' Call function to assign task
        CASE 6
            PRINT "Viewing Ongoing Tasks..."
            ' Call function to view ongoing tasks
        CASE 7
            PRINT "Viewing Completed Tasks..."
            ' Call function to view completed tasks
        CASE 8
            PRINT "Viewing Overdue Tasks..."
            ' Call function to view overdue tasks
        CASE 9
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
    PRINT "id", "Name", "Designation", "Address", "Department", "Basic Salary"
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary
        isData = 1
        PRINT id, name$, designation$, address$, department$, basicSalary
    WEND
    if isData = 0 then PRINT "No employee data found."
    CLOSE #1

    INPUT "Main Menu? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL EmployeeModule
    END IF
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

    INPUT "Enter Employee Name: ", name$
    INPUT "Enter Designation: ", designation$
    INPUT "Enter Address: ", address$
    INPUT "Enter Department: ", department$
    INPUT "Enter Basic Salary: ", basicSalary

    CLS
    PRINT
    PRINT "Set up login credentials for the employee."
    PRINT

    email:
    INPUT "Enter email: ", email$
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

    WRITE #1, id, name$, designation$, address$, department$, basicSalary
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

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary
        IF id = empID THEN
            found = 1
            PRINT id, name$, designation$, address$, department$, basicSalary
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

            WRITE #2, id, name$, designation$, address$, department$, basicSalary
            PRINT "Employee details updated successfully."
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary
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
    PRINT "Deleting Employee Details..."

    OPEN "employees.dat" FOR INPUT AS #1
    OPEN "temp.dat" FOR OUTPUT AS #2
    OPEN "empAuth.dat" FOR INPUT AS #3
    OPEN "auth-temp.dat" FOR OUTPUT AS #4

    INPUT "Enter Employee ID to delete: ", empID
    found = 0

    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary
        IF id = empID THEN
            found = 1
            PRINT "id", "Name", "Designation", "Address", "Department", "Basic Salary"
            PRINT
            PRINT id, name$, designation$, address$, department$, basicSalary

            INPUT "Are you sure you want to delete this employee? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                ' Delete from authentication data
                WHILE NOT EOF(3)
                    INPUT #3, authID, userEmail$, userPassword$, role$
                    IF authID <> empID THEN
                        WRITE #4, authID, userEmail$, userPassword$, role$
                    END IF
                WEND

                PRINT "Employee deleted successfully."
            ELSE
                WRITE #2, id, name$, designation$, address$, department$, basicSalary
            END IF
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary
        ENDIF
    WEND

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
    END IF

    ' Main menu
    INPUT "Main Menu? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL EmployeeModule
    END IF
END SUB

' Generate id for employee
FUNCTIOn genereateIDForEmployee()
    OPEN "employees.dat" FOR INPUT AS #1
    maxID = 0
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary
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
    PRINT "id", "Name", "Designation", "Address", "Department", "Basic Salary"
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary
        isData = 1
        PRINT id, name$, designation$, address$, department$, basicSalary
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

    INPUT "Enter Admin Name: ", name$
    INPUT "Enter Designation: ", designation$
    INPUT "Enter Address: ", address$
    INPUT "Enter Department: ", department$
    INPUT "Enter Basic Salary: ", basicSalary

    CLS
    PRINT
    PRINT "Set up login credentials for the admin."
    PRINT

    email:
    INPUT "Enter email: ", email$
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

    WRITE #1, id, name$, designation$, address$, department$, basicSalary
    WRITE #3, id, email$, password$, "admin"

    CLOSE #1
    CLOSE #2   
    CLOSE #3

    PRINT "Admin added successfully with ID: "; id
    CALL Delay(2)

    INPUT "repeat add another employee? (y/n): ", ans$
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
        INPUT #1, id, name$, designation$, address$, department$, basicSalary
        IF id = adminID THEN
            found = 1
            PRINT id, name$, designation$, address$, department$, basicSalary
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

            WRITE #2, id, name$, designation$, address$, department$, basicSalary
            PRINT "Employee details updated successfully."
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary
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
        INPUT #1, id, name$, designation$, address$, department$, basicSalary
        IF id = adminID THEN
            found = 1
            PRINT "id", "Name", "Designation", "Address", "Department", "Basic Salary"
            PRINT
            PRINT id, name$, designation$, address$, department$, basicSalary

            INPUT "Are you sure you want to delete this admin? (y/n): ", ans$
            IF ans$ = "y" OR ans$ = "Y" THEN
                ' Delete from authentication data
                WHILE NOT EOF(3)
                    INPUT #3, authID, userEmail$, userPassword$, role$
                    IF authID <> adminID THEN
                        WRITE #4, authID, userEmail$, userPassword$, role$
                    END IF
                WEND
            ELSE
                WRITE #2, id, name$, designation$, address$, department$, basicSalary
            END IF
        ELSE
            WRITE #2, id, name$, designation$, address$, department$, basicSalary
        ENDIF
    WEND

    IF found = 0 THEN PRINT "Admin ID not found."
    CLOSE #1
    CLOSE #2
    CLOSE #3
    CLOSE #4

    KILL "admin.dat"
    KILL "adminAuth.dat"
    NAME "temp.dat" AS "admin.dat"
    NAME "auth-temp.dat" AS "adminAuth.dat"

    ' Main menu
    INPUT "Main Menu? (y/n): ", ans$
    IF ans$ = "y" OR ans$ = "Y" THEN
        CALL AdminModule
    END IF
END SUB

' Generate id for admin
FUNCTIOn genereateIDForAdmin()
    OPEN "admin.dat" FOR INPUT AS #1
    maxID = 0
    WHILE NOT EOF(1)
        INPUT #1, id, name$, designation$, address$, department$, basicSalary
        IF id > maxID THEN
            maxID = id
        END IF
    WEND
    CLOSE #1
    genereateIDForAdmin = maxID + 1
END FUNCTION