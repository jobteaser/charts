# charts

### How It Works

I set up GitHub Pages to point to the `docs` folder. From there, I can
create and publish docs like this:

```
helm create mychart
```

### Publish
Publishing is done by a continuous deployment pipeline triggered by a merge on master.

### Install repo into helm

```
helm repo add jobteaser https://jobteaser.github.io/charts
```

### Dependencies
If your chart has some dependencies defined in `requirements.yaml`, before installing the chart, do `helm dep up` to install the dependencies. It will create a charts/ directory with .tgz files that correspond to the dependencies.