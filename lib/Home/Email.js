const functions = require("firebase-functions");
const admin = require("firebase-admin");
const sgMail = require("@sendgrid/mail");

admin.initializeApp();
sgMail.setApiKey("YOUR_SENDGRID_API_KEY");

exports.sendApplicationEmail = functions.firestore
  .document("Applications/{applicationId}")
  .onCreate((snap, context) => {
    const data = snap.data();
    const msg = {
      to: "recipient@example.com", // Company email address
      from: "sender@example.com", // Verified sender
      subject: `New Internship Application - ${data.vacancyTitle}`,
      text: `
        Applicant Name: ${data.name}
        Email: ${data.email}
        Phone: ${data.phone}
        Cover Letter: ${data.coverLetter}
        Referral Information:
          Name: ${data.referral.name}
          Title: ${data.referral.title}
          Organization: ${data.referral.organization}
          Contact: ${data.referral.contact}
          Relationship: ${data.referral.relationship}
      `,
    };
    return sgMail.send(msg);
  });
