const functions = require('firebase-functions')
const twilio = require('twilio')
const cors = require('cors')({origin: true})
const admin = require('firebase-admin')
const nodemailer = require('nodemailer')
const EmailTemplate = require('email-templates').EmailTemplate

admin.initializeApp(functions.config().firebase)

// Twilio setup
const TWILIO_CONFIG = functions.config().twilio
const CLIENT = twilio(TWILIO_CONFIG.account_sid,TWILIO_CONFIG.auth_token)

// Nodemailer setup through gmail
const gmailEmail = functions.config().gmail.email
const gmailPassword = functions.config().gmail.password
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
})

/**
 * Sends an email receipt for an rsvp.
 * @param to Email address to send the receipt to.
 * @param rsvpSummary List of summary messages for each rsvp
 */
const sendReceipt = (to, rsvpSummary) => {
  if (!to) return Promise.resolve()

  const template = new EmailTemplate('./templates/receipt', {
    from: `Mattia-Kozemzak Wedding <noreply@davidandbri.com>`,
    bcc: 'dmattia13@gmail.com',
  })

  const sendEmail = transporter.templateSender(template)
  const mailOptions = {
    to: to,
  }
  const context = {
    summary: rsvpSummary,
  }

  return sendEmail(mailOptions, context)
}

/**
 * Sends an SMS to bri and I
 */
const notifyUs = message => {
  return Promise.all([
    sendSMS('+16124378532', message),
    sendSMS('+16517695835', message),
  ])
}

/**
 * Send an SMS to a target phone number using Twilio
 * @param to Phone Number to send an SMS to
 * @param message The contents of the SMS
 */
const sendSMS = (to, message) => {
  console.info(`Sending text to: ${to}.`)
  console.info(`Message: ${message}.`)
  const messageData = {
    body: message,
    to: to,
    from: '+16513831524'
  }

  return CLIENT.messages.create(messageData)
}

/**
 * Writes one rsvp to the database
 * @param rsvp a nonnull rsvp object in a form compatible with the db schema
 */
const publishSingleRsvp = rsvp => {
  console.info('Publishing Rsvp: ')
  console.info(rsvp)

  return admin.database().ref('/rsvp').push({
    rsvp: rsvp,
    time: admin.database.ServerValue.TIMESTAMP,
  })
}

/**
 * Converts an RSVP to a form compatible with the db schema
 * @param rsvp a nonnull rsvp object in a raw form from the front end
 */
// TODO: this needs a better name
const convertRsvp = rsvp => {
  return {
    first_name: rsvp.first_name || '',
    last_name: rsvp.last_name || '',
    attending_wedding: rsvp.attending_wedding === "yes" ? true : false,
    attending_reception: rsvp.attending_reception === "yes" ? true : false,
    wants_transpo: rsvp.wants_transpo === "yes" ? true : false,
  }
}

/**
 * Converts an RSVP to a human readable string.
 * @param rsvp a nonnull rsvp object in a form compatible with the db schema
 */
const toString = rsvp => {
  const name = `${rsvp.first_name} ${rsvp.last_name}`
  let attendanceMsg = "can't make it"
  let transpoMsg = "will find their own transport."
  
  if (rsvp.wants_transpo) {
    transpoMsg = "would like group transport."
  }

  if (rsvp.attending_wedding && rsvp.attending_reception) {
    attendanceMsg = "is coming to both the wedding and reception"
  } else if (rsvp.attending_wedding) {
    attendanceMsg = "is coming to just the wedding"
  } else if (rsvp.attending_reception) {
    attendanceMsg = "is coming to just the reception"
  }

  return `${name} ${attendanceMsg}, and ${transpoMsg}`
}

/**
 * Validates that a group of rsvps are valid
 */
const validate = rsvps => {
  // TODO: Validate more thoroughly
  return !!rsvps
}

/**
 * Http endpoint for sending email receipt to user after completing rsvp
 */
exports.publishRsvp = functions.https.onRequest((req, res) => {
  cors(req, res, () => {
    const rsvps = req.body.rsvps
    const receiptAddress = req.body.email

    if (!validate(rsvps)) {
      res.status(418).send("I'm a teapot")
      return
    }
    
    const dbUpdates = rsvps.map(convertRsvp).map(publishSingleRsvp)
    const summaryList = rsvps.map(convertRsvp).map(toString)

    return Promise.all(dbUpdates)
      .then(_ => notifyUs(summaryList.join('\n')))
      .then(_ => sendReceipt(receiptAddress, summaryList))
      .then(_ => res.send('nice'))
      .catch(error => {
        console.info("Error: ", error)
        res.status(418).send("I'm a teapot")
      })
  })
})
