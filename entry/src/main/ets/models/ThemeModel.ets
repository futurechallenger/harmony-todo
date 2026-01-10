import { ConfigurationConstant } from "@kit.AbilityKit";

@ObservedV2
export class ThemeModel {
  @Trace currentColorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT

  constructor(initialMode?: ConfigurationConstant.ColorMode) {
    if (initialMode) {
      this.currentColorMode = initialMode
    }
  }
}