type AnyObject = Record<string, any> | any;
type JSONValue = string | number | boolean | JSONObject | JSONArray | null;

type JSONObject = {
  readonly [x in string]: JSONValue;
};

type JSONArray = readonly JSONValue[];

export type CustomScalars = {
  readonly JSONValue: JSONValue;
  readonly JSONObject: JSONObject;
  readonly AnyObject: AnyObject;
  readonly Date: any;
};
