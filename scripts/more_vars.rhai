// Get the project name
let project_name = variable::get("project-name");

// Create a lowercase version of the project name
let project_name_lower = project_name.to_snake_case();
variable::set("project-name-lower", project_name_lower);

// Create an uppercase version of the project name
let project_name_upper = project_name.to_shouty_snake_case();
variable::set("project-name-upper", project_name_upper);