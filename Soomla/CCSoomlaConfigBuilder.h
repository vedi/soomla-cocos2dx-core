/*
 Copyright (C) 2012-2015 Soomla Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#ifndef COCOS2DXCORE_ССSOOMLACONFIGBUILDER_H
#define COCOS2DXCORE_ССSOOMLACONFIGBUILDER_H

#include "cocos2d.h"

namespace soomla {
    class CCSoomlaConfigBuilder : public cocos2d::Ref {
    private:
        cocos2d::__Dictionary *_rawConfig;
    protected:
        //append to config dictionary only one entry
        bool appendConfigParameter(const char *key, cocos2d::Ref *value);
        //append to config dictionary all key/value pairs from given dictionary
        bool appendConfigParameter(cocos2d::__Dictionary *value);
    public:
        CCSoomlaConfigBuilder();
        static CCSoomlaConfigBuilder *create();
        cocos2d::__Dictionary *build();
    };
}


#endif //COCOS2DXCORE_ССSOOMLACONFIGBUILDER_H
