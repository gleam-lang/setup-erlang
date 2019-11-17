const { exec } = require("@actions/exec");
const core = require("@actions/core");
const path = require("path");

const version = core.getInput("otp-version", { required: true });
const main = path.join(__dirname, "main.sh");
exec(main, [version]).catch(err => core.setFailed(err.message));
