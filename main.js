const { exec } = require("@actions/exec");
const core = require("@actions/core");
const path = require("path");

let scriptfile;
if (process.platform === "win32") {
    scriptfile = "main.ps1";
}
else {
    scriptfile = "main.sh";
}

const version = core.getInput("otp-version", { required: true });
const main = path.join(__dirname, scriptfile);
exec(main, [version]).catch(err => core.setFailed(err.message));
