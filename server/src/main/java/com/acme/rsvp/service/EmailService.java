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
import java.util.List;
import org.springframework.web.util.HtmlUtils;
import com.acme.rsvp.dto.WebinarDtos.InviteLink;

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
        deliver(to, subject, htmlContent, textContent);
    }

    /** True only when sending is switched on and an API key is present; otherwise emails are logged, not sent. */
    public boolean isEnabled() {
        return enabled && sendGridApiKey != null && !sendGridApiKey.isBlank();
    }

    /** Returns true when accepted by SendGrid or when sending is disabled (logged instead); false on failure. */
    private boolean deliver(String to, String subject, String htmlContent, String textContent) {
        if (!isEnabled()) {
            log.info("Email sending disabled or API key not configured. Would have sent to: {}, subject: {}", to, subject);
            log.info("Email content: {}", textContent);
            return true;
        }

        Email from = new Email(fromEmail, fromName);
        Email toEmail = new Email(to);
        // SendGrid requires: text/plain first, then text/html
        Content plainContent = new Content("text/plain", textContent);
        Mail mail = new Mail(from, subject, toEmail, plainContent);
        mail.addContent(new Content("text/html", htmlContent));

        SendGrid sg = new SendGrid(sendGridApiKey);
        Request request = new Request();

        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            Response response = sg.api(request);

            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                log.info("Email sent successfully to: {}, subject: {}", to, subject);
                return true;
            }
            log.error("Failed to send email. Status: {}, Body: {}", response.getStatusCode(), response.getBody());
            return false;
        } catch (IOException e) {
            log.error("Error sending email to: {}", to, e);
            return false;
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

    public boolean sendWebinarInvite(String to, String title, String hostName, String whenText,
            List<InviteLink> links) {
        // Invites carry join links: never fall through to the log-instead path.
        if (!isEnabled()) return false;
        String subject = "Your webinar link: " + title;

        StringBuilder text = new StringBuilder();
        text.append(title).append("\n");
        if (hostName != null && !hostName.isBlank()) text.append("Host: ").append(hostName).append("\n");
        text.append("When: ").append(whenText).append("\n\n");
        for (InviteLink link : links) {
            text.append(link.label()).append(": ").append(link.url()).append("\n");
        }
        text.append("\nEach link is personal. Please forward each family member their own link. ")
            .append("Links work only around the scheduled time.");

        StringBuilder html = new StringBuilder();
        html.append("<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;\">")
            .append("<div style=\"background: #6d28d9; padding: 24px; text-align: center;\">")
            .append("<h1 style=\"color: #ffffff; margin: 0; font-size: 22px;\">")
            .append(HtmlUtils.htmlEscape(title)).append("</h1></div>")
            .append("<div style=\"padding: 24px; color: #333333;\">");
        if (hostName != null && !hostName.isBlank()) {
            html.append("<p style=\"margin: 0 0 8px 0;\"><strong>Host:</strong> ")
                .append(HtmlUtils.htmlEscape(hostName)).append("</p>");
        }
        html.append("<p style=\"margin: 0 0 20px 0;\"><strong>When:</strong> ")
            .append(HtmlUtils.htmlEscape(whenText)).append("</p>");
        for (InviteLink link : links) {
            html.append("<p style=\"margin: 0 0 14px 0;\">")
                .append(HtmlUtils.htmlEscape(link.label())).append("<br>")
                .append("<a href=\"").append(HtmlUtils.htmlEscape(link.url()))
                .append("\" style=\"color: #2563eb; font-weight: bold;\">Join webinar</a></p>");
        }
        html.append("<p style=\"color: #666666; font-size: 13px; margin-top: 24px;\">")
            .append("Each link is personal. Please forward each family member their own link. ")
            .append("Links work only around the scheduled time.</p>")
            .append("</div><div style=\"background: #f8f8f8; padding: 16px; text-align: center; ")
            .append("color: #999999; font-size: 12px;\">Anjuman-e-Ezzi, Washington DC</div></div>");

        return deliver(to, subject, html.toString(), text.toString());
    }
}
