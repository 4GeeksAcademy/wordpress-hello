<?php
//Get the variables from the controller
$args = wpas_get_view_data();
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Hello from Rigo!</title>
        <?php wp_head() ?>
    </head>
    <body>
        <p style="text-align: center;"><img style="max-height: 100px;" src="https://github.com/4GeeksAcademy/wordpress-hello/blob/870d5fd33409f7323b4d38ca6062dcbd531f0d63/wp-content/themes/rigo/rigoberto-rocket.png?raw=true" /></p>
        <h1>Hello from <?php echo $args['name']; ?>!</h1>
        <p>If you are able to see this, it means the MVC pattern is working correctly.</p>
        <p>Now you have to start building your <a href="https://github.com/alesanchezr/wpas-wordpress-dash/blob/master/src/WPAS/Controller/API.md">API endpoints</a> and <a href="https://github.com/alesanchezr/wpas-wordpress-dash/tree/master/src/WPAS/Types">Entities (Custom Post Types)</a>.</p>
        <p>Here are some useful links:</p>
        <ul>
            <li><a href="https://www.loom.com/share/865fde325efa4aac9ccc473513a42d09">Video Tutorial on how to use this boilerplate</a></li>
            <li><a href="<?php echo get_site_url(); ?>/wp-admin">Login into the WordPress admin dashboard.</a></li>
            <li>You can download the <a href="https://www.getpostman.com/apps">postman client here.</a></li>
            <li>
                <p style="margin-top: 0;">These are some examples of API endpoints you can code:</p>
                <ol style="background-color: #BDBDBD; padding: 10px 10px 10px 30px; display: inline-block;">
                    <li> GET course: <a href="<?php echo get_site_url(); ?>/wp-json/sample_api/v1/course">/course</a></li>
                    <li> GET single course: <a href="<?php echo get_site_url(); ?>/wp-json/sample_api/v1/course/1">/course/1</a></li>
                    <li> Create new course: POST to /wp-json/sample_api/v1/course</li>
                </ol>
            </li>
        </ul>
        <p style="text-align: center; margin-top: 100px;"><small>Made with <span style="color: red;">♥️</span>at <a target="_blank" href="https://4geeksacademy.com">4Geeks Academy</a></small></p>
    <?php wp_footer() ?>
    </body>
</html>
