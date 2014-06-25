package com.soomla.cocos2dx.common;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author vedi
 *         date 6/10/14
 *         time 10:42 AM
 */
public class DomainHelper {

    public static transient DomainHelper INSTANCE = null;

    private Map<String, String> typeClassMap = new HashMap<String, String>();
    private Map<String, String> classTypeMap = new HashMap<String, String>();

    public static DomainHelper getInstance() {
        if (INSTANCE == null) {
            synchronized (DomainHelper.class) {
                if (INSTANCE == null) {
                    INSTANCE = new DomainHelper();
                }
            }
        }
        return INSTANCE;
    }

    public void registerTypeWithClassName(String type, String className) {
        typeClassMap.put(type, className);
        classTypeMap.put(className, type);
    }

    public <T> List<T> getDomainsFromJsonObjectList(List<JSONObject> jsonObjectList, String type) {
        if (jsonObjectList == null) {
            return null;
        }

        List<T> domains = new ArrayList<T>(jsonObjectList.size());
        for (JSONObject jsonObject : jsonObjectList) {
            domains.add(DomainFactory.getInstance().<T>createWithJsonObject(jsonObject));
        }

        return domains;
    }

    public <T>List<JSONObject> getJsonObjectListFromDomains(List<T> domains) {
        if (domains == null) {
            return null;
        }

        List<JSONObject> jsonObjectList = new ArrayList<JSONObject>(domains.size());
        for (T domain : domains) {
            jsonObjectList.add(domainToJsonObject(domain));
        }

        return jsonObjectList;
    }

    public JSONObject domainToJsonObject(Object domain) {
        try {
            Method method = domain.getClass().getMethod("toJSONObject");
            final JSONObject jsonObject = (JSONObject) method.invoke(domain);
            String type = jsonObject.optString(CommonConsts.BP_TYPE, "");
            if (type == null) {
                type = classTypeMap.get(domain.getClass().getName());
                jsonObject.put(CommonConsts.BP_TYPE, type);
            }
            return jsonObject;
        } catch (NoSuchMethodException e) {
            throw new IllegalArgumentException(e);
        } catch (InvocationTargetException e) {
            throw new IllegalArgumentException(e);
        } catch (IllegalAccessException e) {
            throw new IllegalArgumentException(e);
        } catch (JSONException e) {
            throw new IllegalArgumentException(e);
        }
    }

}
