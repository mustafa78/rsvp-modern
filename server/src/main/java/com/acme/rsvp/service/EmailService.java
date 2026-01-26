package com.acme.rsvp.service;

import com.sendgrid.Method;
import com.sendgrid.Request;
import com.sendgrid.Response;
import com.sendgrid.SendGrid;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class EmailService {
    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    @Value("${app.sendgrid.api-key:}")
    private String sendGridApiKey;

    @Value("${app.sendgrid.from-email:noreply@example.com}")
    private String fromEmail;

    @Value("${app.sendgrid.from-name:RSVP System}")
    private String fromName;

    @Value("${app.sendgrid.enabled:false}")
    private boolean enabled;

    public void sendPasswordResetLink(String to, String link) {
        String subject = "Password Reset Request";
        String htmlContent = buildPasswordResetEmail(link);
        String textContent = "Reset your password by visiting: " + link + "\n\nThis link will expire in 1 hour.";

        sendEmail(to, subject, htmlContent, textContent);
    }

    public void sendEmail(String to, String subject, String htmlContent, String textContent) {
        if (!enabled || sendGridApiKey == null || sendGridApiKey.isBlank()) {
            log.info("Email sending disabled or API key not configured. Would have sent to: {}, subject: {}", to, subject);
            log.info("Email content: {}", textContent);
            return;
        }

        Email from = new Email(fromEmail, fromName);
        Email toEmail = new Email(to);
        Content content = new Content("text/html", htmlContent);
        Mail mail = new Mail(from, subject, toEmail, content);

        // Add plain text version
        mail.addContent(new Content("text/plain", textContent));

        SendGrid sg = new SendGrid(sendGridApiKey);
        Request request = new Request();

        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            Response response = sg.api(request);

            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                log.info("Email sent successfully to: {}, subject: {}", to, subject);
            } else {
                log.error("Failed to send email. Status: {}, Body: {}", response.getStatusCode(), response.getBody());
            }
        } catch (IOException e) {
            log.error("Error sending email to: {}", to, e);
        }
    }

    private String buildPasswordResetEmail(String link) {
        // Note: %% is used to escape % in CSS (e.g., width: 100%%)
        return """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
            </head>
            <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
                <table role="presentation" style="width: 100%%; border-collapse: collapse;">
                    <tr>
                        <td style="padding: 40px 0;">
                            <table role="presentation" style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                <!-- Header -->
                                <tr>
                                    <td style="background: linear-gradient(to right, #7c3aed, #2563eb); padding: 30px; text-align: center;">
                                        <h1 style="color: #ffffff; margin: 0; font-size: 24px;">RSVP System</h1>
                                    </td>
                                </tr>
                                <!-- Content -->
                                <tr>
                                    <td style="padding: 40px 30px;">
                                        <h2 style="color: #333333; margin: 0 0 20px 0; font-size: 20px;">Password Reset Request</h2>
                                        <p style="color: #666666; line-height: 1.6; margin: 0 0 20px 0;">
                                            We received a request to reset your password. Click the button below to create a new password:
                                        </p>
                                        <table role="presentation" style="margin: 30px 0;">
                                            <tr>
                                                <td style="border-radius: 6px; background: linear-gradient(to right, #7c3aed, #2563eb);">
                                                    <a href="%s" style="display: inline-block; padding: 14px 30px; color: #ffffff; text-decoration: none; font-weight: bold; font-size: 16px;">
                                                        Reset Password
                                                    </a>
                                                </td>
                                            </tr>
                                        </table>
                                        <p style="color: #666666; line-height: 1.6; margin: 0 0 10px 0;">
                                            This link will expire in <strong>1 hour</strong>.
                                        </p>
                                        <p style="color: #999999; font-size: 14px; line-height: 1.6; margin: 20px 0 0 0;">
                                            If you didn't request a password reset, you can safely ignore this email.
                                        </p>
                                    </td>
                                </tr>
                                <!-- Footer -->
                                <tr>
                                    <td style="background-color: #f8f8f8; padding: 20px 30px; text-align: center; border-top: 1px solid #eeeeee;">
                                        <p style="color: #999999; font-size: 12px; margin: 0;">
                                            Anjuman-e-Ezzi, Washington DC
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </body>
            </html>
            """.formatted(link);
    }
}
