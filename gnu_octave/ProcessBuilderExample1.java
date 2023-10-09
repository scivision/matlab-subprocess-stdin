
public class ProcessBuilderExample1 {

    public static void main(String[] args) {

        ProcessBuilder processBuilder = new ProcessBuilder();

        processBuilder.command("sh", "-c", "ping -c 3 localhost");

        try {

            Process process = processBuilder.start();

			// blocking read
            java.io.BufferedReader reader =
                new java.io.BufferedReader(new java.io.InputStreamReader(process.getInputStream()));

            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }

            int exitCode = process.waitFor();
            System.out.println("\nReturn code : " + exitCode);

        } catch (java.io.IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }

}
