package com.soomla.cocos2dx.common;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

/**
 * @author vedi
 *         date 6/10/14
 *         time 10:42 AM
 */
public class DomainHelper {

    public static transient DomainHelper INSTANCE = null;

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
            try {
                Method method = domain.getClass().getMethod("toJSONObject");
                jsonObjectList.add((JSONObject) method.invoke(domain));
            } catch (NoSuchMethodException e) {
                throw new IllegalArgumentException(e);
            } catch (InvocationTargetException e) {
                throw new IllegalArgumentException(e);
            } catch (IllegalAccessException e) {
                throw new IllegalArgumentException(e);
            }
        }

        return jsonObjectList;
    }

}
