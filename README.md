## Rep Builder

Needed the ability to build .NET projects but wanted to do so without the hassle of setting up a .NET environment, since my primary laptop is a Mac, thus Repo Builder was born.

Repo Builder is a simple form that takes a github repository to build and the email that you want the build report sent to.

In order to setup locally, do the following steps:
* Sign up for a free AppVeyor account
* Set the APPVEYOR_API_KEY environment key
* Run the bundle install
* Run the following script: ``` ruby repo_builder_app.rb```
