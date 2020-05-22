const { exec } = require("@actions/exec");
const core = require("@actions/core");
const path = require("path");

let main;
if (process.platform === "win32") {
    let scriptfile = path.join(__dirname, "main.ps1")
    main = `"C:\\Program Files\\PowerShell\\7\\pwsh.EXE" -command ". '${scriptfile}'"`;
}
else {
    main = path.join(__dirname, "main.sh")
}

const version = core.getInput("otp-version", { required: true });
exec(main, [version]).catch(err => core.setFailed(err.message));
