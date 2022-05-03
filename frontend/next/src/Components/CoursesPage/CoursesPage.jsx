
const CoursesPage = () => {

    const [courses, setCourses] = useState([])

    const getCourses = () => {
        fetch(`http://0.0.0.0:4500/next/2fe14b93-d7ef-4f6e-afb2-8bba7656f08d/courses/`, {
          "methods" : "GET",
          headers: {
              "Content-Type": "applications/json"
          }
          })
          .then(res => res.json())
          .then(res => setCourses(res.))
          .catch(err => console.log(err))
      }
  
    

}