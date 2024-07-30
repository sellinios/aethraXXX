# React Skycons Extended

Easy to use react component for Skycons. Extended version with more icons from this [skycons fork](https://github.com/galdiuz/skycons) and option to colorize each part of the icon.

## Available skycons

![Demo gif 1](https://raw.githubusercontent.com/bartosz121/react-skycons-extended/d4caffe1eb77a9cb23703a8d6d3da8c778399127/demo-gif1.gif)

## Installation

Install **React-Skycons-Extended** with npm

```bash
  npm install react-skycons-extended
```

or

```bash
  yard add react-skycons-extended
```

## Demo

Check [Demo](https://codesandbox.io/s/react-skycons-extended-v2-0-0-mtis9b) to see it in action.

## Usage

```javascript
import {
  ReactSkycon,
  RseClearDay,
  RsePartlyCloudyNight,
} from "react-skycons-extended";

function App() {
  return (
    <div className="App">
      <ReactSkycon icon="CLEAR_DAY" />
      <ReactSkycon icon="SNOW_SHOWERS_NIGHT" />
      <RseClearDay />
      <RsePartlyCloudyNight
        size={100}
        color={{ moon: "#ff0000", light_cloud: "gray" }}
      />
    </div>
  );
}

export default App;
```

### Props

- `ReactSkycon`
  - icon:

    - CLEAR_DAY
    - CLEAR_NIGHT
    - PARTLY_CLOUDY_DAY
    - PARTLY_CLOUDY_NIGHT
    - CLOUDY
    - RAIN
    - SHOWERS_DAY
    - SHOWERS_NIGHT
    - SLEET
    - RAIN_SNOW
    - RAIN_SNOW_SHOWERS_DAY
    - RAIN_SNOW_SHOWERS_NIGHT
    - SNOW
    - SNOW_SHOWERS_DAY
    - SNOW_SHOWERS_NIGHT
    - WIND
    - FOG
    - THUNDER
    - THUNDER_RAIN
    - THUNDER_SHOWERS_DAY
    - THUNDER_SHOWERS_NIGHT
    - HAIL

  - size: number value

  - animate: `true` (default) if you want to animate the icon `false` if otherwise

  - color: One value (either hex or named) to paint whole icon to given color or object with `ColorableParts` (see below) and its color value.

    - sun
    - moon
    - light_cloud
    - cloud
    - dark_cloud
    - rain
    - snow
    - thunder
    - wind
    - leaf
    - hail
    - sleet
    - fog

or use icon components:

```javascript
<RseClearDay />
<RseClearNight color={{ moon: "red" }} />
<RsePartlyCloudyDay />
<RsePartlyCloudyNight />
<RseCloudy />
<RseRain />
<RseShowersDay />
<RseShowersNight />
<RseSleet />
<RseRainSnow />
<RseRainSnowShowersDay animate={false} />
<RseRainSnowShowersNight />
<RseSnow />
<RseSnowShowersDay size={100} />
<RseSnowShowersNight />
<RseWind color={{ leaf: "hotpink", wind: "#ff00ff" }} />
<RseFog />
<RseThunder />
<RseThunderRain />
<RseThunderShowersDay />
<RseThunderShowersNight />
<RseHail />
```
