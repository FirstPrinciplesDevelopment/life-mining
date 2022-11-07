# `model`
**A `model` defines the schema of a trackable entity.**
A `model` is essentially an object defined in json, and a simple model can be defined like this:
```json
{
    "name": "Sleep",                           // string, required
    "description": "Duration and Quality",     // string, optional
    "fields": [],                              // list<object>, required
    "options": {},                             // object, required
    "visualizations": []                       // list<object>, optional
}
```

Let's see an example for each of those keys:

- ### `name`
    <details>
    <summary>Example</summary>
    <pre lang="json">
    "name": "Sleep"
    </pre>
    </details>

- ### `description`
    <details>
    <summary>Example</summary>
    <pre lang="json">
    "description": "Duration and Quality of Sleep"
    </pre>
    </details>

- ### `fields`
    <details>
    <summary>Detail</summary>

    A `model` must contain a list of `field` objects that defines the schema of the trackable entity. Each object in the list defines a single entity field with `name` and `widget` key-value pairs. Valid values for `field.widget.type` can be found [here](#field-widget-type). A `field` may optionally have a bool key `showOnList`; because it defaults to false, it need only be included on fields that will be shown in the list view.
    >**Note**: `field` is used as a shorthand for `fields[i]` where `i` is some index in the `fields` array of a `model`. 
    </details>

    <details>
    <summary>Example</summary>
    <pre lang="json">
    {
        "name": "Quality",
        "widget": {
            "type": "Slider",
            "min": 0,
            "max": 10,
            "step": 1,
            "minLabel": "Terrible",
            "maxLabel": "Excellent"
        }
    }
    </pre>
    </details>

- ### `options`
    <details>
    <summary>Detail</summary>

    Every `model` must have an `options` object, which has the following fields: [`aggregation`](#options-aggregation), [`limit`](#options-limit), [`reminders`](#options-reminders), and  [`singleField`](#options-singlefield).

    </details>

    <details>
    <summary>Example</summary>
    <pre lang="json">
    "options": {
        "aggregation": "none",
        "limit": "daily",
        "reminders": [
            {
                "dayOfWeek": "Saturday",
                "timeOfDay": 840  // minutes past midnight
            },
            {
                "dayOfWeek": "Sunday",
                "timeOfDay": 840  // minutes past midnight
            }
        ],
        "singleField": false
    }
    </pre>
    </details>

- ### `visualizations`
    <details>
    <summary>Detail</summary>

    Future versions will support `visualizations`.

    </details>

____

## <a name="name"></a>`name`
`String` A display and collection name for the model.

## <a name="description"></a>`description`
`String` A description to display for the model.

## <a name="fields"></a>`fields`
`Object[]` An array of `field` objects.

## <a name="field-name"></a>`field.name`
`String` The display name of this field.

## <a name="field-widget"></a>`field.widget`
### TODO: add `optionsProvider`
`Object` Defines the input Widget for a `field`. Possible keys are:
- `type`
- `min`
- `max`
- `minLabel`
- `maxLabel`
- `step`
- `numericDefault`
- `stringDefault`
- `options`
- `auto`
- `isRequired`
- `maxLength`

## <a name="field-showonlist"></a>`field.showOnList`
`bool` If true, display this field on list view for the trackable entity.
<br/>**Default:** false

## <a name="field-widget-type"></a>`field.widget.type`
`String` The type of input Widget to display on forms.
<br/>**Default:** Text
<br/>**Options:**

- Text
    - A [`TextFormField` Widget](https://api.flutter.dev/flutter/material/TextFormField-class.html).
    - Uses: `stringDefault`, `auto`, `maxLength`, `isRequired`.
    - `stringDefault` must be provided if `auto` is true.
- MultilineText
    - A [`TextFormField` Widget](https://api.flutter.dev/flutter/material/TextFormField-class.html) with `minLines: 5` and `maxLines: 10`.
    - Uses: `stringDefault`, `auto`, `maxLength`, `isRequired`.
    - `stringDefault` must be provided if `auto` is true.
- Slider
    - A [`Slider` Widget](https://api.flutter.dev/flutter/material/Slider-class.html).
    - Uses: `min`, `max`, `minLabel`, `maxLabel`, `step`, `numericDefault`, `auto`, `isRequired`.
    - `numericDefault` will be used if `auto` is true, however, it doesn't make sense to use a Slider for `auto` numeric fields, use NumberInput instead.
- NumberInput
    - A [`TextFormField` Widget](https://api.flutter.dev/flutter/material/TextFormField-class.html) that allows only `RegExp(r'[0-9]')`.
    - Uses: `min`, `max`, `step`, `numericDefault`, `auto`, `isRequired`.
    - `numericDefault` will be used if `auto` is true.
- Date
    - Displays the selected date and provides a [Material Design date picker](https://api.flutter.dev/flutter/material/showDatePicker.html) onPressed.
- DateTime
    - Displays the selected date and shows a [Material Design date picker](https://api.flutter.dev/flutter/material/showDatePicker.html) onPressed and displays the selected time of day and provides a [Material Design time picker](https://api.flutter.dev/flutter/material/showTimePicker.html) onPressed.
- DateRange
    - Displays the selected `DateTimeRange` and provides a [Material Design date range picker](https://api.flutter.dev/flutter/material/showDateRangePicker.html) onPressed.
- Timestamp
    - Hidden on forms.
    - Always automatically generated Unix timestamp, never allows user input.
- ElapsedTime
    - A [`TextFormField` Widget](https://api.flutter.dev/flutter/material/TextFormField-class.html) that allows only `RegExp(r'[0-9]')` along with a [`DropdownButton` Widget](https://api.flutter.dev/flutter/material/DropdownButton-class.html) for selecting the units (minutes, hours, etc.).
    - Uses: `stringDefault`, `options`, `numericDefault`, `isRequired`.
    - The `options` and `stringDefault` are used by the [`DropdownButton` Widget](https://api.flutter.dev/flutter/material/DropdownButton-class.html), while the `numericDefault` is used by the [`TextFormField` Widget](https://api.flutter.dev/flutter/material/TextFormField-class.html).
- Checkbox
    - A [`Checkbox` Widget](https://api.flutter.dev/flutter/material/Checkbox-class.html).
    - Uses: `auto`, `isRequired`.
    - TODO: define behavior when `auto` is true.
- Radio
    - A [`Radio<String>` Widget](https://api.flutter.dev/flutter/material/Radio-class.html).
    - Uses: `options`, `stringDefault`, `isRequired`.
- MultiSelect
    - TODO: Widget not yet implemented
    - Uses: `options`, `stringDefault`, `isRequired`.
    - If `isRequired` is true, one or more options must be selected.
    - TODO: allow comma separated `stringDefault` for multiple default selections.
- Select
    - A [`DropdownButton` Widget](https://api.flutter.dev/flutter/material/DropdownButton-class.html).
    - Uses: `options`, `stringDefault`, `isRequired`.
    - `options` must contain `stringDefault` if the latter is used.

## <a name="field-widget-min"></a>`field.widget.min`
`numeric` The minimum value a numeric field can have.
<br/>**Default:** 0

## <a name="field-widget-max"></a>`field.widget.max`
`numeric` The maximum value a numeric field can have.
<br/>**Default:** 10

## <a name="field-widget-minLabel"></a>`field.widget.minLabel`
`String` The label for the minimum value of a numeric field, gives explicit human readable meaning to a numeric value.

## <a name="field-widget-maxLabel"></a>`field.widget.maxLabel`
`String` The label for the maximum value of a numeric field, gives explicit human readable meaning to a numeric value.

## <a name="field-widget-step"></a>`field.widget.step`
`numeric` The step a numeric field input should allow.
<br/>**Default:** 1

## <a name="field-widget-numericDefault"></a>`field.widget.numericDefault`
`numeric` The default value for numeric fields.
<br/>**Default:** 0

## <a name="field-widget-stringDefault"></a>`field.widget.stringDefault`
`String` The default value for string fields.

## <a name="field-widget-options"></a>`field.widget.options`
`List<Object>` A list of options for a select input Widget.

## <a name="field-widget-option"></a>`field.widget.option`
`Object` An option for a Select, Radio or similar Widget to use.
<br/> The required key is `value` which should define the value of this option. `type` is also supported, but is not yet used. This object will be extended in future versions.
>**Note:** `option` is used as shorthand for `field.widget.options[i]` where `i` is an index of the `options` array.

## <a name="field-widget-auto"></a>`field.widget.auto`
`bool` If true, indicates that this field is automatically populated and should always take it's default value and never allow user input.
<br/>**Default:** false

## <a name="field-widget-isRequired"></a>`field.widget.isRequired`
`bool` If true, indicates that this field is required, and the trackable entity defined by the model cannot be saved without a value.
<br/>**Default:** false

## <a name="field-widget-maxLength"></a>`field.widget.maxLength`
`int?` The maximum length a string field input should allow. A null value means no maximum length. A widget definition should not contain `"maxLength" = null`, the key should simply be omitted if no length limit is desired.

## <a name="options"></a>`options`
`Object` The settings for a `model`.

## <a name="options-aggregation"></a>`options.aggregation`
`String` The time period of aggregation for the trackable entity defined by `model`.
- none
- daily
- weekly
- monthly
- yearly

## <a name="options-limit"></a>`options.limit`
`String` Limits the entry of the trackable entity defined by `model` to once per limit period.
- none
- daily
- weekly
- monthly
- yearly

## <a name="options-reminders"></a>`options.reminders`
`Object[]` An array of `reminder` objects.
<br/> In future versions reminders will be implemented as push notifications.

## <a name="options-singlefield"></a>`options.singleField`
`bool` Denotes that this `model` defines a single required field without a default value.
<br/> In future versions single field trackable entities will have a streamlined data entry UI.

## <a name="visualizations"></a>`visualizations`
`Object[]` An array of `visualization` objects.

## <a name="visualizations-name"></a>`visualizations.name`
`String` The display and identifying name for a visualization.

Will be supported in future versions.

## <a name="visualizations-figure"></a>`visualizations.figure`
`Object` Defines the fields used by the visualization, and the type of visualization to create.

Will be supported in future versions.
