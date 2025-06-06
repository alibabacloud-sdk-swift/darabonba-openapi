import Foundation
import Tea
import TeaUtils
import AlibabaCloudCredentials
import AlibabaCloudOpenApiUtil
import AlibabacloudGatewaySPI
import DarabonbaXML

open class Client {
    public var _endpoint: String?

    public var _regionId: String?

    public var _protocol: String?

    public var _method: String?

    public var _userAgent: String?

    public var _endpointRule: String?

    public var _endpointMap: [String: String]?

    public var _suffix: String?

    public var _readTimeout: Int?

    public var _connectTimeout: Int?

    public var _httpProxy: String?

    public var _httpsProxy: String?

    public var _socks5Proxy: String?

    public var _socks5NetWork: String?

    public var _noProxy: String?

    public var _network: String?

    public var _productId: String?

    public var _maxIdleConns: Int?

    public var _endpointType: String?

    public var _openPlatformEndpoint: String?

    public var _credential: AlibabaCloudCredentials.Client?

    public var _signatureVersion: String?

    public var _signatureAlgorithm: String?

    public var _headers: [String: String]?

    public var _spi: AlibabacloudGatewaySPI.Client?

    public var _globalParameters: GlobalParameters?

    public var _key: String?

    public var _cert: String?

    public var _ca: String?

    public var _disableHttp2: Bool?

    public var _tlsMinVersion: String?

