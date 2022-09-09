# Data Normality Checker

Check if your data follows a normal distribution with this web app!

---

## Usage

Install the Shiny R package on your machine with the following command:

```
install.packages("shiny")
```

Once finished installing, clone or download this repository and open the "app.R" file with Rstudio. Rstudio will automatically detect that it is a Shiny app file and a "Run App" button will appear on the top of the editor screen. Click the button to run the app.

Alternatively, with the repository cloned, open your R console and set the working directory to the absolute path where the repository was cloned:

```
setwd(path_to_cloned_repository)
```

Then, load the Shiny library and run the file "app.R":

```
library(shiny)
runApp("app.R")
```

The app will start on a new browser tab in your default browser.

## App Features
* Select any file to be input to the application by browsing the file system;
* Input a significance level *alpha* to perform a statistical normality test;
* A Shapiro-Wilk normality test is performed using the values in the first (or only) column of the input file. The p-value obtained by the statistical test is returned. Considering the null hypothesis that the data is normal, and using the significance level *alpha* given by the user:
    1. If the returned p-value is less than *alpha*, the null hypothesis is rejected and the input data is considered not normally distributed;
    2. Otherwise, the null hypothesis is accepted and the input data is considered normally distributed;
* Using the returned p-value, the user can judge the null hypothesis using any desired significance level;
* A data histogram is plotted with the data separated in bins. Thus, the user can visually see how normally distributed the data is;
* Lastly, a Q-Q plot is also created to compare the input data distribution with the theoretical data distribution of a normal distribution. The closer the points are to an identity line (y = x), the more normally distributed the input data is.

## User Interface Sample

![ui_data-normality-checker](https://user-images.githubusercontent.com/33037020/184563480-2e3eb038-0f42-40ce-aa7b-58dc6abd1a02.JPG)

*[Shiny] is a framework that allows users to develop web apps using R and embedded web languages, such as CSS and HTML. Shiny apps focus on objectiveness and simplicity: only one or two R scripts have all the code for the app.*

*This app development started with knowledge and tools discussed during the course "Data Science Bootcamp" by Fernando Amaral. The app has been upgraded and personalized, adding new functionalities.*

[//]: #

[Shiny]: <https://www.shinyapps.io>
