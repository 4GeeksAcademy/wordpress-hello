# WordPress Hello

WordPress boilerplate for 4Geeks Academy students

## Installation Procedure

#### 0) Prerequisites
- Make sure you have nvm 8+

#### 1) Start by installing the boilerplate

There are 3 ways of installing this:

1. Use the [Breathecode CLI](https://github.com/breatheco-de/breathecode-cli)
```bash
$ bc start:wordpress -r
```
2. Use git
```bash
$ git clone git@github.com:4GeeksAcademy/wordpress-hello.git
```
3. Just [click here](https://gitpod.io/#https://github.com/4GeeksAcademy/wordpress-hello) to use it with gitpod.

#### 2) Install the composer packages
```bash
$ composer install
```

#### 3) Create a .env file with your database and site information (on the workspace root) and run the run the installator
```bash
$ bash install.sh
```

## You are done! Start working!

Check your website, you are going to see a "Hello Rigoberto" message, you can login into the dashboard with your c9 username and the password you specified.

### - Adding API enpoints
This boilerplate comes with a sample API andpoint already, all api enpoints can be added into the **setup_api.php** file.

### - Adding Entities (Post Types)
All the Post Types configuration is done in the **setup_types.php** file.
