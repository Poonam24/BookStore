# BookStorage
BookStore Application
The application enables user to login into system. Users can see the list of books and further there is provision to create new books as well. 

Disclaimer : The Newly created books is visible at end of ListView. To check that scroll down till bottom. 

The xcode Project is compartmentalized in different modules namely :

1. APIConnectionManager : Class responsible for communicating to API and sending the response back to invokee controller.
This communication is done through delegate named APIConnectionDelegate. Each ViewController is implementing the delegate method.

2. LoginViewController : Screen to enable the user authentication. In case of wrong credential, alert will be popped out. 
Considering the security of application generic error message is shown in alertView. 

3. BookListViewController : TableView/ListView which uses custom UITableViewCell name BookListCustomCell to render its content. Briefly it shows book image, author and title of book. There is no action on click on cells/rows.
This screen has one add button which is fixed at that place. Clicking on that will lead user to create book screen.

4. CreateBookViewController : Screen holding multiple mandatory input fields. On click of submit API will be called and on success the book will be created which will be intimated to users through alert on the screen. Clicking of "OKAY" of alertview will take you to back to BookListViewController.

5. Constants : Struct holding all the constants like baseURL for API call, generic error message.



######################################################################
Project Includes basic testCases under BookStorageUITests which checks the accessibility for input component on Login Page
