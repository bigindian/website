###!
# angular-cache
# @version 4.4.2 - Homepage <http://jmdobry.github.io/angular-cache/>
# @author Jason Dobry <jason.dobry@gmail.com>
# @copyright (c) 2013-2015 Jason Dobry
# @license MIT <https://github.com/jmdobry/angular-cache/blob/master/LICENSE>
#
# @overview angular-cache is a very useful replacement for Angular's $cacheFactory.
###

((root, factory) ->
  if typeof exports == 'object' and typeof module == 'object'
    module.exports = factory(require('angular'))
  else if typeof define == 'function' and define.amd
    define 'angular-cache', [ 'angular' ], factory
  else if typeof exports == 'object'
    exports['angularCacheModuleName'] = factory(require('angular'))
  else
    root['angularCacheModuleName'] = factory(root['angular'])
  return
) this, (__WEBPACK_EXTERNAL_MODULE_1__) ->
  ((modules) ->
    # webpackBootstrap
    # The module cache
    installedModules = {}
    # expose the modules object (__webpack_modules__)
    # The require function

    __webpack_require__ = (moduleId) ->
      # Check if module is in cache
      if installedModules[moduleId]
        return installedModules[moduleId].exports
      # Create a new module (and put it into the cache)
      module = installedModules[moduleId] =
        exports: {}
        id: moduleId
        loaded: false
      # Execute the module function
      modules[moduleId].call module.exports, module, module.exports, __webpack_require__
      # Flag the module as loaded
      module.loaded = true
      # Return the exports of the module
      module.exports

    __webpack_require__.m = modules
    # expose the module cache
    __webpack_require__.c = installedModules
    # __webpack_public_path__
    __webpack_require__.p = ''
    # Load entry module and return exports
    __webpack_require__ 0
  ) [
    (module, exports, __webpack_require__) ->
      angular = __webpack_require__(1)
      CacheFactory = __webpack_require__(2)

      _classCallCheck = (instance, Constructor) ->
        if !(instance instanceof Constructor)
          throw new TypeError('Cannot call a class as a function')
        return

      CacheFactory.utils.equals = angular.equals
      CacheFactory.utils.isObject = angular.isObject
      CacheFactory.utils.fromJson = angular.fromJson

      BinaryHeapProvider = ->
        _classCallCheck this, BinaryHeapProvider

        @$get = ->
          CacheFactory.BinaryHeap

        return

      CacheFactoryProvider = ->
        _classCallCheck this, CacheFactoryProvider
        @defaults = CacheFactory.defaults
        @defaults.storagePrefix = 'angular-cache.caches.'
        @$get = [
          '$q'
          ($q) ->
            CacheFactory.utils.Promise = $q
            CacheFactory
        ]
        return

      angular.module('angular-cache', []).provider('BinaryHeap', BinaryHeapProvider).provider 'CacheFactory', CacheFactoryProvider
      module.exports = 'angular-cache'
      try
        module.exports.name = 'angular-cache'
      catch err

      ###*###

      return
    (module, exports) ->
      module.exports = __WEBPACK_EXTERNAL_MODULE_1__

      ###*###

      return
    (module, exports, __webpack_require__) ->

      ###!
      # cachefactory
      # @version 1.2.0 - Homepage <http://jmdobry.github.io/cachefactory/>
      # @author Jason Dobry <jason.dobry@gmail.com>
      # @copyright (c) 2013-2015 Jason Dobry
      # @license MIT <https://github.com/jmdobry/cachefactory/blob/master/LICENSE>
      #
      # @overview cachefactory is a very useful replacement for Angular's $cacheFactory.
      ###

      ((root, factory) ->
        if true
          module.exports = factory()
        else if typeof define == 'function' and define.amd
          define 'cachefactory', [], factory
        else if typeof exports == 'object'
          exports['CacheFactory'] = factory()
        else
          root['CacheFactory'] = factory()
        return
      ) this, ->
        ((modules) ->
          `var __webpack_require__`
          # webpackBootstrap
          # The module cache
          installedModules = {}
          # expose the modules object (__webpack_modules__)
          # The require function

          __webpack_require__ = (moduleId) ->
            `var module`
            # Check if module is in cache
            if installedModules[moduleId]
              return installedModules[moduleId].exports
            # Create a new module (and put it into the cache)
            module = installedModules[moduleId] =
              exports: {}
              id: moduleId
              loaded: false
            # Execute the module function
            modules[moduleId].call module.exports, module, module.exports, __webpack_require__
            # Flag the module as loaded
            module.loaded = true
            # Return the exports of the module
            module.exports

          __webpack_require__.m = modules
          # expose the module cache
          __webpack_require__.c = installedModules
          # __webpack_public_path__
          __webpack_require__.p = ''
          # Load entry module and return exports
          __webpack_require__ 0
        ) [
          (module, exports, __webpack_require__) ->
            BinaryHeap = __webpack_require__(1)
            _Promise = null

            CacheFactory = (cacheId, options) ->
              createCache cacheId, options

            try
              _Promise = window.Promise
            catch e
            utils =
              isNumber: (val) ->
                typeof val == 'number'
              isString: (val) ->
                typeof val == 'string'
              isObject: (val) ->
                val != null and typeof val == 'object'
              isFunction: (val) ->
                typeof val == 'function'
              fromJson: (val) ->
                JSON.parse val
              equals: (a, b) ->
                a == b
              Promise: _Promise

            _keys = (collection) ->
              keys = []
              key = undefined
              for key of collection
                `key = key`
                if collection.hasOwnProperty(key)
                  keys.push key
              keys

            _isPromiseLike = (v) ->
              v and typeof v.then == 'function'

            _stringifyNumber = (number) ->
              if utils.isNumber(number)
                return number.toString()
              number

            _keySet = (collection) ->
              keySet = {}
              key = undefined
              for key of collection
                `key = key`
                if collection.hasOwnProperty(key)
                  keySet[key] = key
              keySet

            defaults =
              capacity: Number.MAX_VALUE
              maxAge: Number.MAX_VALUE
              deleteOnExpire: 'none'
              onExpire: null
              cacheFlushInterval: null
              recycleFreq: 1000
              storageMode: 'memory'
              storageImpl: null
              disabled: false
              storagePrefix: 'cachefactory.caches.'
              storeOnResolve: false
              storeOnReject: false
            caches = {}

            createCache = (cacheId, options) ->
              if cacheId of caches
                throw new Error(cacheId + ' already exists!')
              else if !utils.isString(cacheId)
                throw new Error('cacheId must be a string!')
              $$data = {}
              $$promises = {}
              $$storage = null
              $$expiresHeap = new BinaryHeap(((x) ->
                x.expires
              ), utils.equals)
              $$lruHeap = new BinaryHeap(((x) ->
                x.accessed
              ), utils.equals)
              cache = caches[cacheId] =
                $$id: cacheId
                destroy: ->
                  clearInterval @$$cacheFlushIntervalId
                  clearInterval @$$recycleFreqId
                  @removeAll()
                  if $$storage
                    $$storage().removeItem @$$prefix + '.keys'
                    $$storage().removeItem @$$prefix
                  $$storage = null
                  $$data = null
                  $$lruHeap = null
                  $$expiresHeap = null
                  @$$prefix = null
                  delete caches[@$$id]
                  return
                disable: ->
                  @$$disabled = true
                  return
                enable: ->
                  delete @$$disabled
                  return
                get: (key, options) ->
                  _this = this
                  if Array.isArray(key)
                    _ret = do ->
                      keys = key
                      values = []
                      keys.forEach (key) ->
                        value = _this.get(key, options)
                        if value != null and value != undefined
                          values.push value
                        return
                      { v: values }
                    if typeof _ret == 'object'
                      return _ret.v
                  else
                    key = _stringifyNumber(key)
                    if @$$disabled
                      return
                  options = options or {}
                  if !utils.isString(key)
                    throw new Error('key must be a string!')
                  else if options and !utils.isObject(options)
                    throw new Error('options must be an object!')
                  else if options.onExpire and !utils.isFunction(options.onExpire)
                    throw new Error('options.onExpire must be a function!')
                  item = undefined
                  if $$storage
                    if $$promises[key]
                      return $$promises[key]
                    itemJson = $$storage().getItem(@$$prefix + '.data.' + key)
                    if itemJson
                      item = utils.fromJson(itemJson)
                    else
                      return
                  else
                    if !(key of $$data)
                      return
                    item = $$data[key]
                  value = item.value
                  now = (new Date).getTime()
                  if $$storage
                    $$lruHeap.remove
                      key: key
                      accessed: item.accessed
                    item.accessed = now
                    $$lruHeap.push
                      key: key
                      accessed: now
                  else
                    $$lruHeap.remove item
                    item.accessed = now
                    $$lruHeap.push item
                  if @$$deleteOnExpire == 'passive' and 'expires' of item and item.expires < now
                    @remove key
                    if @$$onExpire
                      @$$onExpire.call this, key, item.value, options.onExpire
                    else if options.onExpire
                      options.onExpire.call this, key, item.value
                    value = undefined
                  else if $$storage
                    $$storage().setItem @$$prefix + '.data.' + key, JSON.stringify(item)
                  value
                info: (key) ->
                  if key
                    item = undefined
                    if $$storage
                      itemJson = $$storage().getItem(@$$prefix + '.data.' + key)
                      if itemJson
                        item = utils.fromJson(itemJson)
                        {
                          created: item.created
                          accessed: item.accessed
                          expires: item.expires
                          isExpired: (new Date).getTime() - (item.created) > (item.maxAge or @$$maxAge)
                        }
                      else
                        undefined
                    else
                      if key of $$data
                        item = $$data[key]
                        {
                          created: item.created
                          accessed: item.accessed
                          expires: item.expires
                          isExpired: (new Date).getTime() - (item.created) > (item.maxAge or @$$maxAge)
                        }
                      else
                        undefined
                  else
                    {
                      id: @$$id
                      capacity: @$$capacity
                      maxAge: @$$maxAge
                      deleteOnExpire: @$$deleteOnExpire
                      onExpire: @$$onExpire
                      cacheFlushInterval: @$$cacheFlushInterval
                      recycleFreq: @$$recycleFreq
                      storageMode: @$$storageMode
                      storageImpl: if $$storage then $$storage() else undefined
                      disabled: ! !@$$disabled
                      size: $$lruHeap and $$lruHeap.size() or 0
                    }
                keys: ->
                  if $$storage
                    keysJson = $$storage().getItem(@$$prefix + '.keys')
                    if keysJson
                      utils.fromJson keysJson
                    else
                      []
                  else
                    _keys $$data
                keySet: ->
                  if $$storage
                    keysJson = $$storage().getItem(@$$prefix + '.keys')
                    kSet = {}
                    if keysJson
                      keys = utils.fromJson(keysJson)
                      i = 0
                      while i < keys.length
                        kSet[keys[i]] = keys[i]
                        i++
                    kSet
                  else
                    _keySet $$data
                put: (key, value, options) ->
                  _this2 = this
                  options = options or {}
                  storeOnResolve = if 'storeOnResolve' of options then ! !options.storeOnResolve else @$$storeOnResolve
                  storeOnReject = if 'storeOnReject' of options then ! !options.storeOnReject else @$$storeOnReject

                  getHandler = (store, isError) ->
                    (v) ->
                      if store
                        delete $$promises[key]
                        if utils.isObject(v) and 'status' of v and 'data' of v
                          v = [
                            v.status
                            v.data
                            v.headers()
                            v.statusText
                          ]
                          _this2.put key, v
                        else
                          _this2.put key, v
                      if isError
                        if utils.Promise
                          return utils.Promise.reject(v)
                        else
                          throw v
                      else
                        return v
                      return

                  if @$$disabled or value == null or value == undefined
                    return
                  key = _stringifyNumber(key)
                  if !utils.isString(key)
                    throw new Error('key must be a string!')
                  now = (new Date).getTime()
                  item =
                    key: key
                    value: if _isPromiseLike(value) then value.then(getHandler(storeOnResolve, false), getHandler(storeOnReject, true)) else value
                    created: now
                    accessed: now
                  if options.maxAge
                    item.maxAge = options.maxAge
                  item.expires = item.created + (item.maxAge or @$$maxAge)
                  if $$storage
                    if _isPromiseLike(item.value)
                      $$promises[key] = item.value
                      return $$promises[key]
                    keysJson = $$storage().getItem(@$$prefix + '.keys')
                    keys = if keysJson then utils.fromJson(keysJson) else []
                    itemJson = $$storage().getItem(@$$prefix + '.data.' + key)
                    # Remove existing
                    if itemJson
                      @remove key
                    # Add to expires heap
                    $$expiresHeap.push
                      key: key
                      expires: item.expires
                    # Add to lru heap
                    $$lruHeap.push
                      key: key
                      accessed: item.accessed
                    # Set item
                    $$storage().setItem @$$prefix + '.data.' + key, JSON.stringify(item)
                    exists = false
                    i = 0
                    while i < keys.length
                      if keys[i] == key
                        exists = true
                        break
                      i++
                    if !exists
                      keys.push key
                    $$storage().setItem @$$prefix + '.keys', JSON.stringify(keys)
                  else
                    # Remove existing
                    if $$data[key]
                      @remove key
                    # Add to expires heap
                    $$expiresHeap.push item
                    # Add to lru heap
                    $$lruHeap.push item
                    # Set item
                    $$data[key] = item
                    delete $$promises[key]
                  # Handle exceeded capacity
                  if $$lruHeap.size() > @$$capacity
                    @remove $$lruHeap.peek().key
                  value
                remove: (key) ->
                  key += ''
                  delete $$promises[key]
                  if $$storage
                    itemJson = $$storage().getItem(@$$prefix + '.data.' + key)
                    if itemJson
                      item = utils.fromJson(itemJson)
                      $$lruHeap.remove
                        key: key
                        accessed: item.accessed
                      $$expiresHeap.remove
                        key: key
                        expires: item.expires
                      $$storage().removeItem @$$prefix + '.data.' + key
                      keysJson = $$storage().getItem(@$$prefix + '.keys')
                      keys = if keysJson then utils.fromJson(keysJson) else []
                      index = keys.indexOf(key)
                      if index >= 0
                        keys.splice index, 1
                      $$storage().setItem @$$prefix + '.keys', JSON.stringify(keys)
                      return item.value
                  else
                    value = if $$data[key] then $$data[key].value else undefined
                    $$lruHeap.remove $$data[key]
                    $$expiresHeap.remove $$data[key]
                    $$data[key] = null
                    delete $$data[key]
                    return value
                  return
                removeAll: ->
                  if $$storage
                    $$lruHeap.removeAll()
                    $$expiresHeap.removeAll()
                    keysJson = $$storage().getItem(@$$prefix + '.keys')
                    if keysJson
                      keys = utils.fromJson(keysJson)
                      i = 0
                      while i < keys.length
                        @remove keys[i]
                        i++
                    $$storage().setItem @$$prefix + '.keys', JSON.stringify([])
                  else
                    $$lruHeap.removeAll()
                    $$expiresHeap.removeAll()
                    for key of $$data
                      $$data[key] = null
                    $$data = {}
                  $$promises = {}
                  return
                removeExpired: ->
                  now = (new Date).getTime()
                  expired = {}
                  key = undefined
                  expiredItem = undefined
                  while (expiredItem = $$expiresHeap.peek()) and expiredItem.expires <= now
                    expired[expiredItem.key] = if expiredItem.value then expiredItem.value else null
                    $$expiresHeap.pop()
                  if $$storage
                    for key of expired
                      `key = key`
                      itemJson = $$storage().getItem(@$$prefix + '.data.' + key)
                      if itemJson
                        expired[key] = utils.fromJson(itemJson).value
                        @remove key
                  else
                    for key of expired
                      `key = key`
                      @remove key
                  if @$$onExpire
                    for key of expired
                      `key = key`
                      @$$onExpire.call this, key, expired[key]
                  expired
                setCacheFlushInterval: (cacheFlushInterval) ->
                  if cacheFlushInterval == null
                    delete @$$cacheFlushInterval
                  else if !utils.isNumber(cacheFlushInterval)
                    throw new Error('cacheFlushInterval must be a number!')
                  else if cacheFlushInterval < 0
                    throw new Error('cacheFlushInterval must be greater than zero!')
                  else if cacheFlushInterval != @$$cacheFlushInterval
                    @$$cacheFlushInterval = cacheFlushInterval
                    clearInterval @$$cacheFlushIntervalId
                    ((self) ->
                      self.$$cacheFlushIntervalId = setInterval((->
                        self.removeAll()
                        return
                      ), self.$$cacheFlushInterval)
                      return
                    ) this
                  return
                setCapacity: (capacity) ->
                  if capacity == null
                    delete @$$capacity
                  else if !utils.isNumber(capacity)
                    throw new Error('capacity must be a number!')
                  else if capacity < 0
                    throw new Error('capacity must be greater than zero!')
                  else
                    @$$capacity = capacity
                  removed = {}
                  while $$lruHeap.size() > @$$capacity
                    removed[$$lruHeap.peek().key] = @remove($$lruHeap.peek().key)
                  removed
                setDeleteOnExpire: (deleteOnExpire, setRecycleFreq) ->
                  if deleteOnExpire == null
                    delete @$$deleteOnExpire
                  else if !utils.isString(deleteOnExpire)
                    throw new Error('deleteOnExpire must be a string!')
                  else if deleteOnExpire != 'none' and deleteOnExpire != 'passive' and deleteOnExpire != 'aggressive'
                    throw new Error('deleteOnExpire must be "none", "passive" or "aggressive"!')
                  else
                    @$$deleteOnExpire = deleteOnExpire
                  if setRecycleFreq != false
                    @setRecycleFreq @$$recycleFreq
                  return
                setMaxAge: (maxAge) ->
                  if maxAge == null
                    @$$maxAge = Number.MAX_VALUE
                  else if !utils.isNumber(maxAge)
                    throw new Error('maxAge must be a number!')
                  else if maxAge < 0
                    throw new Error('maxAge must be greater than zero!')
                  else
                    @$$maxAge = maxAge
                  i = undefined
                  keys = undefined
                  key = undefined
                  $$expiresHeap.removeAll()
                  if $$storage
                    keysJson = $$storage().getItem(@$$prefix + '.keys')
                    keys = if keysJson then utils.fromJson(keysJson) else []
                    i = 0
                    while i < keys.length
                      key = keys[i]
                      itemJson = $$storage().getItem(@$$prefix + '.data.' + key)
                      if itemJson
                        item = utils.fromJson(itemJson)
                        if @$$maxAge == Number.MAX_VALUE
                          item.expires = Number.MAX_VALUE
                        else
                          item.expires = item.created + (item.maxAge or @$$maxAge)
                        $$expiresHeap.push
                          key: key
                          expires: item.expires
                      i++
                  else
                    keys = _keys($$data)
                    i = 0
                    while i < keys.length
                      key = keys[i]
                      if @$$maxAge == Number.MAX_VALUE
                        $$data[key].expires = Number.MAX_VALUE
                      else
                        $$data[key].expires = $$data[key].created + ($$data[key].maxAge or @$$maxAge)
                      $$expiresHeap.push $$data[key]
                      i++
                  if @$$deleteOnExpire == 'aggressive'
                    @removeExpired()
                  else
                    {}
                setOnExpire: (onExpire) ->
                  if onExpire == null
                    delete @$$onExpire
                  else if !utils.isFunction(onExpire)
                    throw new Error('onExpire must be a function!')
                  else
                    @$$onExpire = onExpire
                  return
                setOptions: (cacheOptions, strict) ->
                  cacheOptions = cacheOptions or {}
                  strict = ! !strict
                  if !utils.isObject(cacheOptions)
                    throw new Error('cacheOptions must be an object!')
                  if 'storagePrefix' of cacheOptions
                    @$$storagePrefix = cacheOptions.storagePrefix
                  else if strict
                    @$$storagePrefix = defaults.storagePrefix
                  @$$prefix = @$$storagePrefix + @$$id
                  if 'disabled' of cacheOptions
                    @$$disabled = ! !cacheOptions.disabled
                  else if strict
                    @$$disabled = defaults.disabled
                  if 'storageMode' of cacheOptions or 'storageImpl' of cacheOptions
                    @setStorageMode cacheOptions.storageMode or defaults.storageMode, cacheOptions.storageImpl or defaults.storageImpl
                  else if strict
                    @setStorageMode defaults.storageMode, defaults.storageImpl
                  if 'storeOnResolve' of cacheOptions
                    @$$storeOnResolve = ! !cacheOptions.storeOnResolve
                  else if strict
                    @$$storeOnResolve = defaults.storeOnResolve
                  if 'storeOnReject' of cacheOptions
                    @$$storeOnReject = ! !cacheOptions.storeOnReject
                  else if strict
                    @$$storeOnReject = defaults.storeOnReject
                  if 'capacity' of cacheOptions
                    @setCapacity cacheOptions.capacity
                  else if strict
                    @setCapacity defaults.capacity
                  if 'deleteOnExpire' of cacheOptions
                    @setDeleteOnExpire cacheOptions.deleteOnExpire, false
                  else if strict
                    @setDeleteOnExpire defaults.deleteOnExpire, false
                  if 'maxAge' of cacheOptions
                    @setMaxAge cacheOptions.maxAge
                  else if strict
                    @setMaxAge defaults.maxAge
                  if 'recycleFreq' of cacheOptions
                    @setRecycleFreq cacheOptions.recycleFreq
                  else if strict
                    @setRecycleFreq defaults.recycleFreq
                  if 'cacheFlushInterval' of cacheOptions
                    @setCacheFlushInterval cacheOptions.cacheFlushInterval
                  else if strict
                    @setCacheFlushInterval defaults.cacheFlushInterval
                  if 'onExpire' of cacheOptions
                    @setOnExpire cacheOptions.onExpire
                  else if strict
                    @setOnExpire defaults.onExpire
                  return
                setRecycleFreq: (recycleFreq) ->
                  if recycleFreq == null
                    delete @$$recycleFreq
                  else if !utils.isNumber(recycleFreq)
                    throw new Error('recycleFreq must be a number!')
                  else if recycleFreq < 0
                    throw new Error('recycleFreq must be greater than zero!')
                  else
                    @$$recycleFreq = recycleFreq
                  clearInterval @$$recycleFreqId
                  if @$$deleteOnExpire == 'aggressive'
                    ((self) ->
                      self.$$recycleFreqId = setInterval((->
                        self.removeExpired()
                        return
                      ), self.$$recycleFreq)
                      return
                    ) this
                  else
                    delete @$$recycleFreqId
                  return
                setStorageMode: (storageMode, storageImpl) ->
                  if !utils.isString(storageMode)
                    throw new Error('storageMode must be a string!')
                  else if storageMode != 'memory' and storageMode != 'localStorage' and storageMode != 'sessionStorage'
                    throw new Error('storageMode must be "memory", "localStorage" or "sessionStorage"!')
                  shouldReInsert = false
                  items = {}
                  keys = @keys()
                  if keys.length
                    i = 0
                    while i < keys.length
                      items[keys[i]] = @get(keys[i])
                      i++
                    i = 0
                    while i < keys.length
                      @remove keys[i]
                      i++
                    shouldReInsert = true
                  @$$storageMode = storageMode
                  if storageImpl
                    if !utils.isObject(storageImpl)
                      throw new Error('storageImpl must be an object!')
                    else if !('setItem' of storageImpl) or typeof storageImpl.setItem != 'function'
                      throw new Error('storageImpl must implement "setItem(key, value)"!')
                    else if !('getItem' of storageImpl) or typeof storageImpl.getItem != 'function'
                      throw new Error('storageImpl must implement "getItem(key)"!')
                    else if !('removeItem' of storageImpl) or typeof storageImpl.removeItem != 'function'
                      throw new Error('storageImpl must implement "removeItem(key)"!')

                    $$storage = ->
                      storageImpl

                  else if @$$storageMode == 'localStorage'
                    try
                      localStorage.setItem 'cachefactory', 'cachefactory'
                      localStorage.removeItem 'cachefactory'

                      $$storage = ->
                        localStorage

                    catch e
                      $$storage = null
                      @$$storageMode = 'memory'
                  else if @$$storageMode == 'sessionStorage'
                    try
                      sessionStorage.setItem 'cachefactory', 'cachefactory'
                      sessionStorage.removeItem 'cachefactory'

                      $$storage = ->
                        sessionStorage

                    catch e
                      $$storage = null
                      @$$storageMode = 'memory'
                  if shouldReInsert
                    for key of items
                      @put key, items[key]
                  return
                touch: (key) ->
                  _this3 = this
                  if key
                    val = @get(key, onExpire: (k, v) ->
                      _this3.put k, v
                    )
                    if val
                      @put key, val
                  else
                    keys = @keys()
                    i = 0
                    while i < keys.length
                      @touch keys[i]
                      i++
                  return
              cache.setOptions options, true
              cache

            CacheFactory.createCache = createCache
            CacheFactory.defaults = defaults

            CacheFactory.info = ->
              keys = _keys(caches)
              info =
                size: keys.length
                caches: {}
              for opt of defaults
                if defaults.hasOwnProperty(opt)
                  info[opt] = defaults[opt]
              i = 0
              while i < keys.length
                key = keys[i]
                info.caches[key] = caches[key].info()
                i++
              info

            CacheFactory.get = (cacheId) ->
              caches[cacheId]

            CacheFactory.keySet = ->
              _keySet caches

            CacheFactory.keys = ->
              _keys caches

            CacheFactory.destroy = (cacheId) ->
              if caches[cacheId]
                caches[cacheId].destroy()
                delete caches[cacheId]
              return

            CacheFactory.destroyAll = ->
              for cacheId of caches
                caches[cacheId].destroy()
              caches = {}
              return

            CacheFactory.clearAll = ->
              for cacheId of caches
                caches[cacheId].removeAll()
              return

            CacheFactory.removeExpiredFromAll = ->
              expired = {}
              for cacheId of caches
                expired[cacheId] = caches[cacheId].removeExpired()
              expired

            CacheFactory.enableAll = ->
              for cacheId of caches
                caches[cacheId].$$disabled = false
              return

            CacheFactory.disableAll = ->
              for cacheId of caches
                caches[cacheId].$$disabled = true
              return

            CacheFactory.touchAll = ->
              for cacheId of caches
                caches[cacheId].touch()
              return

            CacheFactory.utils = utils
            CacheFactory.BinaryHeap = BinaryHeap
            module.exports = CacheFactory

            ###*###

            return
          (module, exports, __webpack_require__) ->

            ###!
            # yabh
            # @version 1.1.0 - Homepage <http://jmdobry.github.io/yabh/>
            # @author Jason Dobry <jason.dobry@gmail.com>
            # @copyright (c) 2015 Jason Dobry
            # @license MIT <https://github.com/jmdobry/yabh/blob/master/LICENSE>
            #
            # @overview Yet another Binary Heap.
            ###

            ((root, factory) ->
              if true
                module.exports = factory()
              else if typeof define == 'function' and define.amd
                define 'yabh', factory
              else if typeof exports == 'object'
                exports['BinaryHeap'] = factory()
              else
                root['BinaryHeap'] = factory()
              return
            ) this, ->
              ((modules) ->
                `var __webpack_require__`
                # webpackBootstrap
                # The module cache
                installedModules = {}
                # expose the modules object (__webpack_modules__)
                # The require function

                __webpack_require__ = (moduleId) ->
                  `var module`
                  # Check if module is in cache
                  if installedModules[moduleId]
                    return installedModules[moduleId].exports
                  # Create a new module (and put it into the cache)
                  module = installedModules[moduleId] =
                    exports: {}
                    id: moduleId
                    loaded: false
                  # Execute the module function
                  modules[moduleId].call module.exports, module, module.exports, __webpack_require__
                  # Flag the module as loaded
                  module.loaded = true
                  # Return the exports of the module
                  module.exports

                __webpack_require__.m = modules
                # expose the module cache
                __webpack_require__.c = installedModules
                # __webpack_public_path__
                __webpack_require__.p = ''
                # Load entry module and return exports
                __webpack_require__ 0
              ) [ (module, exports, __webpack_require__) ->

                ###*
                # @method bubbleDown
                # @param {array} heap The heap.
                # @param {function} weightFunc The weight function.
                # @param {number} n The index of the element to sink down.
                ###

                bubbleDown = (heap, weightFunc, n) ->
                  length = heap.length
                  node = heap[n]
                  nodeWeight = weightFunc(node)
                  loop
                    child2N = (n + 1) * 2
                    child1N = child2N - 1
                    swap = null
                    if child1N < length
                      child1 = heap[child1N]
                      child1Weight = weightFunc(child1)
                      # If the score is less than our node's, we need to swap.
                      if child1Weight < nodeWeight
                        swap = child1N
                    # Do the same checks for the other child.
                    if child2N < length
                      child2 = heap[child2N]
                      child2Weight = weightFunc(child2)
                      if child2Weight < (if swap == null then nodeWeight else weightFunc(heap[child1N]))
                        swap = child2N
                    if swap == null
                      break
                    else
                      heap[n] = heap[swap]
                      heap[swap] = node
                      n = swap
                  return

                BHProto = BinaryHeap.prototype

                ###*
                # @method bubbleUp
                # @param {array} heap The heap.
                # @param {function} weightFunc The weight function.
                # @param {number} n The index of the element to bubble up.
                ###

                bubbleUp = (heap, weightFunc, n) ->
                  element = heap[n]
                  weight = weightFunc(element)
                  # When at 0, an element can not go up any further.
                  while n > 0
                    # Compute the parent element's index, and fetch it.
                    parentN = Math.floor((n + 1) / 2) - 1
                    _parent = heap[parentN]
                    # If the parent has a lesser weight, things are in order and we
                    # are done.
                    if weight >= weightFunc(_parent)
                      break
                    else
                      heap[parentN] = element
                      heap[n] = _parent
                      n = parentN
                  return

                BinaryHeap = (weightFunc, compareFunc) ->
                  if !weightFunc

                    weightFunc = (x) ->
                      x

                  if !compareFunc

                    compareFunc = (x, y) ->
                      x == y

                  if typeof weightFunc != 'function'
                    throw new Error('BinaryHeap([weightFunc][, compareFunc]): "weightFunc" must be a function!')
                  if typeof compareFunc != 'function'
                    throw new Error('BinaryHeap([weightFunc][, compareFunc]): "compareFunc" must be a function!')
                  @weightFunc = weightFunc
                  @compareFunc = compareFunc
                  @heap = []
                  return

                BHProto.push = (node) ->
                  @heap.push node
                  bubbleUp @heap, @weightFunc, @heap.length - 1
                  return

                BHProto.peek = ->
                  @heap[0]

                BHProto.pop = ->
                  front = @heap[0]
                  end = @heap.pop()
                  if @heap.length > 0
                    @heap[0] = end
                    bubbleDown @heap, @weightFunc, 0
                  front

                BHProto.remove = (node) ->
                  length = @heap.length
                  i = 0
                  while i < length
                    if @compareFunc(@heap[i], node)
                      removed = @heap[i]
                      end = @heap.pop()
                      if i != length - 1
                        @heap[i] = end
                        bubbleUp @heap, @weightFunc, i
                        bubbleDown @heap, @weightFunc, i
                      return removed
                    i++
                  null

                BHProto.removeAll = ->
                  @heap = []
                  return

                BHProto.size = ->
                  @heap.length

                module.exports = BinaryHeap

                ###*###

                return
 ]

            ###*###

            return
        ]

      ###*###

      return
  ]

# ---
# generated by js2coffee 2.1.0