    public init(_ config: Config) throws {
        if (TeaUtils.Client.isUnset(config)) {
            throw Tea.ReuqestError([
                "code": "ParameterMissing",
                "message": "'config' can not be unset"
            ])
        }
        if (!TeaUtils.Client.empty(config.accessKeyId) && !TeaUtils.Client.empty(config.accessKeySecret)) {
            if (!TeaUtils.Client.empty(config.securityToken)) {
                config.type = "sts"
            }
            else {
                config.type = "access_key"
            }
            var credentialConfig: AlibabaCloudCredentials.Config = AlibabaCloudCredentials.Config([
                "accessKeyId": config.accessKeyId ?? "",
                "type": config.type ?? "",
                "accessKeySecret": config.accessKeySecret ?? ""
            ])
            credentialConfig.securityToken = config.securityToken
            self._credential = try AlibabaCloudCredentials.Client(credentialConfig)
        }
        else if (!TeaUtils.Client.empty(config.bearerToken)) {
            var cc: AlibabaCloudCredentials.Config = AlibabaCloudCredentials.Config([
                "type": "bearer",
                "bearerToken": config.bearerToken ?? ""
            ])
            self._credential = try AlibabaCloudCredentials.Client(cc)
        }
        else if (!TeaUtils.Client.isUnset(config.credential)) {
            self._credential = config.credential
        }
        self._endpoint = config.endpoint
        self._endpointType = config.endpointType
        self._network = config.network
        self._suffix = config.suffix
        self._protocol = config.protocol_
        self._method = config.method
        self._regionId = config.regionId
        self._userAgent = config.userAgent
        self._readTimeout = config.readTimeout
        self._connectTimeout = config.connectTimeout
        self._httpProxy = config.httpProxy
        self._httpsProxy = config.httpsProxy
        self._noProxy = config.noProxy
        self._socks5Proxy = config.socks5Proxy
        self._socks5NetWork = config.socks5NetWork
        self._maxIdleConns = config.maxIdleConns
        self._signatureVersion = config.signatureVersion
        self._signatureAlgorithm = config.signatureAlgorithm
        self._globalParameters = config.globalParameters
        self._key = config.key
        self._cert = config.cert
        self._ca = config.ca
        self._disableHttp2 = config.disableHttp2
        self._tlsMinVersion = config.tlsMinVersion
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func doRPCRequest(_ action: String, _ version: String, _ protocol_: String, _ method: String, _ authType: String, _ bodyType: String, _ request: OpenApiRequest, _ runtime: TeaUtils.RuntimeOptions) async throws -> [String: Any] {
        try request.validate()
        try runtime.validate()
        var _runtime: [String: Any] = [
            "timeouted": "retry",
            "key": TeaUtils.Client.defaultString(runtime.key, self._key),
            "cert": TeaUtils.Client.defaultString(runtime.cert, self._cert),
            "ca": TeaUtils.Client.defaultString(runtime.ca, self._ca),
            "readTimeout": TeaUtils.Client.defaultNumber(runtime.readTimeout, self._readTimeout),
            "connectTimeout": TeaUtils.Client.defaultNumber(runtime.connectTimeout, self._connectTimeout),
            "httpProxy": TeaUtils.Client.defaultString(runtime.httpProxy, self._httpProxy),
            "httpsProxy": TeaUtils.Client.defaultString(runtime.httpsProxy, self._httpsProxy),
            "noProxy": TeaUtils.Client.defaultString(runtime.noProxy, self._noProxy),
            "socks5Proxy": TeaUtils.Client.defaultString(runtime.socks5Proxy, self._socks5Proxy),
            "socks5NetWork": TeaUtils.Client.defaultString(runtime.socks5NetWork, self._socks5NetWork),
            "maxIdleConns": TeaUtils.Client.defaultNumber(runtime.maxIdleConns, self._maxIdleConns),
            "retry": [
                "retryable": Client.defaultAny(runtime.autoretry, false),
                "maxAttempts": TeaUtils.Client.defaultNumber(runtime.maxAttempts, 3)
            ],
            "backoff": [
                "policy": TeaUtils.Client.defaultString(runtime.backoffPolicy, "no"),
                "period": TeaUtils.Client.defaultNumber(runtime.backoffPeriod, 1)
            ],
            "ignoreSSL": Client.defaultAny(runtime.ignoreSSL, false),
            "tlsMinVersion": self._tlsMinVersion ?? ""
        ]
        var _lastRequest: Tea.TeaRequest? = nil
        var _lastException: Tea.TeaError? = nil
        var _now: Int32 = Tea.TeaCore.timeNow()
        var _retryTimes: Int32 = 0
        while (Tea.TeaCore.allowRetry(_runtime["retry"], _retryTimes, _now)) {
            if (_retryTimes > 0) {
                var _backoffTime: Int32 = Tea.TeaCore.getBackoffTime(_runtime["backoff"], _retryTimes)
                if (_backoffTime > 0) {
                    Tea.TeaCore.sleep(_backoffTime)
                }
            }
            _retryTimes = _retryTimes + 1
            do {
                var _request: Tea.TeaRequest = Tea.TeaRequest()
                _request.protocol_ = TeaUtils.Client.defaultString(self._protocol, protocol_)
                _request.method = method as! String
                _request.pathname = "/"
                var globalQueries: [String: String] = [:]
                var globalHeaders: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(self._globalParameters)) {
                    var globalParams: GlobalParameters = self._globalParameters!
                    if (!TeaUtils.Client.isUnset(globalParams.queries)) {
                        globalQueries = globalParams.queries ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(globalParams.headers)) {
                        globalHeaders = globalParams.headers ?? [:]
                    }
                }
                var extendsHeaders: [String: String] = [:]
                var extendsQueries: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(runtime.extendsParameters)) {
                    var extendsParameters: TeaUtils.ExtendsParameters = runtime.extendsParameters!
                    if (!TeaUtils.Client.isUnset(extendsParameters.headers)) {
                        extendsHeaders = extendsParameters.headers ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(extendsParameters.queries)) {
                        extendsQueries = extendsParameters.queries ?? [:]
                    }
                }
                _request.query = Tea.TeaConverter.merge([
                    "Action": action as! String,
                    "Format": "json",
                    "Version": version as! String,
                    "Timestamp": AlibabaCloudOpenApiUtil.Client.getTimestamp(),
                    "SignatureNonce": TeaUtils.Client.getNonce()
                ], globalQueries, extendsQueries, request.query ?? [:])
                var headers: [String: String] = try getRpcHeaders()
                if (TeaUtils.Client.isUnset(headers)) {
                    _request.headers = Tea.TeaConverter.merge([
                        "host": self._endpoint ?? "",
                        "x-acs-version": version as! String,
                        "x-acs-action": action as! String,
                        "user-agent": getUserAgent()
                    ], globalHeaders, extendsHeaders, request.headers ?? [:])
                }
                else {
                    _request.headers = Tea.TeaConverter.merge([
                        "host": self._endpoint ?? "",
                        "x-acs-version": version as! String,
                        "x-acs-action": action as! String,
                        "user-agent": getUserAgent()
                    ], globalHeaders, extendsHeaders, request.headers ?? [:], headers)
                }
                if (!TeaUtils.Client.isUnset(request.body)) {
                    var m: [String: Any] = try TeaUtils.Client.assertAsMap(request.body)
                    var tmp: [String: Any] = TeaUtils.Client.anyifyMapValue(AlibabaCloudOpenApiUtil.Client.query(m))
                    _request.body = Tea.TeaCore.toReadable(TeaUtils.Client.toFormString(tmp))
                    _request.headers["content-type"] = "application/x-www-form-urlencoded";
                }
                if (!TeaUtils.Client.equalString(authType, "Anonymous")) {
                    if (TeaUtils.Client.isUnset(self._credential)) {
                        throw Tea.ReuqestError([
                            "code": "InvalidCredentials",
                            "message": "Please set up the credentials correctly. If you are setting them through environment variables, please ensure that ALIBABA_CLOUD_ACCESS_KEY_ID and ALIBABA_CLOUD_ACCESS_KEY_SECRET are set correctly. See https://help.aliyun.com/zh/sdk/developer-reference/configure-the-alibaba-cloud-accesskey-environment-variable-on-linux-macos-and-windows-systems for more details."
                        ])
                    }
                    var credentialType: String = try await getType()
                    if (TeaUtils.Client.equalString(credentialType, "bearer")) {
                        var bearerToken: String = try await getBearerToken()
                        _request.query["BearerToken"] = bearerToken as! String;
                        _request.query["SignatureType"] = "BEARERTOKEN";
                    }
                    else {
                        var accessKeyId: String = try await getAccessKeyId()
                        var accessKeySecret: String = try await getAccessKeySecret()
                        var securityToken: String = try await getSecurityToken()
                        if (!TeaUtils.Client.empty(securityToken)) {
                            _request.query["SecurityToken"] = securityToken as! String;
                        }
                        _request.query["SignatureMethod"] = "HMAC-SHA1";
                        _request.query["SignatureVersion"] = "1.0";
                        _request.query["AccessKeyId"] = accessKeyId as! String;
                        var t: [String: Any]? = nil
                        if (!TeaUtils.Client.isUnset(request.body)) {
                            t = try TeaUtils.Client.assertAsMap(request.body)
                        }
                        var signedParam: [String: String] = Tea.TeaConverter.merge([:], _request.query, AlibabaCloudOpenApiUtil.Client.query(t))
                        _request.query["Signature"] = AlibabaCloudOpenApiUtil.Client.getRPCSignature(signedParam, _request.method, accessKeySecret);
                    }
                }
                _lastRequest = _request
                var _response: Tea.TeaResponse = try await Tea.TeaCore.doAction(_request, _runtime)
                if (TeaUtils.Client.is4xx(_response.statusCode) || TeaUtils.Client.is5xx(_response.statusCode)) {
                    var _res: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    var err: [String: Any] = try TeaUtils.Client.assertAsMap(_res)
                    var requestId: Any = Client.defaultAny(err["RequestId"], err["requestId"])
                    err["statusCode"] = _response.statusCode
                    throw Tea.ReuqestError([
                        "code": Client.defaultAny(err["Code"], err["code"]),
                        "message": "code: \(_response.statusCode), \(Client.defaultAny(err["Message"], err["message"])) request id: \(requestId)",
                        "data": err,
                        "description": Client.defaultAny(err["Description"], err["description"]),
                        "accessDeniedDetail": Client.defaultAny(err["AccessDeniedDetail"], err["accessDeniedDetail"])
                    ])
                }
                if (TeaUtils.Client.equalString(bodyType, "binary")) {
                    var resp: [String: Any] = [
                        "body": _response.body,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                    return resp as! [String: Any]
                }
                else if (TeaUtils.Client.equalString(bodyType, "byte")) {
                    var byt: [UInt8] = try await TeaUtils.Client.readAsBytes(_response.body)
                    return [
                        "body": byt as! [UInt8],
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(bodyType, "string")) {
                    var str: String = try await TeaUtils.Client.readAsString(_response.body)
                    return [
                        "body": str as! String,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(bodyType, "json")) {
                    var obj: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    var res: [String: Any] = try TeaUtils.Client.assertAsMap(obj)
                    return [
                        "body": res as! [String: Any],
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(bodyType, "array")) {
                    var arr: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    return [
                        "body": arr as! Any,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else {
                    return [
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
            }
            catch {
                if (Tea.TeaCore.isRetryable(error)) {
                    _lastException = error as! Tea.RetryableError
                    continue
                }
                throw error
            }
        }
        throw Tea.UnretryableError(_lastRequest, _lastException)
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func doROARequest(_ action: String, _ version: String, _ protocol_: String, _ method: String, _ authType: String, _ pathname: String, _ bodyType: String, _ request: OpenApiRequest, _ runtime: TeaUtils.RuntimeOptions) async throws -> [String: Any] {
        try request.validate()
        try runtime.validate()
        var _runtime: [String: Any] = [
            "timeouted": "retry",
            "key": TeaUtils.Client.defaultString(runtime.key, self._key),
            "cert": TeaUtils.Client.defaultString(runtime.cert, self._cert),
            "ca": TeaUtils.Client.defaultString(runtime.ca, self._ca),
            "readTimeout": TeaUtils.Client.defaultNumber(runtime.readTimeout, self._readTimeout),
            "connectTimeout": TeaUtils.Client.defaultNumber(runtime.connectTimeout, self._connectTimeout),
            "httpProxy": TeaUtils.Client.defaultString(runtime.httpProxy, self._httpProxy),
            "httpsProxy": TeaUtils.Client.defaultString(runtime.httpsProxy, self._httpsProxy),
            "noProxy": TeaUtils.Client.defaultString(runtime.noProxy, self._noProxy),
            "socks5Proxy": TeaUtils.Client.defaultString(runtime.socks5Proxy, self._socks5Proxy),
            "socks5NetWork": TeaUtils.Client.defaultString(runtime.socks5NetWork, self._socks5NetWork),
            "maxIdleConns": TeaUtils.Client.defaultNumber(runtime.maxIdleConns, self._maxIdleConns),
            "retry": [
                "retryable": Client.defaultAny(runtime.autoretry, false),
                "maxAttempts": TeaUtils.Client.defaultNumber(runtime.maxAttempts, 3)
            ],
            "backoff": [
                "policy": TeaUtils.Client.defaultString(runtime.backoffPolicy, "no"),
                "period": TeaUtils.Client.defaultNumber(runtime.backoffPeriod, 1)
            ],
            "ignoreSSL": Client.defaultAny(runtime.ignoreSSL, false),
            "tlsMinVersion": self._tlsMinVersion ?? ""
        ]
        var _lastRequest: Tea.TeaRequest? = nil
        var _lastException: Tea.TeaError? = nil
        var _now: Int32 = Tea.TeaCore.timeNow()
        var _retryTimes: Int32 = 0
        while (Tea.TeaCore.allowRetry(_runtime["retry"], _retryTimes, _now)) {
            if (_retryTimes > 0) {
                var _backoffTime: Int32 = Tea.TeaCore.getBackoffTime(_runtime["backoff"], _retryTimes)
                if (_backoffTime > 0) {
                    Tea.TeaCore.sleep(_backoffTime)
                }
            }
            _retryTimes = _retryTimes + 1
            do {
                var _request: Tea.TeaRequest = Tea.TeaRequest()
                _request.protocol_ = TeaUtils.Client.defaultString(self._protocol, protocol_)
                _request.method = method as! String
                _request.pathname = pathname as! String
                var globalQueries: [String: String] = [:]
                var globalHeaders: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(self._globalParameters)) {
                    var globalParams: GlobalParameters = self._globalParameters!
                    if (!TeaUtils.Client.isUnset(globalParams.queries)) {
                        globalQueries = globalParams.queries ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(globalParams.headers)) {
                        globalHeaders = globalParams.headers ?? [:]
                    }
                }
                var extendsHeaders: [String: String] = [:]
                var extendsQueries: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(runtime.extendsParameters)) {
                    var extendsParameters: TeaUtils.ExtendsParameters = runtime.extendsParameters!
                    if (!TeaUtils.Client.isUnset(extendsParameters.headers)) {
                        extendsHeaders = extendsParameters.headers ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(extendsParameters.queries)) {
                        extendsQueries = extendsParameters.queries ?? [:]
                    }
                }
                _request.headers = Tea.TeaConverter.merge([
                    "date": TeaUtils.Client.getDateUTCString(),
                    "host": self._endpoint ?? "",
                    "accept": "application/json",
                    "x-acs-signature-nonce": TeaUtils.Client.getNonce(),
                    "x-acs-signature-method": "HMAC-SHA1",
                    "x-acs-signature-version": "1.0",
                    "x-acs-version": version as! String,
                    "x-acs-action": action as! String,
                    "user-agent": TeaUtils.Client.getUserAgent(self._userAgent)
                ], globalHeaders, extendsHeaders, request.headers ?? [:])
                if (!TeaUtils.Client.isUnset(request.body)) {
                    _request.body = Tea.TeaCore.toReadable(TeaUtils.Client.toJSONString(request.body))
                    _request.headers["content-type"] = "application/json; charset=utf-8";
                }
                _request.query = Tea.TeaConverter.merge([:], globalQueries, extendsQueries)
                if (!TeaUtils.Client.isUnset(request.query)) {
                    _request.query = Tea.TeaConverter.merge([:], _request.query, request.query ?? [:])
                }
                if (!TeaUtils.Client.equalString(authType, "Anonymous")) {
                    if (TeaUtils.Client.isUnset(self._credential)) {
                        throw Tea.ReuqestError([
                            "code": "InvalidCredentials",
                            "message": "Please set up the credentials correctly. If you are setting them through environment variables, please ensure that ALIBABA_CLOUD_ACCESS_KEY_ID and ALIBABA_CLOUD_ACCESS_KEY_SECRET are set correctly. See https://help.aliyun.com/zh/sdk/developer-reference/configure-the-alibaba-cloud-accesskey-environment-variable-on-linux-macos-and-windows-systems for more details."
                        ])
                    }
                    var credentialType: String = try await getType()
                    if (TeaUtils.Client.equalString(credentialType, "bearer")) {
                        var bearerToken: String = try await getBearerToken()
                        _request.headers["x-acs-bearer-token"] = bearerToken as! String;
                        _request.headers["x-acs-signature-type"] = "BEARERTOKEN";
                    }
                    else {
                        var accessKeyId: String = try await getAccessKeyId()
                        var accessKeySecret: String = try await getAccessKeySecret()
                        var securityToken: String = try await getSecurityToken()
                        if (!TeaUtils.Client.empty(securityToken)) {
                            _request.headers["x-acs-accesskey-id"] = accessKeyId as! String;
                            _request.headers["x-acs-security-token"] = securityToken as! String;
                        }
                        var stringToSign: String = AlibabaCloudOpenApiUtil.Client.getStringToSign(_request)
                        _request.headers["authorization"] = "acs " + (accessKeyId as! String) + ":" + (AlibabaCloudOpenApiUtil.Client.getROASignature(stringToSign, accessKeySecret));
                    }
                }
                _lastRequest = _request
                var _response: Tea.TeaResponse = try await Tea.TeaCore.doAction(_request, _runtime)
                if (TeaUtils.Client.equalNumber(_response.statusCode, 204)) {
                    return [
                        "headers": _response.headers
                    ]
                }
                if (TeaUtils.Client.is4xx(_response.statusCode) || TeaUtils.Client.is5xx(_response.statusCode)) {
                    var _res: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    var err: [String: Any] = try TeaUtils.Client.assertAsMap(_res)
                    var requestId: Any = Client.defaultAny(err["RequestId"], err["requestId"])
                    requestId = Client.defaultAny(requestId, err["requestid"])
                    err["statusCode"] = _response.statusCode
                    throw Tea.ReuqestError([
                        "code": Client.defaultAny(err["Code"], err["code"]),
                        "message": "code: \(_response.statusCode), \(Client.defaultAny(err["Message"], err["message"])) request id: \(requestId)",
                        "data": err,
                        "description": Client.defaultAny(err["Description"], err["description"]),
                        "accessDeniedDetail": Client.defaultAny(err["AccessDeniedDetail"], err["accessDeniedDetail"])
                    ])
                }
                if (TeaUtils.Client.equalString(bodyType, "binary")) {
                    var resp: [String: Any] = [
                        "body": _response.body,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                    return resp as! [String: Any]
                }
                else if (TeaUtils.Client.equalString(bodyType, "byte")) {
                    var byt: [UInt8] = try await TeaUtils.Client.readAsBytes(_response.body)
                    return [
                        "body": byt as! [UInt8],
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(bodyType, "string")) {
                    var str: String = try await TeaUtils.Client.readAsString(_response.body)
                    return [
                        "body": str as! String,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(bodyType, "json")) {
                    var obj: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    var res: [String: Any] = try TeaUtils.Client.assertAsMap(obj)
                    return [
                        "body": res as! [String: Any],
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(bodyType, "array")) {
                    var arr: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    return [
                        "body": arr as! Any,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else {
                    return [
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
            }
            catch {
                if (Tea.TeaCore.isRetryable(error)) {
                    _lastException = error as! Tea.RetryableError
                    continue
                }
                throw error
            }
        }
        throw Tea.UnretryableError(_lastRequest, _lastException)
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func doROARequestWithForm(_ action: String, _ version: String, _ protocol_: String, _ method: String, _ authType: String, _ pathname: String, _ bodyType: String, _ request: OpenApiRequest, _ runtime: TeaUtils.RuntimeOptions) async throws -> [String: Any] {
        try request.validate()
        try runtime.validate()
        var _runtime: [String: Any] = [
            "timeouted": "retry",
            "key": TeaUtils.Client.defaultString(runtime.key, self._key),
            "cert": TeaUtils.Client.defaultString(runtime.cert, self._cert),
            "ca": TeaUtils.Client.defaultString(runtime.ca, self._ca),
            "readTimeout": TeaUtils.Client.defaultNumber(runtime.readTimeout, self._readTimeout),
            "connectTimeout": TeaUtils.Client.defaultNumber(runtime.connectTimeout, self._connectTimeout),
            "httpProxy": TeaUtils.Client.defaultString(runtime.httpProxy, self._httpProxy),
            "httpsProxy": TeaUtils.Client.defaultString(runtime.httpsProxy, self._httpsProxy),
            "noProxy": TeaUtils.Client.defaultString(runtime.noProxy, self._noProxy),
            "socks5Proxy": TeaUtils.Client.defaultString(runtime.socks5Proxy, self._socks5Proxy),
            "socks5NetWork": TeaUtils.Client.defaultString(runtime.socks5NetWork, self._socks5NetWork),
            "maxIdleConns": TeaUtils.Client.defaultNumber(runtime.maxIdleConns, self._maxIdleConns),
            "retry": [
                "retryable": Client.defaultAny(runtime.autoretry, false),
                "maxAttempts": TeaUtils.Client.defaultNumber(runtime.maxAttempts, 3)
            ],
            "backoff": [
                "policy": TeaUtils.Client.defaultString(runtime.backoffPolicy, "no"),
                "period": TeaUtils.Client.defaultNumber(runtime.backoffPeriod, 1)
            ],
            "ignoreSSL": Client.defaultAny(runtime.ignoreSSL, false),
            "tlsMinVersion": self._tlsMinVersion ?? ""
        ]
        var _lastRequest: Tea.TeaRequest? = nil
        var _lastException: Tea.TeaError? = nil
        var _now: Int32 = Tea.TeaCore.timeNow()
        var _retryTimes: Int32 = 0
        while (Tea.TeaCore.allowRetry(_runtime["retry"], _retryTimes, _now)) {
            if (_retryTimes > 0) {
                var _backoffTime: Int32 = Tea.TeaCore.getBackoffTime(_runtime["backoff"], _retryTimes)
                if (_backoffTime > 0) {
                    Tea.TeaCore.sleep(_backoffTime)
                }
            }
            _retryTimes = _retryTimes + 1
            do {
                var _request: Tea.TeaRequest = Tea.TeaRequest()
                _request.protocol_ = TeaUtils.Client.defaultString(self._protocol, protocol_)
                _request.method = method as! String
                _request.pathname = pathname as! String
                var globalQueries: [String: String] = [:]
                var globalHeaders: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(self._globalParameters)) {
                    var globalParams: GlobalParameters = self._globalParameters!
                    if (!TeaUtils.Client.isUnset(globalParams.queries)) {
                        globalQueries = globalParams.queries ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(globalParams.headers)) {
                        globalHeaders = globalParams.headers ?? [:]
                    }
                }
                var extendsHeaders: [String: String] = [:]
                var extendsQueries: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(runtime.extendsParameters)) {
                    var extendsParameters: TeaUtils.ExtendsParameters = runtime.extendsParameters!
                    if (!TeaUtils.Client.isUnset(extendsParameters.headers)) {
                        extendsHeaders = extendsParameters.headers ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(extendsParameters.queries)) {
                        extendsQueries = extendsParameters.queries ?? [:]
                    }
                }
                _request.headers = Tea.TeaConverter.merge([
                    "date": TeaUtils.Client.getDateUTCString(),
                    "host": self._endpoint ?? "",
                    "accept": "application/json",
                    "x-acs-signature-nonce": TeaUtils.Client.getNonce(),
                    "x-acs-signature-method": "HMAC-SHA1",
                    "x-acs-signature-version": "1.0",
                    "x-acs-version": version as! String,
                    "x-acs-action": action as! String,
                    "user-agent": TeaUtils.Client.getUserAgent(self._userAgent)
                ], globalHeaders, extendsHeaders, request.headers ?? [:])
                if (!TeaUtils.Client.isUnset(request.body)) {
                    var m: [String: Any] = try TeaUtils.Client.assertAsMap(request.body)
                    _request.body = Tea.TeaCore.toReadable(AlibabaCloudOpenApiUtil.Client.toForm(m))
                    _request.headers["content-type"] = "application/x-www-form-urlencoded";
                }
                _request.query = Tea.TeaConverter.merge([:], globalQueries, extendsQueries)
                if (!TeaUtils.Client.isUnset(request.query)) {
                    _request.query = Tea.TeaConverter.merge([:], _request.query, request.query ?? [:])
                }
                if (!TeaUtils.Client.equalString(authType, "Anonymous")) {
                    if (TeaUtils.Client.isUnset(self._credential)) {
                        throw Tea.ReuqestError([
                            "code": "InvalidCredentials",
                            "message": "Please set up the credentials correctly. If you are setting them through environment variables, please ensure that ALIBABA_CLOUD_ACCESS_KEY_ID and ALIBABA_CLOUD_ACCESS_KEY_SECRET are set correctly. See https://help.aliyun.com/zh/sdk/developer-reference/configure-the-alibaba-cloud-accesskey-environment-variable-on-linux-macos-and-windows-systems for more details."
                        ])
                    }
                    var credentialType: String = try await getType()
                    if (TeaUtils.Client.equalString(credentialType, "bearer")) {
                        var bearerToken: String = try await getBearerToken()
                        _request.headers["x-acs-bearer-token"] = bearerToken as! String;
                        _request.headers["x-acs-signature-type"] = "BEARERTOKEN";
                    }
                    else {
                        var accessKeyId: String = try await getAccessKeyId()
                        var accessKeySecret: String = try await getAccessKeySecret()
                        var securityToken: String = try await getSecurityToken()
                        if (!TeaUtils.Client.empty(securityToken)) {
                            _request.headers["x-acs-accesskey-id"] = accessKeyId as! String;
                            _request.headers["x-acs-security-token"] = securityToken as! String;
                        }
                        var stringToSign: String = AlibabaCloudOpenApiUtil.Client.getStringToSign(_request)
                        _request.headers["authorization"] = "acs " + (accessKeyId as! String) + ":" + (AlibabaCloudOpenApiUtil.Client.getROASignature(stringToSign, accessKeySecret));
                    }
                }
                _lastRequest = _request
                var _response: Tea.TeaResponse = try await Tea.TeaCore.doAction(_request, _runtime)
                if (TeaUtils.Client.equalNumber(_response.statusCode, 204)) {
                    return [
                        "headers": _response.headers
                    ]
                }
                if (TeaUtils.Client.is4xx(_response.statusCode) || TeaUtils.Client.is5xx(_response.statusCode)) {
                    var _res: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    var err: [String: Any] = try TeaUtils.Client.assertAsMap(_res)
                    err["statusCode"] = _response.statusCode
                    throw Tea.ReuqestError([
                        "code": Client.defaultAny(err["Code"], err["code"]),
                        "message": "code: \(_response.statusCode), \(Client.defaultAny(err["Message"], err["message"])) request id: \(Client.defaultAny(err["RequestId"], err["requestId"]))",
                        "data": err,
                        "description": Client.defaultAny(err["Description"], err["description"]),
                        "accessDeniedDetail": Client.defaultAny(err["AccessDeniedDetail"], err["accessDeniedDetail"])
                    ])
                }
                if (TeaUtils.Client.equalString(bodyType, "binary")) {
                    var resp: [String: Any] = [
                        "body": _response.body,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                    return resp as! [String: Any]
                }
                else if (TeaUtils.Client.equalString(bodyType, "byte")) {
                    var byt: [UInt8] = try await TeaUtils.Client.readAsBytes(_response.body)
                    return [
                        "body": byt as! [UInt8],
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(bodyType, "string")) {
                    var str: String = try await TeaUtils.Client.readAsString(_response.body)
                    return [
                        "body": str as! String,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(bodyType, "json")) {
                    var obj: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    var res: [String: Any] = try TeaUtils.Client.assertAsMap(obj)
                    return [
                        "body": res as! [String: Any],
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(bodyType, "array")) {
                    var arr: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    return [
                        "body": arr as! Any,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else {
                    return [
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
            }
            catch {
                if (Tea.TeaCore.isRetryable(error)) {
                    _lastException = error as! Tea.RetryableError
                    continue
                }
                throw error
            }
        }
        throw Tea.UnretryableError(_lastRequest, _lastException)
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func doRequest(_ params: Params, _ request: OpenApiRequest, _ runtime: TeaUtils.RuntimeOptions) async throws -> [String: Any] {
        try params.validate()
        try request.validate()
        try runtime.validate()
        var _runtime: [String: Any] = [
            "timeouted": "retry",
            "key": TeaUtils.Client.defaultString(runtime.key, self._key),
            "cert": TeaUtils.Client.defaultString(runtime.cert, self._cert),
            "ca": TeaUtils.Client.defaultString(runtime.ca, self._ca),
            "readTimeout": TeaUtils.Client.defaultNumber(runtime.readTimeout, self._readTimeout),
            "connectTimeout": TeaUtils.Client.defaultNumber(runtime.connectTimeout, self._connectTimeout),
            "httpProxy": TeaUtils.Client.defaultString(runtime.httpProxy, self._httpProxy),
            "httpsProxy": TeaUtils.Client.defaultString(runtime.httpsProxy, self._httpsProxy),
            "noProxy": TeaUtils.Client.defaultString(runtime.noProxy, self._noProxy),
            "socks5Proxy": TeaUtils.Client.defaultString(runtime.socks5Proxy, self._socks5Proxy),
            "socks5NetWork": TeaUtils.Client.defaultString(runtime.socks5NetWork, self._socks5NetWork),
            "maxIdleConns": TeaUtils.Client.defaultNumber(runtime.maxIdleConns, self._maxIdleConns),
            "retry": [
                "retryable": Client.defaultAny(runtime.autoretry, false),
                "maxAttempts": TeaUtils.Client.defaultNumber(runtime.maxAttempts, 3)
            ],
            "backoff": [
                "policy": TeaUtils.Client.defaultString(runtime.backoffPolicy, "no"),
                "period": TeaUtils.Client.defaultNumber(runtime.backoffPeriod, 1)
            ],
            "ignoreSSL": Client.defaultAny(runtime.ignoreSSL, false),
            "tlsMinVersion": self._tlsMinVersion ?? ""
        ]
        var _lastRequest: Tea.TeaRequest? = nil
        var _lastException: Tea.TeaError? = nil
        var _now: Int32 = Tea.TeaCore.timeNow()
        var _retryTimes: Int32 = 0
        while (Tea.TeaCore.allowRetry(_runtime["retry"], _retryTimes, _now)) {
            if (_retryTimes > 0) {
                var _backoffTime: Int32 = Tea.TeaCore.getBackoffTime(_runtime["backoff"], _retryTimes)
                if (_backoffTime > 0) {
                    Tea.TeaCore.sleep(_backoffTime)
                }
            }
            _retryTimes = _retryTimes + 1
            do {
                var _request: Tea.TeaRequest = Tea.TeaRequest()
                _request.protocol_ = TeaUtils.Client.defaultString(self._protocol, params.protocol_)
                _request.method = params.method ?? ""
                _request.pathname = params.pathname ?? ""
                var globalQueries: [String: String] = [:]
                var globalHeaders: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(self._globalParameters)) {
                    var globalParams: GlobalParameters = self._globalParameters!
                    if (!TeaUtils.Client.isUnset(globalParams.queries)) {
                        globalQueries = globalParams.queries ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(globalParams.headers)) {
                        globalHeaders = globalParams.headers ?? [:]
                    }
                }
                var extendsHeaders: [String: String] = [:]
                var extendsQueries: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(runtime.extendsParameters)) {
                    var extendsParameters: TeaUtils.ExtendsParameters = runtime.extendsParameters!
                    if (!TeaUtils.Client.isUnset(extendsParameters.headers)) {
                        extendsHeaders = extendsParameters.headers ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(extendsParameters.queries)) {
                        extendsQueries = extendsParameters.queries ?? [:]
                    }
                }
                _request.query = Tea.TeaConverter.merge([:], globalQueries, extendsQueries, request.query ?? [:])
                _request.headers = Tea.TeaConverter.merge([
                    "host": self._endpoint ?? "",
                    "x-acs-version": params.version ?? "",
                    "x-acs-action": params.action ?? "",
                    "user-agent": getUserAgent(),
                    "x-acs-date": AlibabaCloudOpenApiUtil.Client.getTimestamp(),
                    "x-acs-signature-nonce": TeaUtils.Client.getNonce(),
                    "accept": "application/json"
                ], globalHeaders, extendsHeaders, request.headers ?? [:])
                if (TeaUtils.Client.equalString(params.style, "RPC")) {
                    var headers: [String: String] = try getRpcHeaders()
                    if (!TeaUtils.Client.isUnset(headers)) {
                        _request.headers = Tea.TeaConverter.merge([:], _request.headers, headers)
                    }
                }
                var signatureAlgorithm: String = TeaUtils.Client.defaultString(self._signatureAlgorithm, "ACS3-HMAC-SHA256")
                var hashedRequestPayload: String = AlibabaCloudOpenApiUtil.Client.hexEncode(AlibabaCloudOpenApiUtil.Client.hash(TeaUtils.Client.toBytes(""), signatureAlgorithm))
                if (!TeaUtils.Client.isUnset(request.stream)) {
                    var tmp: [UInt8] = try await TeaUtils.Client.readAsBytes(request.stream)
                    hashedRequestPayload = AlibabaCloudOpenApiUtil.Client.hexEncode(AlibabaCloudOpenApiUtil.Client.hash(tmp, signatureAlgorithm))
                    _request.body = Tea.TeaCore.toReadable(tmp as! [UInt8])
                    _request.headers["content-type"] = "application/octet-stream";
                }
                else {
                    if (!TeaUtils.Client.isUnset(request.body)) {
                        if (TeaUtils.Client.equalString(params.reqBodyType, "byte")) {
                            var byteObj: [UInt8] = try TeaUtils.Client.assertAsBytes(request.body)
                            hashedRequestPayload = AlibabaCloudOpenApiUtil.Client.hexEncode(AlibabaCloudOpenApiUtil.Client.hash(byteObj, signatureAlgorithm))
                            _request.body = Tea.TeaCore.toReadable(byteObj as! [UInt8])
                        }
                        else if (TeaUtils.Client.equalString(params.reqBodyType, "json")) {
                            var jsonObj: String = TeaUtils.Client.toJSONString(request.body)
                            hashedRequestPayload = AlibabaCloudOpenApiUtil.Client.hexEncode(AlibabaCloudOpenApiUtil.Client.hash(TeaUtils.Client.toBytes(jsonObj), signatureAlgorithm))
                            _request.body = Tea.TeaCore.toReadable(jsonObj as! String)
                            _request.headers["content-type"] = "application/json; charset=utf-8";
                        }
                        else {
                            var m: [String: Any] = try TeaUtils.Client.assertAsMap(request.body)
                            var formObj: String = AlibabaCloudOpenApiUtil.Client.toForm(m)
                            hashedRequestPayload = AlibabaCloudOpenApiUtil.Client.hexEncode(AlibabaCloudOpenApiUtil.Client.hash(TeaUtils.Client.toBytes(formObj), signatureAlgorithm))
                            _request.body = Tea.TeaCore.toReadable(formObj as! String)
                            _request.headers["content-type"] = "application/x-www-form-urlencoded";
                        }
                    }
                }
                _request.headers["x-acs-content-sha256"] = hashedRequestPayload as! String;
                if (!TeaUtils.Client.equalString(params.authType, "Anonymous")) {
                    if (TeaUtils.Client.isUnset(self._credential)) {
                        throw Tea.ReuqestError([
                            "code": "InvalidCredentials",
                            "message": "Please set up the credentials correctly. If you are setting them through environment variables, please ensure that ALIBABA_CLOUD_ACCESS_KEY_ID and ALIBABA_CLOUD_ACCESS_KEY_SECRET are set correctly. See https://help.aliyun.com/zh/sdk/developer-reference/configure-the-alibaba-cloud-accesskey-environment-variable-on-linux-macos-and-windows-systems for more details."
                        ])
                    }
                    var authType: String = try await getType()
                    if (TeaUtils.Client.equalString(authType, "bearer")) {
                        var bearerToken: String = try await getBearerToken()
                        _request.headers["x-acs-bearer-token"] = bearerToken as! String;
                        if (TeaUtils.Client.equalString(params.style, "RPC")) {
                            _request.query["SignatureType"] = "BEARERTOKEN";
                        }
                        else {
                            _request.headers["x-acs-signature-type"] = "BEARERTOKEN";
                        }
                    }
                    else {
                        var accessKeyId: String = try await getAccessKeyId()
                        var accessKeySecret: String = try await getAccessKeySecret()
                        var securityToken: String = try await getSecurityToken()
                        if (!TeaUtils.Client.empty(securityToken)) {
                            _request.headers["x-acs-accesskey-id"] = accessKeyId as! String;
                            _request.headers["x-acs-security-token"] = securityToken as! String;
                        }
                        _request.headers["Authorization"] = AlibabaCloudOpenApiUtil.Client.getAuthorization(_request, signatureAlgorithm, hashedRequestPayload, accessKeyId, accessKeySecret);
                    }
                }
                _lastRequest = _request
                var _response: Tea.TeaResponse = try await Tea.TeaCore.doAction(_request, _runtime)
                if (TeaUtils.Client.is4xx(_response.statusCode) || TeaUtils.Client.is5xx(_response.statusCode)) {
                    var err: [String: Any] = [:]
                    if (!TeaUtils.Client.isUnset(_response.headers["content-type"]) && TeaUtils.Client.equalString(_response.headers["content-type"], "text/xml;charset=utf-8")) {
                        var _str: String = try await TeaUtils.Client.readAsString(_response.body)
                        var respMap: [String: Any] = DarabonbaXML.Client.parseXml(_str, nil)
                        err = try TeaUtils.Client.assertAsMap(respMap["Error"])
                    }
                    else {
                        var _res: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                        err = try TeaUtils.Client.assertAsMap(_res)
                    }
                    err["statusCode"] = _response.statusCode
                    throw Tea.ReuqestError([
                        "code": Client.defaultAny(err["Code"], err["code"]),
                        "message": "code: \(_response.statusCode), \(Client.defaultAny(err["Message"], err["message"])) request id: \(Client.defaultAny(err["RequestId"], err["requestId"]))",
                        "data": err,
                        "description": Client.defaultAny(err["Description"], err["description"]),
                        "accessDeniedDetail": Client.defaultAny(err["AccessDeniedDetail"], err["accessDeniedDetail"])
                    ])
                }
                if (TeaUtils.Client.equalString(params.bodyType, "binary")) {
                    var resp: [String: Any] = [
                        "body": _response.body,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                    return resp as! [String: Any]
                }
                else if (TeaUtils.Client.equalString(params.bodyType, "byte")) {
                    var byt: [UInt8] = try await TeaUtils.Client.readAsBytes(_response.body)
                    return [
                        "body": byt as! [UInt8],
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(params.bodyType, "string")) {
                    var str: String = try await TeaUtils.Client.readAsString(_response.body)
                    return [
                        "body": str as! String,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(params.bodyType, "json")) {
                    var obj: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    var res: [String: Any] = try TeaUtils.Client.assertAsMap(obj)
                    return [
                        "body": res as! [String: Any],
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else if (TeaUtils.Client.equalString(params.bodyType, "array")) {
                    var arr: Any = try await TeaUtils.Client.readAsJSON(_response.body)
                    return [
                        "body": arr as! Any,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
                else {
                    var anything: String = try await TeaUtils.Client.readAsString(_response.body)
                    return [
                        "body": anything as! String,
                        "headers": _response.headers,
                        "statusCode": _response.statusCode
                    ]
                }
            }
            catch {
                if (Tea.TeaCore.isRetryable(error)) {
                    _lastException = error as! Tea.RetryableError
                    continue
                }
                throw error
            }
        }
        throw Tea.UnretryableError(_lastRequest, _lastException)
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func execute(_ params: Params, _ request: OpenApiRequest, _ runtime: TeaUtils.RuntimeOptions) async throws -> [String: Any] {
        try params.validate()
        try request.validate()
        try runtime.validate()
        var _runtime: [String: Any] = [
            "timeouted": "retry",
            "key": TeaUtils.Client.defaultString(runtime.key, self._key),
            "cert": TeaUtils.Client.defaultString(runtime.cert, self._cert),
            "ca": TeaUtils.Client.defaultString(runtime.ca, self._ca),
            "readTimeout": TeaUtils.Client.defaultNumber(runtime.readTimeout, self._readTimeout),
            "connectTimeout": TeaUtils.Client.defaultNumber(runtime.connectTimeout, self._connectTimeout),
            "httpProxy": TeaUtils.Client.defaultString(runtime.httpProxy, self._httpProxy),
            "httpsProxy": TeaUtils.Client.defaultString(runtime.httpsProxy, self._httpsProxy),
            "noProxy": TeaUtils.Client.defaultString(runtime.noProxy, self._noProxy),
            "socks5Proxy": TeaUtils.Client.defaultString(runtime.socks5Proxy, self._socks5Proxy),
            "socks5NetWork": TeaUtils.Client.defaultString(runtime.socks5NetWork, self._socks5NetWork),
            "maxIdleConns": TeaUtils.Client.defaultNumber(runtime.maxIdleConns, self._maxIdleConns),
            "retry": [
                "retryable": Client.defaultAny(runtime.autoretry, false),
                "maxAttempts": TeaUtils.Client.defaultNumber(runtime.maxAttempts, 3)
            ],
            "backoff": [
                "policy": TeaUtils.Client.defaultString(runtime.backoffPolicy, "no"),
                "period": TeaUtils.Client.defaultNumber(runtime.backoffPeriod, 1)
            ],
            "ignoreSSL": Client.defaultAny(runtime.ignoreSSL, false),
            "disableHttp2": Client.defaultAny(self._disableHttp2, false),
            "tlsMinVersion": self._tlsMinVersion ?? ""
        ]
        var _lastRequest: Tea.TeaRequest? = nil
        var _lastException: Tea.TeaError? = nil
        var _now: Int32 = Tea.TeaCore.timeNow()
        var _retryTimes: Int32 = 0
        while (Tea.TeaCore.allowRetry(_runtime["retry"], _retryTimes, _now)) {
            if (_retryTimes > 0) {
                var _backoffTime: Int32 = Tea.TeaCore.getBackoffTime(_runtime["backoff"], _retryTimes)
                if (_backoffTime > 0) {
                    Tea.TeaCore.sleep(_backoffTime)
                }
            }
            _retryTimes = _retryTimes + 1
            do {
                var _request: Tea.TeaRequest = Tea.TeaRequest()
                var headers: [String: String] = try getRpcHeaders()
                var globalQueries: [String: String] = [:]
                var globalHeaders: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(self._globalParameters)) {
                    var globalParams: GlobalParameters = self._globalParameters!
                    if (!TeaUtils.Client.isUnset(globalParams.queries)) {
                        globalQueries = globalParams.queries ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(globalParams.headers)) {
                        globalHeaders = globalParams.headers ?? [:]
                    }
                }
                var extendsHeaders: [String: String] = [:]
                var extendsQueries: [String: String] = [:]
                if (!TeaUtils.Client.isUnset(runtime.extendsParameters)) {
                    var extendsParameters: TeaUtils.ExtendsParameters = runtime.extendsParameters!
                    if (!TeaUtils.Client.isUnset(extendsParameters.headers)) {
                        extendsHeaders = extendsParameters.headers ?? [:]
                    }
                    if (!TeaUtils.Client.isUnset(extendsParameters.queries)) {
                        extendsQueries = extendsParameters.queries ?? [:]
                    }
                }
                var requestContext: AlibabacloudGatewaySPI.InterceptorContext.Request = AlibabacloudGatewaySPI.InterceptorContext.Request([
                    "headers": Tea.TeaConverter.merge([:], globalHeaders, extendsHeaders, request.headers ?? [:], headers),
                    "query": Tea.TeaConverter.merge([:], globalQueries, extendsQueries, request.query ?? [:]),
                    "body": request.body!,
                    "stream": request.stream!,
                    "hostMap": request.hostMap ?? [:],
                    "pathname": params.pathname ?? "",
                    "productId": self._productId ?? "",
                    "action": params.action ?? "",
                    "version": params.version ?? "",
                    "protocol": TeaUtils.Client.defaultString(self._protocol, params.protocol_),
                    "method": TeaUtils.Client.defaultString(self._method, params.method),
                    "authType": params.authType ?? "",
                    "bodyType": params.bodyType ?? "",
                    "reqBodyType": params.reqBodyType ?? "",
                    "style": params.style ?? "",
                    "credential": self._credential!,
                    "signatureVersion": self._signatureVersion ?? "",
                    "signatureAlgorithm": self._signatureAlgorithm ?? "",
                    "userAgent": getUserAgent()
                ])
                var configurationContext: AlibabacloudGatewaySPI.InterceptorContext.Configuration = AlibabacloudGatewaySPI.InterceptorContext.Configuration([
                    "regionId": self._regionId ?? "",
                    "endpoint": TeaUtils.Client.defaultString(request.endpointOverride, self._endpoint),
                    "endpointRule": self._endpointRule ?? "",
                    "endpointMap": self._endpointMap ?? [:],
                    "endpointType": self._endpointType ?? "",
                    "network": self._network ?? "",
                    "suffix": self._suffix ?? ""
                ])
                var interceptorContext: AlibabacloudGatewaySPI.InterceptorContext = AlibabacloudGatewaySPI.InterceptorContext([
                    "request": requestContext as! AlibabacloudGatewaySPI.InterceptorContext.Request,
                    "configuration": configurationContext as! AlibabacloudGatewaySPI.InterceptorContext.Configuration
                ])
                var attributeMap: AlibabacloudGatewaySPI.AttributeMap = AlibabacloudGatewaySPI.AttributeMap([:])
                try await self._spi!.modifyConfiguration(interceptorContext as! AlibabacloudGatewaySPI.InterceptorContext, attributeMap as! AlibabacloudGatewaySPI.AttributeMap)
                try await self._spi!.modifyRequest(interceptorContext as! AlibabacloudGatewaySPI.InterceptorContext, attributeMap as! AlibabacloudGatewaySPI.AttributeMap)
                _request.protocol_ = interceptorContext.request!.protocol_ ?? ""
                _request.method = interceptorContext.request!.method ?? ""
                _request.pathname = interceptorContext.request!.pathname ?? ""
                _request.query = interceptorContext.request!.query ?? [:]
                _request.body = interceptorContext.request!.stream!
                _request.headers = interceptorContext.request!.headers ?? [:]
                _lastRequest = _request
                var _response: Tea.TeaResponse = try await Tea.TeaCore.doAction(_request, _runtime)
                var responseContext: AlibabacloudGatewaySPI.InterceptorContext.Response = AlibabacloudGatewaySPI.InterceptorContext.Response([
                    "statusCode": _response.statusCode,
                    "headers": _response.headers,
                    "body": _response.body
                ])
                interceptorContext.response = responseContext
                try await self._spi!.modifyResponse(interceptorContext as! AlibabacloudGatewaySPI.InterceptorContext, attributeMap as! AlibabacloudGatewaySPI.AttributeMap)
                return [
                    "headers": interceptorContext.response!.headers ?? [:],
                    "statusCode": interceptorContext.response!.statusCode!,
                    "body": interceptorContext.response!.deserializedBody!
                ]
            }
            catch {
                if (Tea.TeaCore.isRetryable(error)) {
                    _lastException = error as! Tea.RetryableError
                    continue
                }
                throw error
            }
        }
        throw Tea.UnretryableError(_lastRequest, _lastException)
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func callApi(_ params: Params, _ request: OpenApiRequest, _ runtime: TeaUtils.RuntimeOptions) async throws -> [String: Any] {
        if (TeaUtils.Client.isUnset(params)) {
            throw Tea.ReuqestError([
                "code": "ParameterMissing",
                "message": "'params' can not be unset"
            ])
        }
        if (TeaUtils.Client.isUnset(self._signatureVersion) || !TeaUtils.Client.equalString(self._signatureVersion, "v4")) {
            if (TeaUtils.Client.isUnset(self._signatureAlgorithm) || !TeaUtils.Client.equalString(self._signatureAlgorithm, "v2")) {
                return try await doRequest(params as! Params, request as! OpenApiRequest, runtime as! TeaUtils.RuntimeOptions)
            }
            else if (TeaUtils.Client.equalString(params.style, "ROA") && TeaUtils.Client.equalString(params.reqBodyType, "json")) {
                return try await doROARequest(params.action ?? "", params.version ?? "", params.protocol_ ?? "", params.method ?? "", params.authType ?? "", params.pathname ?? "", params.bodyType ?? "", request as! OpenApiRequest, runtime as! TeaUtils.RuntimeOptions)
            }
            else if (TeaUtils.Client.equalString(params.style, "ROA")) {
                return try await doROARequestWithForm(params.action ?? "", params.version ?? "", params.protocol_ ?? "", params.method ?? "", params.authType ?? "", params.pathname ?? "", params.bodyType ?? "", request as! OpenApiRequest, runtime as! TeaUtils.RuntimeOptions)
            }
            else {
                return try await doRPCRequest(params.action ?? "", params.version ?? "", params.protocol_ ?? "", params.method ?? "", params.authType ?? "", params.bodyType ?? "", request as! OpenApiRequest, runtime as! TeaUtils.RuntimeOptions)
            }
        }
        else {
            return try await execute(params as! Params, request as! OpenApiRequest, runtime as! TeaUtils.RuntimeOptions)
        }
    }

    public func getUserAgent() -> String {
        var userAgent: String = TeaUtils.Client.getUserAgent(self._userAgent)
        return userAgent as! String
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getAccessKeyId() async throws -> String {
        if (TeaUtils.Client.isUnset(self._credential)) {
            return ""
        }
        var accessKeyId: String = try await self._credential!.getAccessKeyId()
        return accessKeyId as! String
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getAccessKeySecret() async throws -> String {
        if (TeaUtils.Client.isUnset(self._credential)) {
            return ""
        }
        var secret: String = try await self._credential!.getAccessKeySecret()
        return secret as! String
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getSecurityToken() async throws -> String {
        if (TeaUtils.Client.isUnset(self._credential)) {
            return ""
        }
        var token: String = try await self._credential!.getSecurityToken()
        return token as! String
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getBearerToken() async throws -> String {
        if (TeaUtils.Client.isUnset(self._credential)) {
            return ""
        }
        var token: String = self._credential!.getBearerToken()
        return token as! String
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getType() async throws -> String {
        if (TeaUtils.Client.isUnset(self._credential)) {
            return ""
        }
        var authType: String = self._credential!.getType()
        return authType as! String
    }

    public static func defaultAny(_ inputValue: Any?, _ defaultValue: Any?) -> Any {
        if (TeaUtils.Client.isUnset(inputValue)) {
            return defaultValue as! Any
        }
        return inputValue as! Any
    }

    public func checkConfig(_ config: Config) throws -> Void {
        if (TeaUtils.Client.empty(self._endpointRule) && TeaUtils.Client.empty(config.endpoint)) {
            throw Tea.ReuqestError([
                "code": "ParameterMissing",
                "message": "'config.endpoint' can not be empty"
            ])
        }
    }

    public func setGatewayClient(_ spi: AlibabacloudGatewaySPI.Client) throws -> Void {
        self._spi = spi
    }

    public func setRpcHeaders(_ headers: [String: String]) throws -> Void {
        self._headers = headers
    }

    public func getRpcHeaders() throws -> [String: String] {
        var headers: [String: String] = self._headers ?? [:]
        self._headers = nil
        return headers as! [String: String]
    }
}
