import java.sql.*;

// Remember that part of your mark is for doing as much in SQL (not Java)
// as you can. At most you can justify using an array, or the more flexible
// ArrayList. Don't go crazy with it, though. You need it rarely if at all.
import java.util.ArrayList;

public class Assignment2 {

    // A connection to the database
    Connection connection;

    Assignment2() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * Connects to the database and sets the search path.
     *
     * Establishes a connection to be used for this session, assigning it to the
     * instance variable 'connection'. In addition, sets the search path to
     * markus.
     *
     * @param url
     *            the url for the database
     * @param username
     *            the username to be used to connect to the database
     * @param password
     *            the password to be used to connect to the database
     * @return true if connecting is successful, false otherwise
     */
    public boolean connectDB(String URL, String username, String password) {
        // Replace this return statement with an implementation of this method!
        PreparedStatement pStatement;
        ResultSet rs;
        String queryString;

        try {
            Class.forName("org.postgresql.Driver");
        }
        catch (ClassNotFoundException e) {
            System.out.println("Failed to find the JDBC driver");
        }
        try{
            connection = DriverManager.getConnection(URL, username, password);
            queryString = "SET SEARCH_PATH TO 'markus'";
            pStatement = connection.prepareStatement(queryString);
            pStatement.execute();
            queryString = "select * from Assignment";
            pStatement = connection.prepareStatement(queryString);
            rs = pStatement.executeQuery();
            while (rs.next()){
                String id = rs.getString("description");
                System.out.println(id);
            }
            System.out.println("connectDB exited with a success");
            return true;
        }
        catch (SQLException se)
        {
            System.err.println("SQL Exception." +
                    "<Message>: " + se.getMessage());
            return false;
        }
    }

    /**
     * Closes the database connection.
     *
     * @return true if the closing was successful, false otherwise
     */
    public boolean disconnectDB() {
        // Replace this return statement with an implementation of this method!
        boolean isClosed;
        try {
            connection.close();
             isClosed = connection.isClosed();
             if (isClosed){
                 return true;
             }
        }catch (SQLException e) {
            System.out.println("Not disconnect successfully");
        }
        return false;

    }

    /**
     * Assigns a grader for a group for an assignment.
     *
     * Returns false if the groupID does not exist in the AssignmentGroup table,
     * if some grader has already been assigned to the group, or if grader is
     * not either a TA or instructor.
     *
     * @param groupID
     *            id of the group
     * @param grader
     *            username of the grader
     * @return true if the operation was successful, false otherwise
     */
    public boolean assignGrader(int groupID, String grader) {
    	PreparedStatement pStatement;
    	try {
    		pStatement = connection.prepareStatement("INSERT INTO Grader " + 
        	    	"VALUES (" + new Integer(groupID).toString() + ", \'" + grader + "\')");
    		pStatement.executeUpdate();
    		System.out.println("assignGrader exited with a success");
    		return true;
    	} catch (SQLException ex) {
    		System.out.println("The operation failed");
    		ex.printStackTrace();
    	}
        return false;
    }

    /**
     * Adds a member to a group for an assignment.
     *
     * Records the fact that a new member is part of a group for an assignment.
     * Does nothing (but returns true) if the member is already declared to be
     * in the group.
     *
     * Does nothing and returns false if any of these conditions hold: - the
     * group is already at capacity, - newMember is not a valid username or is
     * not a student, - there is no assignment with this assignment ID, or - the
     * group ID has not been declared for the assignment.
     *
     * @param assignmentID
     *            id of the assignment
     * @param groupID
     *            id of the group to receive a new member
     * @param newMember
     *            username of the new member to be added to the group
     * @return true if the operation was successful, false otherwise
     */
    public boolean recordMember(int assignmentID, int groupID, String newMember) {
        PreparedStatement pStatement;
	ResultSet rs;
	try {
		String queryAssignment = "select distinct * from " +
				"((select Assignment.assignment_id, group_min, group_max " +
				"from Assignment natural join Membership natural join AssignmentGroup " +
				"where Assignment.assignment_id = " + new Integer(assignmentID).toString() + ") a " +
				"natural join " +
				"(select Assignment_id, count(group_id) as num_students " +
				"from Assignment natural join Membership natural join AssignmentGroup " +
				"where Membership.group_id = " + new Integer(groupID).toString() +
				" group by Assignment.assignment_id, Membership.group_id) b)";
		pStatement = connection.prepareStatement(queryAssignment);
		rs = pStatement.executeQuery();
		while (rs.next()){
			Integer group_max = Integer.parseInt(rs.getString("group_max"));
			Integer num_students = Integer.parseInt(rs.getString("num_students"));
			if (group_max >= num_students) {
				connection.prepareStatement("INSERT INTO Membership " + "VALUES (" +
						"\'" + newMember + "\'," + 
										new Integer(groupID).toString() + ")").executeUpdate();
				System.out.println("recordMember exited with a success");
				return true;
			} else return false;
		}
		} catch (SQLException ex) {
			System.err.println("SQL Exception." +
					"<Message>: " + ex.getMessage());
	   } 
        return false;
    }

    /**
     * Creates student groups for an assignment.
     *
     * Finds all students who are defined in the Users table and puts each of
     * them into a group for the assignment. Suppose there are n. Each group
     * will be of the maximum size allowed for the assignment (call that k),
     * except for possibly one group of smaller size if n is not divisible by k.
     * Note that k may be as low as 1.
     *
     * The choice of which students to put together is based on their grades on
     * another assignment, as recorded in table Results. Starting from the
     * highest grade on that other assignment, the top k students go into one
     * group, then the next k students go into the next, and so on. The last n %
     * k students form a smaller group.
     *
     * In the extreme case that there are no students, does nothing and returns
     * true.
     *
     * Students with no grade recorded for the other assignment come at the
     * bottom of the list, after students who received zero. When there is a tie
     * for grade (or non-grade) on the other assignment, takes students in order
     * by username, using alphabetical order from A to Z.
     *
     * When a group is created, its group ID is generated automatically because
     * the group_id attribute of table AssignmentGroup is of type SERIAL. The
     * value of attribute repo is repoPrefix + "/group_" + group_id
     *
     * Does nothing and returns false if there is no assignment with ID
     * assignmentToGroup or no assignment with ID otherAssignment, or if any
     * group has already been defined for this assignment.
     *
     * @param assignmentToGroup
     *            the assignment ID of the assignment for which groups are to be
     *            created
     * @param otherAssignment
     *            the assignment ID of the other assignment on which the
     *            grouping is to be based
     * @param repoPrefix
     *            the prefix of the URL for the group's repository
     * @return true if successful and false otherwise
     */

    public static void main(String[] args) throws SQLException {
        String url;
        String username;
        String password;
        url = "jdbc:postgresql://localhost:5432/csc343h-zhuqian2";
        username = "zhuqian2";
        password = "";
        int groupID = 2;
        String grader = "t1";
        int assignmentID = 1000;
        String newMember = "s2";
        Assignment2 A2 = new Assignment2();
        A2.connectDB(url,username,password);
        A2.assignGrader(groupID, grader);
        A2.recordMember(assignmentID, groupID, newMember);
        A2.disconnectDB();
    }
}
