package concurrency_issues;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import static concurrency_issues.Utils.printOperatingSystemData;
import static concurrency_issues.Utils.setReadUncommittedIsolation;

public class DirtyWrite {

    private final Lock lock = new ReentrantLock();

    public void dirtyWrite(Connection connection) {
        Thread updateThread1 = new Thread(() -> {
            try {
                Statement statement = connection.createStatement();
                setReadUncommittedIsolation(connection);
                lock.lock(); // Acquire the lock
                printOperatingSystemData(connection, "updateThread1");
                // Update the operating system version
                String updateQuery = "UPDATE operating_system SET os_version = 15 WHERE id = 100000001";
                int rowsUpdated = statement.executeUpdate(updateQuery);
                // Wait for 5 seconds
                Thread.sleep(5000);
                printOperatingSystemData(connection, "updateThread1");
            } catch (SQLException | InterruptedException e) {
                throw new RuntimeException(e);
            } finally {
                lock.unlock(); // Release the lock in the finally block
            }
        });


        Thread updateThread2 = new Thread(() -> {
            try {
                Statement statement = connection.createStatement();
                setReadUncommittedIsolation(connection);
                // Wait for the first thread to unlock
                lock.lock();
                // Update the operating system version
                String updateQuery = "UPDATE operating_system SET os_version = 21 WHERE id = 100000001";
                int rowsUpdated = statement.executeUpdate(updateQuery);
                printOperatingSystemData(connection, "updateThread2");

            } catch (SQLException e) {
                throw new RuntimeException(e);
            } finally {
                lock.unlock();
            }
        });

        // Start the threads
        updateThread1.start();
        updateThread2.start();

        // Wait for threads to finish
        try {
            updateThread1.join();
            updateThread2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
