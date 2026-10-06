
class TrackingDataManager {
  private HashMap<String, PVector> points = new HashMap<>();
  private HashMap<String, Boolean> bools = new HashMap<>();
  private HashMap<String, Float> nums = new HashMap<>();
  private HashMap<String, String> texts = new HashMap<>();

  void load(JSONObject json) {
    clear();
    for (Object k : json.keys()) {
      String key = k.toString();
      Object val = json.get(key);
      if (val instanceof JSONArray) {
        JSONArray arr = (JSONArray) val;
        if (arr.size() >= 2) {
          points.put(key, new PVector(arr.getFloat(0), arr.getFloat(1)));
        }
      } else if (val instanceof Boolean) {
        bools.put(key, (Boolean) val);
      } else if (val instanceof Number) {
        nums.put(key, ((Number) val).floatValue());
      } else if (val instanceof String) {
        texts.put(key, (String) val);
      }
    }
  }

  void clear() {
    points.clear();
    bools.clear();
    nums.clear();
    texts.clear();
  }

  PVector getVec2(String key) {
    return points.getOrDefault(key, null);
  }

  boolean getBool(String key) {
    return bools.getOrDefault(key, false);
  }
}
