package com.soomla.cocos2dx.common;

import org.json.JSONObject;

import java.util.HashSet;
import java.util.Set;

/**
 * @author vedi
 *         date 6/16/14
 *         time 1:20 AM
 */
public class ServiceManager {

    private static ServiceManager INSTANCE = null;

    public static ServiceManager getInstance() {
        if (INSTANCE == null) {
            synchronized (ServiceManager.class) {
                if (INSTANCE == null) {
                    INSTANCE = new ServiceManager();
                }
            }
        }
        return INSTANCE;
    }

    @SuppressWarnings("MismatchedQueryAndUpdateOfCollection")
    private Set<Object> services = new HashSet<Object>();

    public void registerService(Object service) {
        services.add(service);
    }

    ServiceManager() {
        final NdkGlue ndkGlue = NdkGlue.getInstance();

        ndkGlue.registerCallHandler("CCServiceManager::setCommonParams", new NdkGlue.CallHandler() {
            @Override
            public void handle(JSONObject params, JSONObject retParams) throws Exception {
                JSONObject commonParams = params.optJSONObject("params");
                ParamsProvider.getInstance().setParams("common", commonParams);
            }
        });
    }

}
