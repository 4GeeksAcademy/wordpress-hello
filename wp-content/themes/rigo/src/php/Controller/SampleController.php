<?php
namespace Rigo\Controller;

use Rigo\Types\Course;
use \WP_REST_Request;

class SampleController{
    
    public function getHomeData(){
        return [
            'name' => 'Rigoberto'
        ];
    }
    
    public function getSingleCourse(WP_REST_Request $request){
        $id = (string) $request['id'];
        return Course::get($id);
    }
    
    public function getAllCourse(WP_REST_Request $request){
        
        //get all posts
        $query = Course::all();
        return $query;//Always return an Array type
    }
    
    public function getCoursesByType(WP_REST_Request $request){
        
        $query = Course::all([ 'status' => 'draft' ]);
        return $query->posts;
    }
    
    public function createCourse(WP_REST_Request $request){

        $body = json_decode($request->get_body());
        
        $id = Course::create([
            'post_title'    => $body->title,
            ]);
            return $id;
    }

    
    public function deleteCourse(WP_REST_Request $request){
        $id = (string) $request['id'];
        // result is true on success, false on failure
        $result = Course::delete($id);
        return $result;
    }
        
        
    /**
     * Using Custom Post types to add new properties to the course
     */
    public function getCoursesWithCustomFields(WP_REST_Request $request){
        
        $courses = [];
        $query = Course::all([ 'status' => 'draft' ]);
        foreach($query->posts as $course){
            $courses[] = array(
                "ID" => $course->ID,
                "post_title" => $course->post_title,
                "schedule_type" => get_field('schedule_type', $course->ID)
            );
        }
        return $courses;
    }
}
?>