package com.soomla.cocos2dx.common;

import java.util.HashSet;
import java.util.Set;

/**
 * @author vedi
 *         date 6/16/14
 *         time 1:20 AM
 */
public class ServiceManager {

    @SuppressWarnings("MismatchedQueryAndUpdateOfCollection")
    private static Set<Object> services = new HashSet<Object>();

    public static void registerService(Object service) {
        services.add(service);
    }
}
