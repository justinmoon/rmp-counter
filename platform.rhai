// FIXME: this doesn't work?!
// let platforms = variable::prompt("Include iOS?", "", ["SwiftUI", "Jetpack Compose"]);

let include_ios = variable::get("include_ios");
let include_android = variable::get("include_android");

if (include_ios) {
    debug("Keeping ios");
} else {
    debug("Deleting ios");
    file::delete("ios");
}

if (include_android) {
    debug("Keeping android");

    // FIXME: maybe this will work if w `import "regex" as rx;`
    // Define a regex pattern for a valid Android bundle ID
    // let bundle_id_pattern = r"^[a-zA-Z]+(\\.[a-zA-Z0-9_]+)+$";

    // Prompt the user for the bundle ID with validation
    let project_name = variable::get("project-name");
    let bundle_id = variable::prompt(
        "Enter the Android bundle ID:",
        `com.rmp.${project_name}`,
        // bundle_id_pattern
    );

    // Set the bundle ID as a variable for use in the template
    variable::set("android-bundle-id", bundle_id);

    // These variables are used in android folder names
    let parts = bundle_id.split(".");
    variable::set("bundle-id-tld", parts[0]);
    variable::set("bundle-id-org", parts[1]);
    variable::set("bundle-id-app", parts[2]);
} else {
    debug("Deleting android");
    file::delete("android");
}
