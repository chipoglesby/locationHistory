# Analyzing your Google Location History

You can follow along with my blog posts here about how to analyze your Google
location history.

[Part One](http://www.chipoglesby.com/2018/03/2018-analyzing-google-location-historyI/)
[Part Two](http://www.chipoglesby.com/2018/03/2018-analyzing-google-location-historyII/)
[Part Three](http://www.chipoglesby.com/2018/03/analyzing-google-location-historyIII/)

In order to follow along with this project you'll need two things:

1. [A Free Tier of the Google Cloud Project, available here.](https://cloud.google.com/free/)
2. [Google Location History enabled. More info here](https://support.google.com/accounts/answer/3118687?hl=en)

If you've enabled location history with your Google Account, you can begin by
cloning this folder and [exporting your timeline](https://www.google.com/maps/timeline).

One your data has been exported, you can modify [`uploadToBigQuery.sh`](uploadToBigQuery.sh)
add add your Google Cloud project details. You'll need a cloud storage bucket,
for storage, a BigQuery dataset and table name.
