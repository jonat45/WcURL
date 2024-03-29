(***************************************************************************
 *
 * Projeto          WcURL
 *                  � um Wrapper para biblioteca cURL (libcurl.dll)
 *
 * Jonatas Alves <jonatasdeaalves@gmail.com>
 *
 ***************************************************************************)

unit AES_WcURL;

interface
uses
     SysUtils,                Classes,                 Types,
     winsock2;

const
     // Porque CURL_EXTERN � igual "libcurl.dll"?
     // Leia abaixo a mensagem...
     (*
          module_static.dll will have nothing to export because of 'CURL_STATICLIB'. I.e.
          'CURL_EXTERN' in <curl/curl.h> is not '__declspec(dllimport)' as is required when
          using libcurl dynamically.
     *)
     //  ...que existe no link abaixo
     // https://curl.se/mail/lib-2011-08/0260.html
     CURL_EXTERN = 'libcurl.dll';


     (* This is the version number of the libcurl package from which this header
     file origins: *)
     //   #define LIBCURL_VERSION "8.6.0"
     LIBCURL_VERSION = '8.6.0';

     (* The CURLPROTO_ defines below are for the **deprecated** CURLOPT_*PROTOCOLS
     options. Do not use.
     #define CURLPROTO_HTTP   (1<<0)
     #define CURLPROTO_HTTPS  (1<<1)
     #define CURLPROTO_FTP    (1<<2)
     #define CURLPROTO_FTPS   (1<<3)
     #define CURLPROTO_SCP    (1<<4)
     #define CURLPROTO_SFTP   (1<<5)
     #define CURLPROTO_TELNET (1<<6)
     #define CURLPROTO_LDAP   (1<<7)
     #define CURLPROTO_LDAPS  (1<<8)
     #define CURLPROTO_DICT   (1<<9)
     #define CURLPROTO_FILE   (1<<10)
     #define CURLPROTO_TFTP   (1<<11)
     #define CURLPROTO_IMAP   (1<<12)
     #define CURLPROTO_IMAPS  (1<<13)
     #define CURLPROTO_POP3   (1<<14)
     #define CURLPROTO_POP3S  (1<<15)
     #define CURLPROTO_SMTP   (1<<16)
     #define CURLPROTO_SMTPS  (1<<17)
     #define CURLPROTO_RTSP   (1<<18)
     #define CURLPROTO_RTMP   (1<<19)
     #define CURLPROTO_RTMPT  (1<<20)
     #define CURLPROTO_RTMPE  (1<<21)
     #define CURLPROTO_RTMPTE (1<<22)
     #define CURLPROTO_RTMPS  (1<<23)
     #define CURLPROTO_RTMPTS (1<<24)
     #define CURLPROTO_GOPHER (1<<25)
     #define CURLPROTO_SMB    (1<<26)
     #define CURLPROTO_SMBS   (1<<27)
     #define CURLPROTO_MQTT   (1<<28)
     #define CURLPROTO_GOPHERS (1<<29)
     #define CURLPROTO_ALL    (~0) /* enable everything */
     *)
     CURLPROTO_HTTP      = 1 shl 0;
     CURLPROTO_HTTPS     = 1 shl 1;
     CURLPROTO_FTP       = 1 shl 2;
     CURLPROTO_FTPS      = 1 shl 3;
     CURLPROTO_SCP       = 1 shl 4;
     CURLPROTO_SFTP      = 1 shl 5;
     CURLPROTO_TELNET    = 1 shl 6;
     CURLPROTO_LDAP      = 1 shl 7;
     CURLPROTO_LDAPS     = 1 shl 8;
     CURLPROTO_DICT      = 1 shl 9;
     CURLPROTO_FILE      = 1 shl 10;
     CURLPROTO_TFTP      = 1 shl 11;
     CURLPROTO_IMAP      = 1 shl 12;
     CURLPROTO_IMAPS     = 1 shl 13;
     CURLPROTO_POP3      = 1 shl 14;
     CURLPROTO_POP3S     = 1 shl 15;
     CURLPROTO_SMTP      = 1 shl 16;
     CURLPROTO_SMTPS     = 1 shl 17;
     CURLPROTO_RTSP      = 1 shl 18;
     CURLPROTO_RTMP      = 1 shl 19;
     CURLPROTO_RTMPT     = 1 shl 20;
     CURLPROTO_RTMPE     = 1 shl 21;
     CURLPROTO_RTMPTE    = 1 shl 22;
     CURLPROTO_RTMPS     = 1 shl 23;
     CURLPROTO_RTMPTS    = 1 shl 24;
     CURLPROTO_GOPHER    = 1 shl 25;
     CURLPROTO_SMB       = 1 shl 26;
     CURLPROTO_SMBS      = 1 shl 27;
     CURLPROTO_MQTT      = 1 shl 28;
     CURLPROTO_GOPHERS   = 1 shl 29;
     CURLPROTO_ALL       = not 0;

     (* long may be 32 or 64 bits, but we should never depend on anything else
     but 32
     #define CURLOPTTYPE_LONG          0
     #define CURLOPTTYPE_OBJECTPOINT   10000
     #define CURLOPTTYPE_FUNCTIONPOINT 20000
     #define CURLOPTTYPE_OFF_T         30000
     #define CURLOPTTYPE_BLOB          40000
     *)
     CURLOPTTYPE_LONG              = 0;
     CURLOPTTYPE_OBJECTPOINT       = 10000;
     CURLOPTTYPE_FUNCTIONPOINT     = 20000;
     CURLOPTTYPE_OFF_T             = 30000;
     CURLOPTTYPE_BLOB              = 40000;

     (* CURLOPT aliases that make no run-time difference *)

     (* 'char *' argument to a string with a trailing zero
     #define CURLOPTTYPE_STRINGPOINT CURLOPTTYPE_OBJECTPOINT
     *)
     CURLOPTTYPE_STRINGPOINT       = CURLOPTTYPE_OBJECTPOINT;
     (* 'struct curl_slist *' argument */
     #define CURLOPTTYPE_SLISTPOINT  CURLOPTTYPE_OBJECTPOINT
     *)
     CURLOPTTYPE_SLISTPOINT        = CURLOPTTYPE_OBJECTPOINT;
     (* 'void *' argument passed untouched to callback */
     #define CURLOPTTYPE_CBPOINT     CURLOPTTYPE_OBJECTPOINT
     *)
     CURLOPTTYPE_CBPOINT           = CURLOPTTYPE_OBJECTPOINT;
     (* 'long' argument with a set of values/bitmask
     #define CURLOPTTYPE_VALUES      CURLOPTTYPE_LONG
     *)
     CURLOPTTYPE_VALUES            = CURLOPTTYPE_LONG;



Type
     // typedef void CURL;
     CURL = Type Pointer;
     // typedef void CURLSH;
     CURLSH = Type Pointer;
     // typedef int curl_socket_t;
     curl_socket_t = Type Integer;


     CURLcode = (
          CURLE_OK,
          CURLE_UNSUPPORTED_PROTOCOL,
          CURLE_FAILED_INIT,
          CURLE_URL_MALFORMAT,
          CURLE_NOT_BUILT_IN,            // [was obsoleted in August 2007 for
                                         // 7.17.0, reused in April 2011 for 7.21.5]
          CURLE_COULDNT_RESOLVE_PROXY,
          CURLE_COULDNT_RESOLVE_HOST,
          CURLE_COULDNT_CONNECT,
          CURLE_WEIRD_SERVER_REPLY,
          CURLE_REMOTE_ACCESS_DENIED,    // a service was denied by the server
                                         // due to lack of access - when login fails
                                         // this is not returned.
          CURLE_FTP_ACCEPT_FAILED,       // [was obsoleted in April 2006 for
                                         // 7.15.4, reused in Dec 2011 for 7.24.0]
          CURLE_FTP_WEIRD_PASS_REPLY,
          CURLE_FTP_ACCEPT_TIMEOUT,      // timeout occurred accepting server
                                         // [was obsoleted in August 2007 for 7.17.0,
                                         // reused in Dec 2011 for 7.24.0]
          CURLE_FTP_WEIRD_PASV_REPLY,
          CURLE_FTP_WEIRD_227_FORMAT,
          CURLE_FTP_CANT_GET_HOST,
          CURLE_HTTP2,                   // A problem in the http2 framing layer.
                                         // [was obsoleted in August 2007 for 7.17.0,
                                         // reused in July 2014 for 7.38.0]
          CURLE_FTP_COULDNT_SET_TYPE,
          CURLE_PARTIAL_FILE,
          CURLE_FTP_COULDNT_RETR_FILE,
          CURLE_OBSOLETE20,              // NOT USED
          CURLE_QUOTE_ERROR,             // quote command failure
          CURLE_HTTP_RETURNED_ERROR,
          CURLE_WRITE_ERROR,
          CURLE_OBSOLETE24,              // NOT USED
          CURLE_UPLOAD_FAILED,           // failed upload "command"
          CURLE_READ_ERROR,              // couldn't open/read from file
          CURLE_OUT_OF_MEMORY,
          CURLE_OPERATION_TIMEDOUT,      // the timeout time was reached
          CURLE_OBSOLETE29,              // NOT USED
          CURLE_FTP_PORT_FAILED,         // FTP PORT operation failed
          CURLE_FTP_COULDNT_USE_REST,    // 31 - the REST command failed
          CURLE_OBSOLETE32,              // 32 - NOT USED
          CURLE_RANGE_ERROR,             // 33 - RANGE "command" didn't work
          CURLE_HTTP_POST_ERROR,
          CURLE_SSL_CONNECT_ERROR,       // wrong when connecting with SSL
          CURLE_BAD_DOWNLOAD_RESUME,     // couldn't resume download
          CURLE_FILE_COULDNT_READ_FILE,
          CURLE_LDAP_CANNOT_BIND,
          CURLE_LDAP_SEARCH_FAILED,
          CURLE_OBSOLETE40,              // NOT USED
          CURLE_FUNCTION_NOT_FOUND,      // NOT USED starting with 7.53.0
          CURLE_ABORTED_BY_CALLBACK,
          CURLE_BAD_FUNCTION_ARGUMENT,
          CURLE_OBSOLETE44,              // NOT USED
          CURLE_INTERFACE_FAILED,        // CURLOPT_INTERFACE failed
          CURLE_OBSOLETE46,              // NOT USED
          CURLE_TOO_MANY_REDIRECTS,      // catch endless re-direct loops
          CURLE_UNKNOWN_OPTION,          // User specified an unknown option
          CURLE_SETOPT_OPTION_SYNTAX,    // Malformed setopt option
          CURLE_OBSOLETE50,              // NOT USED
          CURLE_OBSOLETE51,              // NOT USED
          CURLE_GOT_NOTHING,             // when this is a specific error
          CURLE_SSL_ENGINE_NOTFOUND,     // SSL crypto engine not found
          CURLE_SSL_ENGINE_SETFAILED,    // can not set SSL crypto engine as
          CURLE_SEND_ERROR,              // failed sending network data
          CURLE_RECV_ERROR,              // failure in receiving network data
          CURLE_OBSOLETE57,              // NOT IN USE
          CURLE_SSL_CERTPROBLEM,         // problem with the local certificate
          CURLE_SSL_CIPHER,              // couldn't use specified cipher
          CURLE_PEER_FAILED_VERIFICATION,// peer's certificate or fingerprint
                                         // wasn't verified fine
          CURLE_BAD_CONTENT_ENCODING,    // Unrecognized/bad encoding
          CURLE_OBSOLETE62,              // NOT IN USE since 7.82.0
          CURLE_FILESIZE_EXCEEDED,       // Maximum file size exceeded
          CURLE_USE_SSL_FAILED,          // Requested FTP SSL level failed
          CURLE_SEND_FAIL_REWIND,        // Sending the data requires a rewind
                                         // that failed
          CURLE_SSL_ENGINE_INITFAILED,   // failed to initialise ENGINE
          CURLE_LOGIN_DENIED,            // user, password or similar was not
                                         // accepted and we failed to login
          CURLE_TFTP_NOTFOUND,           // file not found on server
          CURLE_TFTP_PERM,               // permission problem on server
          CURLE_REMOTE_DISK_FULL,        // out of disk space on server
          CURLE_TFTP_ILLEGAL,            // Illegal TFTP operation
          CURLE_TFTP_UNKNOWNID,          // Unknown transfer ID
          CURLE_REMOTE_FILE_EXISTS,      // File already exists
          CURLE_TFTP_NOSUCHUSER,         // No such user
          CURLE_OBSOLETE75,              // NOT IN USE since 7.82.0
          CURLE_OBSOLETE76,              // NOT IN USE since 7.82.0
          CURLE_SSL_CACERT_BADFILE,      // could not load CACERT file, missing
                                         // or wrong format
          CURLE_REMOTE_FILE_NOT_FOUND,   // remote file not found
          CURLE_SSH,                     // error from the SSH layer, somewhat
                                         // generic so the error message will be of
                                         // interest when this has happened
          CURLE_SSL_SHUTDOWN_FAILED,     // Failed to shut down the SSL connection
          CURLE_AGAIN,                   // socket is not ready for send/recv,
                                         // wait till it's ready and try again (Added
                                         // in 7.18.2)
          CURLE_SSL_CRL_BADFILE,         // could not load CRL file, missing or
                                         // wrong format (Added in 7.19.0)
          CURLE_SSL_ISSUER_ERROR,        // Issuer check failed.  (Added in
                                         // 7.19.0)
          CURLE_FTP_PRET_FAILED,         // a PRET command failed
          CURLE_RTSP_CSEQ_ERROR,         // mismatch of RTSP CSeq numbers
          CURLE_RTSP_SESSION_ERROR,      // mismatch of RTSP Session Ids
          CURLE_FTP_BAD_FILE_LIST,       // unable to parse FTP file list
          CURLE_CHUNK_FAILED,            // chunk callback reported error
          CURLE_NO_CONNECTION_AVAILABLE, // No connection available, the
                                         // session will be queued
          CURLE_SSL_PINNEDPUBKEYNOTMATCH,// specified pinned public key did not
                                         // match
          CURLE_SSL_INVALIDCERTSTATUS,   // invalid certificate status
          CURLE_HTTP2_STREAM,            // stream error in HTTP/2 framing layer
          CURLE_RECURSIVE_API_CALL,      // an api function was called from
                                         // inside a callback
          CURLE_AUTH_ERROR,              // an authentication function returned an
                                         // error */
          CURLE_HTTP3,                   // An HTTP/3 layer problem
          CURLE_QUIC_CONNECT_ERROR,      // QUIC connection error
          CURLE_PROXY,                   // proxy handshake error
          CURLE_SSL_CLIENTCERT,          // client-side certificate required
          CURLE_UNRECOVERABLE_POLL,      // poll/select returned fatal error
          CURLE_TOO_LARGE,               // a value/data met its maximum
          CURL_LAST                      // never use!
     );


     (*
     #define CURLOPT(na,t,nu) na = t + nu
     #define CURLOPTDEPRECATED(na,t,nu,v,m) na CURL_DEPRECATED(v,m) = t + nu
     *)

     CURLoption = (
          (* This is the FILE * or void * the regular output should be written to. *)
          CURLOPT_WRITEDATA        =    CURLOPTTYPE_CBPOINT + 1,
          (* The full URL to get/put *)
          CURLOPT_URL              =    CURLOPTTYPE_STRINGPOINT + 2,
          (* Port number to connect to, if other than default. *)
          CURLOPT_PORT             =    CURLOPTTYPE_LONG + 3,
          (* Name of proxy to use. *)
          CURLOPT_PROXY            =    CURLOPTTYPE_STRINGPOINT + 4,
          (* "user:password;options" to use when fetching. *)
          CURLOPT_USERPWD          =    CURLOPTTYPE_STRINGPOINT + 5,
          (* "user:password" to use with proxy. *)
          CURLOPT_PROXYUSERPWD     =    CURLOPTTYPE_STRINGPOINT + 6,
          (* Range to get, specified as an ASCII string. *)
          CURLOPT_RANGE            =    CURLOPTTYPE_STRINGPOINT + 7,
          (* not used *)
          (* Specified file stream to upload from (use as input): *)
          CURLOPT_READDATA         =    CURLOPTTYPE_CBPOINT + 9,
          (* Buffer to receive error messages in, must be at least CURL_ERROR_SIZE
          * bytes big. *)
          CURLOPT_ERRORBUFFER      =    CURLOPTTYPE_OBJECTPOINT + 10,
          (* Function that will be called to store the output (instead of fwrite). The
          * parameters will use fwrite() syntax, make sure to follow them. *)
          CURLOPT_WRITEFUNCTION    =    CURLOPTTYPE_FUNCTIONPOINT + 11,
          (* Function that will be called to read the input (instead of fread). The
          * parameters will use fread() syntax, make sure to follow them. *)
          CURLOPT_READFUNCTION     =    CURLOPTTYPE_FUNCTIONPOINT + 12,
          (* Time-out the read operation after this amount of seconds *)
          CURLOPT_TIMEOUT          =    CURLOPTTYPE_LONG + 13,
          (* If CURLOPT_READDATA is used, this can be used to inform libcurl about
          * how large the file being sent really is. That allows better error
          * checking and better verifies that the upload was successful. -1 means
          * unknown size.
          *
          * For large file support, there is also a _LARGE version of the key
          * which takes an off_t type, allowing platforms with larger off_t
          * sizes to handle larger files.  See below for INFILESIZE_LARGE.
          *)
          CURLOPT_INFILESIZE       =    CURLOPTTYPE_LONG + 14,
          (* POST static input fields. *)
          CURLOPT_POSTFIELDS       =    CURLOPTTYPE_OBJECTPOINT + 15,
          (* Set the referrer page (needed by some CGIs) *)
          CURLOPT_REFERER          =    CURLOPTTYPE_STRINGPOINT + 16,
          (* Set the FTP PORT string (interface name, named or numerical IP address)
          Use i.e '-' to use default address. *)
          CURLOPT_FTPPORT          =    CURLOPTTYPE_STRINGPOINT + 17,
          (* Set the User-Agent string (examined by some CGIs) *)
          CURLOPT_USERAGENT        =    CURLOPTTYPE_STRINGPOINT + 18,
          (* If the download receives less than "low speed limit" bytes/second
          * during "low speed time" seconds, the operations is aborted.
          * You could i.e if you have a pretty high speed connection, abort if
          * it is less than 2000 bytes/sec during 20 seconds.
          *)
          (* Set the "low speed limit" *)
          CURLOPT_LOW_SPEED_LIMIT  =    CURLOPTTYPE_LONG + 19,
          (* Set the "low speed time" *)
          CURLOPT_LOW_SPEED_TIME   =    CURLOPTTYPE_LONG + 20,
          (* Set the continuation offset.
          *
          * Note there is also a _LARGE version of this key which uses
          * off_t types, allowing for large file offsets on platforms which
          * use larger-than-32-bit off_t's.  Look below for RESUME_FROM_LARGE.
          *)
          CURLOPT_RESUME_FROM      =    CURLOPTTYPE_LONG + 21,
          (* Set cookie in request: *)
          CURLOPT_COOKIE           =    CURLOPTTYPE_STRINGPOINT + 22,
          (* This points to a linked list of headers, struct curl_slist kind. This
          list is also used for RTSP (in spite of its name) *)
          CURLOPT_HTTPHEADER       =    CURLOPTTYPE_SLISTPOINT + 23,
          (* This points to a linked list of post entries, struct curl_httppost *)
          CURLOPT_HTTPPOST         =    CURLOPTTYPE_OBJECTPOINT + 24,
          (* name of the file keeping your private SSL-certificate *)
          CURLOPT_SSLCERT          =    CURLOPTTYPE_STRINGPOINT + 25,
          (* password for the SSL or SSH private key *)
          CURLOPT_KEYPASSWD        =    CURLOPTTYPE_STRINGPOINT + 26,
          (* send TYPE parameter? *)
          CURLOPT_CRLF             =    CURLOPTTYPE_LONG + 27,
          (* send linked-list of QUOTE commands *)
          CURLOPT_QUOTE            =    CURLOPTTYPE_SLISTPOINT + 28,
          (* send FILE * or void * to store headers to, if you use a callback it
          is simply passed to the callback unmodified *)
          CURLOPT_HEADERDATA       =    CURLOPTTYPE_CBPOINT + 29,
          (* point to a file to read the initial cookies from, also enables
          "cookie awareness" *)
          CURLOPT_COOKIEFILE       =    CURLOPTTYPE_STRINGPOINT + 31,
          (* What version to specifically try to use.
          See CURL_SSLVERSION defines below. *)
          CURLOPT_SSLVERSION       =    CURLOPTTYPE_VALUES + 32,
          (* What kind of HTTP time condition to use, see defines *)
          CURLOPT_TIMECONDITION    =    CURLOPTTYPE_VALUES + 33,
          (* Time to use with the above condition. Specified in number of seconds
          since 1 Jan 1970 *)
          CURLOPT_TIMEVALUE        =    CURLOPTTYPE_LONG + 34,
          (* 35 = OBSOLETE *)
          (* Custom request, for customizing the get command like
          HTTP: DELETE, TRACE and others
          FTP: to use a different list command
          *)
          CURLOPT_CUSTOMREQUEST    =    CURLOPTTYPE_STRINGPOINT + 36,
          (* FILE handle to use instead of stderr *)
          CURLOPT_STDERR           =    CURLOPTTYPE_OBJECTPOINT + 37,
          (* 38 is not used *)
          (* send linked-list of post-transfer QUOTE commands *)
          CURLOPT_POSTQUOTE        =    CURLOPTTYPE_SLISTPOINT + 39,
          (* OBSOLETE, do not use! *)
          CURLOPT_OBSOLETE40       =    CURLOPTTYPE_OBJECTPOINT + 40,
          (* talk a lot *)
          CURLOPT_VERBOSE          =    CURLOPTTYPE_LONG + 41,
          (* throw the header out too *)
          CURLOPT_HEADER           =    CURLOPTTYPE_LONG + 42,
          (* shut off the progress meter *)
          CURLOPT_NOPROGRESS       =    CURLOPTTYPE_LONG + 43,
          (* use HEAD to get http document *)
          CURLOPT_NOBODY           =    CURLOPTTYPE_LONG + 44,
          (* no output on http error codes >= 400 *)
          CURLOPT_FAILONERROR      =    CURLOPTTYPE_LONG + 45,
          (* this is an upload *)
          CURLOPT_UPLOAD           =    CURLOPTTYPE_LONG + 46,
          (* HTTP POST method *)
          CURLOPT_POST             =    CURLOPTTYPE_LONG + 47,
          (* bare names when listing directories *)
          CURLOPT_DIRLISTONLY      =    CURLOPTTYPE_LONG + 48,
          (* Append instead of overwrite on upload! *)
          CURLOPT_APPEND           =    CURLOPTTYPE_LONG + 50,
          (* Specify whether to read the user+password from the .netrc or the URL.
          * This must be one of the CURL_NETRC_* enums below. *)
          CURLOPT_NETRC            =    CURLOPTTYPE_VALUES + 51,
          (* use Location: Luke! *)
          CURLOPT_FOLLOWLOCATION   =    CURLOPTTYPE_LONG + 52,
          (* transfer data in text/ASCII format *)
          CURLOPT_TRANSFERTEXT     =    CURLOPTTYPE_LONG + 53,
          (* HTTP PUT *)
          CURLOPT_PUT              =    CURLOPTTYPE_LONG + 54,
          (* 55 = OBSOLETE *)
          (* DEPRECATED
          * Function that will be called instead of the internal progress display
          * function. This function should be defined as the curl_progress_callback
          * prototype defines. *)
          CURLOPT_PROGRESSFUNCTION =    CURLOPTTYPE_FUNCTIONPOINT + 56,
          (* Data passed to the CURLOPT_PROGRESSFUNCTION and CURLOPT_XFERINFOFUNCTION
          callbacks *)
          CURLOPT_XFERINFODATA     =    CURLOPTTYPE_CBPOINT + 57,
          (* We want the referrer field set automatically when following locations *)
          CURLOPT_AUTOREFERER      =    CURLOPTTYPE_LONG + 58,
          (* Port of the proxy, can be set in the proxy string as well with:
          "[host]:[port]" *)
          CURLOPT_PROXYPORT        =    CURLOPTTYPE_LONG + 59,
          (* size of the POST input data, if strlen() is not good to use *)
          CURLOPT_POSTFIELDSIZE    =    CURLOPTTYPE_LONG + 60,
          (* tunnel non-http operations through an HTTP proxy *)
          CURLOPT_HTTPPROXYTUNNEL  =    CURLOPTTYPE_LONG + 61,
          (* Set the interface string to use as outgoing network interface *)
          CURLOPT_INTERFACE        =    CURLOPTTYPE_STRINGPOINT + 62,
          (* Set the krb4/5 security level, this also enables krb4/5 awareness.  This
          * is a string, 'clear', 'safe', 'confidential' or 'private'.  If the string
          * is set but doesn't match one of these, 'private' will be used.  *)
          CURLOPT_KRBLEVEL         =    CURLOPTTYPE_STRINGPOINT + 63,
          (* Set if we should verify the peer in ssl handshake, set 1 to verify. *)
          CURLOPT_SSL_VERIFYPEER   =    CURLOPTTYPE_LONG + 64,
          (* The CApath or CAfile used to validate the peer certificate
          this option is used only if SSL_VERIFYPEER is true *)
          CURLOPT_CAINFO           =    CURLOPTTYPE_STRINGPOINT + 65,
          (* 66 = OBSOLETE *)
          (* 67 = OBSOLETE *)
          (* Maximum number of http redirects to follow *)
          CURLOPT_MAXREDIRS        =    CURLOPTTYPE_LONG + 68,
          (* Pass a long set to 1 to get the date of the requested document (if
          possible)! Pass a zero to shut it off. *)
          CURLOPT_FILETIME         =    CURLOPTTYPE_LONG + 69,
          (* This points to a linked list of telnet options *)
          CURLOPT_TELNETOPTIONS    =    CURLOPTTYPE_SLISTPOINT + 70,
          (* Max amount of cached alive connections *)
          CURLOPT_MAXCONNECTS      =    CURLOPTTYPE_LONG + 71,
          (* OBSOLETE, do not use! *)
          CURLOPT_OBSOLETE72       =    CURLOPTTYPE_LONG + 72,
          (* 73 = OBSOLETE *)
          (* Set to explicitly use a new connection for the upcoming transfer.
          Do not use this unless you're absolutely sure of this, as it makes the
          operation slower and is less friendly for the network. *)
          CURLOPT_FRESH_CONNECT    =    CURLOPTTYPE_LONG + 74,
          (* Set to explicitly forbid the upcoming transfer's connection to be reused
          when done. Do not use this unless you're absolutely sure of this, as it
          makes the operation slower and is less friendly for the network. *)
          CURLOPT_FORBID_REUSE     =    CURLOPTTYPE_LONG + 75,
          (* Set to a file name that contains random data for libcurl to use to
          seed the random engine when doing SSL connects. *)
          CURLOPT_RANDOM_FILE      =    CURLOPTTYPE_STRINGPOINT + 76,
          (* Set to the Entropy Gathering Daemon socket pathname *)
          CURLOPT_EGDSOCKET        =    CURLOPTTYPE_STRINGPOINT + 77,
          (* Time-out connect operations after this amount of seconds, if connects are
          OK within this time, then fine... This only aborts the connect phase. *)
          CURLOPT_CONNECTTIMEOUT   =    CURLOPTTYPE_LONG + 78,
          (* Function that will be called to store headers (instead of fwrite). The
          * parameters will use fwrite() syntax, make sure to follow them. *)
          CURLOPT_HEADERFUNCTION   =    CURLOPTTYPE_FUNCTIONPOINT + 79,
          (* Set this to force the HTTP request to get back to GET. Only really usable
          if POST, PUT or a custom request have been used first.
          *)
          CURLOPT_HTTPGET          =    CURLOPTTYPE_LONG + 80,
          (* Set if we should verify the Common name from the peer certificate in ssl
          * handshake, set 1 to check existence, 2 to ensure that it matches the
          * provided hostname. *)
          CURLOPT_SSL_VERIFYHOST   =    CURLOPTTYPE_LONG + 81,
          (* Specify which file name to write all known cookies in after completed
          operation. Set file name to "-" (dash) to make it go to stdout. *)
          CURLOPT_COOKIEJAR        =    CURLOPTTYPE_STRINGPOINT + 82,
          (* Specify which SSL ciphers to use *)
          CURLOPT_SSL_CIPHER_LIST  =    CURLOPTTYPE_STRINGPOINT + 83,
          (* Specify which HTTP version to use! This must be set to one of the
          CURL_HTTP_VERSION* enums set below. *)
          CURLOPT_HTTP_VERSION     =    CURLOPTTYPE_VALUES + 84,
          (* Specifically switch on or off the FTP engine's use of the EPSV command. By
          default, that one will always be attempted before the more traditional
          PASV command. *)
          CURLOPT_FTP_USE_EPSV     =    CURLOPTTYPE_LONG + 85,
          (* type of the file keeping your SSL-certificate ("DER", "PEM", "ENG") *)
          CURLOPT_SSLCERTTYPE      =    CURLOPTTYPE_STRINGPOINT + 86,
          (* name of the file keeping your private SSL-key *)
          CURLOPT_SSLKEY           =    CURLOPTTYPE_STRINGPOINT + 87,
          (* type of the file keeping your private SSL-key ("DER", "PEM", "ENG") *)
          CURLOPT_SSLKEYTYPE       =    CURLOPTTYPE_STRINGPOINT + 88,
          (* crypto engine for the SSL-sub system *)
          CURLOPT_SSLENGINE        =    CURLOPTTYPE_STRINGPOINT + 89,
          (* set the crypto engine for the SSL-sub system as default
          the param has no meaning...
          *)
          CURLOPT_SSLENGINE_DEFAULT=    CURLOPTTYPE_LONG + 90,
          (* Non-zero value means to use the global dns cache *)
          (* DEPRECATED, do not use! *)
          CURLOPT_DNS_USE_GLOBAL_CACHE  =    CURLOPTTYPE_LONG + 91,
          (* DNS cache timeout *)
          CURLOPT_DNS_CACHE_TIMEOUT=    CURLOPTTYPE_LONG + 92,
          (* send linked-list of pre-transfer QUOTE commands *)
          CURLOPT_PREQUOTE         =    CURLOPTTYPE_SLISTPOINT + 93,
          (* set the debug function *)
          CURLOPT_DEBUGFUNCTION    =    CURLOPTTYPE_FUNCTIONPOINT + 94,
          (* set the data for the debug function *)
          CURLOPT_DEBUGDATA        =    CURLOPTTYPE_CBPOINT + 95,
          (* mark this as start of a cookie session *)
          CURLOPT_COOKIESESSION    =    CURLOPTTYPE_LONG + 96,
          (* The CApath directory used to validate the peer certificate
          this option is used only if SSL_VERIFYPEER is true *)
          CURLOPT_CAPATH           =    CURLOPTTYPE_STRINGPOINT + 97,
          (* Instruct libcurl to use a smaller receive buffer *)
          CURLOPT_BUFFERSIZE       =    CURLOPTTYPE_LONG + 98,
          (* Instruct libcurl to not use any signal/alarm handlers, even when using
          timeouts. This option is useful for multi-threaded applications.
          See libcurl-the-guide for more background information. *)
          CURLOPT_NOSIGNAL         =    CURLOPTTYPE_LONG + 99,
          (* Provide a CURLShare for mutexing non-ts data *)
          CURLOPT_SHARE            =    CURLOPTTYPE_OBJECTPOINT + 100,
          (* indicates type of proxy. accepted values are CURLPROXY_HTTP (default),
          CURLPROXY_HTTPS, CURLPROXY_SOCKS4, CURLPROXY_SOCKS4A and
          CURLPROXY_SOCKS5. *)
          CURLOPT_PROXYTYPE        =    CURLOPTTYPE_VALUES + 101,
          (* Set the Accept-Encoding string. Use this to tell a server you would like
          the response to be compressed. Before 7.21.6, this was known as
          CURLOPT_ENCODING *)
          CURLOPT_ACCEPT_ENCODING  =    CURLOPTTYPE_STRINGPOINT + 102,
          (* Set pointer to private data *)
          CURLOPT_PRIVATE          =    CURLOPTTYPE_OBJECTPOINT + 103,
          (* Set aliases for HTTP 200 in the HTTP Response header *)
          CURLOPT_HTTP200ALIASES   =    CURLOPTTYPE_SLISTPOINT + 104,
          (* Continue to send authentication (user+password) when following locations,
          even when hostname changed. This can potentially send off the name
          and password to whatever host the server decides. *)
          CURLOPT_UNRESTRICTED_AUTH=    CURLOPTTYPE_LONG + 105,
          (* Specifically switch on or off the FTP engine's use of the EPRT command (
          it also disables the LPRT attempt). By default, those ones will always be
          attempted before the good old traditional PORT command. *)
          CURLOPT_FTP_USE_EPRT     =    CURLOPTTYPE_LONG + 106,
          (* Set this to a bitmask value to enable the particular authentications
          methods you like. Use this in combination with CURLOPT_USERPWD.
          Note that setting multiple bits may cause extra network round-trips. *)
          CURLOPT_HTTPAUTH         =    CURLOPTTYPE_VALUES + 107,
          (* Set the ssl context callback function, currently only for OpenSSL or
          WolfSSL ssl_ctx, or mbedTLS mbedtls_ssl_config in the second argument.
          The function must match the curl_ssl_ctx_callback prototype. *)
          CURLOPT_SSL_CTX_FUNCTION =    CURLOPTTYPE_FUNCTIONPOINT + 108,
          (* Set the userdata for the ssl context callback function's third
          argument *)
          CURLOPT_SSL_CTX_DATA     =    CURLOPTTYPE_CBPOINT + 109,
          (* FTP Option that causes missing dirs to be created on the remote server.
          In 7.19.4 we introduced the convenience enums for this option using the
          CURLFTP_CREATE_DIR prefix.
          *)
          CURLOPT_FTP_CREATE_MISSING_DIRS    =    CURLOPTTYPE_LONG + 110,
          (* Set this to a bitmask value to enable the particular authentications
          methods you like. Use this in combination with CURLOPT_PROXYUSERPWD.
          Note that setting multiple bits may cause extra network round-trips. *)
          CURLOPT_PROXYAUTH        =    CURLOPTTYPE_VALUES + 111,
          (* Option that changes the timeout, in seconds, associated with getting a
          response.  This is different from transfer timeout time and essentially
          places a demand on the server to acknowledge commands in a timely
          manner. For FTP, SMTP, IMAP and POP3. *)
          CURLOPT_SERVER_RESPONSE_TIMEOUT    =    CURLOPTTYPE_LONG + 112,
          (* Set this option to one of the CURL_IPRESOLVE_* defines (see below) to
          tell libcurl to use those IP versions only. This only has effect on
          systems with support for more than one, i.e IPv4 _and_ IPv6. *)
          CURLOPT_IPRESOLVE        =    CURLOPTTYPE_VALUES + 113,
          (* Set this option to limit the size of a file that will be downloaded from
          an HTTP or FTP server.
          Note there is also _LARGE version which adds large file support for
          platforms which have larger off_t sizes.  See MAXFILESIZE_LARGE below. *)
          CURLOPT_MAXFILESIZE      =    CURLOPTTYPE_LONG + 114,
          (* See the comment for INFILESIZE above, but in short, specifies
          * the size of the file being uploaded.  -1 means unknown.
          *)
          CURLOPT_INFILESIZE_LARGE =    CURLOPTTYPE_OFF_T + 115,
          (* Sets the continuation offset.  There is also a CURLOPTTYPE_LONG version
          * of this; look above for RESUME_FROM.
          *)
          CURLOPT_RESUME_FROM_LARGE=    CURLOPTTYPE_OFF_T + 116,
          (* Sets the maximum size of data that will be downloaded from
          * an HTTP or FTP server.  See MAXFILESIZE above for the LONG version.
          *)
          CURLOPT_MAXFILESIZE_LARGE=    CURLOPTTYPE_OFF_T + 117,
          (* Set this option to the file name of your .netrc file you want libcurl
          to parse (using the CURLOPT_NETRC option). If not set, libcurl will do
          a poor attempt to find the user's home directory and check for a .netrc
          file in there. *)
          CURLOPT_NETRC_FILE       =    CURLOPTTYPE_STRINGPOINT + 118,
          (* Enable SSL/TLS for FTP, pick one of:
          CURLUSESSL_TRY     - try using SSL, proceed anyway otherwise
          CURLUSESSL_CONTROL - SSL for the control connection or fail
          CURLUSESSL_ALL     - SSL for all communication or fail
          *)
          CURLOPT_USE_SSL          =    CURLOPTTYPE_VALUES + 119,
          (* The _LARGE version of the standard POSTFIELDSIZE option *)
          CURLOPT_POSTFIELDSIZE_LARGE   =    CURLOPTTYPE_OFF_T + 120,
          (* Enable/disable the TCP Nagle algorithm *)
          CURLOPT_TCP_NODELAY      =    CURLOPTTYPE_LONG + 121,
          (* 122 OBSOLETE, used in 7.12.3. Gone in 7.13.0 *)
          (* 123 OBSOLETE. Gone in 7.16.0 *)
          (* 124 OBSOLETE, used in 7.12.3. Gone in 7.13.0 *)
          (* 125 OBSOLETE, used in 7.12.3. Gone in 7.13.0 *)
          (* 126 OBSOLETE, used in 7.12.3. Gone in 7.13.0 *)
          (* 127 OBSOLETE. Gone in 7.16.0 *)
          (* 128 OBSOLETE. Gone in 7.16.0 *)
          (* When FTP over SSL/TLS is selected (with CURLOPT_USE_SSL), this option
          can be used to change libcurl's default action which is to first try
          "AUTH SSL" and then "AUTH TLS" in this order, and proceed when a OK
          response has been received.
          Available parameters are:
          CURLFTPAUTH_DEFAULT - let libcurl decide
          CURLFTPAUTH_SSL     - try "AUTH SSL" first, then TLS
          CURLFTPAUTH_TLS     - try "AUTH TLS" first, then SSL
          *)
          CURLOPT_FTPSSLAUTH       =    CURLOPTTYPE_VALUES + 129,
          CURLOPT_IOCTLFUNCTION    =    CURLOPTTYPE_FUNCTIONPOINT + 130,
          CURLOPT_IOCTLDATA        =    CURLOPTTYPE_CBPOINT + 131,
          (* 132 OBSOLETE. Gone in 7.16.0 *)
          (* 133 OBSOLETE. Gone in 7.16.0 *)
          (* null-terminated string for pass on to the FTP server when asked for
          "account" info *)
          CURLOPT_FTP_ACCOUNT      =    CURLOPTTYPE_STRINGPOINT + 134,
          (* feed cookie into cookie engine *)
          CURLOPT_COOKIELIST       =    CURLOPTTYPE_STRINGPOINT + 135,
          (* ignore Content-Length *)
          CURLOPT_IGNORE_CONTENT_LENGTH =    CURLOPTTYPE_LONG + 136,
          (* Set to non-zero to skip the IP address received in a 227 PASV FTP server
          response. Typically used for FTP-SSL purposes but is not restricted to
          that. libcurl will then instead use the same IP address it used for the
          control connection. *)
          CURLOPT_FTP_SKIP_PASV_IP =    CURLOPTTYPE_LONG + 137,
          (* Select "file method" to use when doing FTP, see the curl_ftpmethod
          above. *)
          CURLOPT_FTP_FILEMETHOD   =    CURLOPTTYPE_VALUES + 138,
          (* Local port number to bind the socket to *)
          CURLOPT_LOCALPORT        =    CURLOPTTYPE_LONG + 139,
          (* Number of ports to try, including the first one set with LOCALPORT.
          Thus, setting it to 1 will make no additional attempts but the first.
          *)
          CURLOPT_LOCALPORTRANGE   =    CURLOPTTYPE_LONG + 140,
          (* no transfer, set up connection and let application use the socket by
          extracting it with CURLINFO_LASTSOCKET *)
          CURLOPT_CONNECT_ONLY     =    CURLOPTTYPE_LONG + 141,
          (* Function that will be called to convert from the
          network encoding (instead of using the iconv calls in libcurl) *)
          CURLOPT_CONV_FROM_NETWORK_FUNCTION =    CURLOPTTYPE_FUNCTIONPOINT + 142,
          (* Function that will be called to convert to the
          network encoding (instead of using the iconv calls in libcurl) *)
          CURLOPT_CONV_TO_NETWORK_FUNCTION   =    CURLOPTTYPE_FUNCTIONPOINT + 143,
          (* Function that will be called to convert from UTF8
          (instead of using the iconv calls in libcurl)
          Note that this is used only for SSL certificate processing *)
          CURLOPT_CONV_FROM_UTF8_FUNCTION    =    CURLOPTTYPE_FUNCTIONPOINT + 144,
          (* if the connection proceeds too quickly then need to slow it down *)
          (* limit-rate: maximum number of bytes per second to send or receive *)
          CURLOPT_MAX_SEND_SPEED_LARGE       =    CURLOPTTYPE_OFF_T + 145,
          CURLOPT_MAX_RECV_SPEED_LARGE       =    CURLOPTTYPE_OFF_T + 146,
          (* Pointer to command string to send if USER/PASS fails. *)
          CURLOPT_FTP_ALTERNATIVE_TO_USER    =    CURLOPTTYPE_STRINGPOINT + 147,
          (* callback function for setting socket options *)
          CURLOPT_SOCKOPTFUNCTION            =    CURLOPTTYPE_FUNCTIONPOINT + 148,
          CURLOPT_SOCKOPTDATA                =    CURLOPTTYPE_CBPOINT + 149,
          (* set to 0 to disable session ID reuse for this transfer, default is
          enabled (== 1) *)
          CURLOPT_SSL_SESSIONID_CACHE        =    CURLOPTTYPE_LONG + 150,
          (* allowed SSH authentication methods *)
          CURLOPT_SSH_AUTH_TYPES             =    CURLOPTTYPE_VALUES + 151,
          (* Used by scp/sftp to do public/private key authentication *)
          CURLOPT_SSH_PUBLIC_KEYFILE         =    CURLOPTTYPE_STRINGPOINT + 152,
          CURLOPT_SSH_PRIVATE_KEYFILE        =    CURLOPTTYPE_STRINGPOINT + 153,
          (* Send CCC (Clear Command Channel) after authentication *)
          CURLOPT_FTP_SSL_CCC                =    CURLOPTTYPE_LONG + 154,
          (* Same as TIMEOUT and CONNECTTIMEOUT, but with ms resolution *)
          CURLOPT_TIMEOUT_MS       =    CURLOPTTYPE_LONG + 155,
          CURLOPT_CONNECTTIMEOUT_MS=    CURLOPTTYPE_LONG + 156,
          (* set to zero to disable the libcurl's decoding and thus pass the raw body
          data to the application even when it is encoded/compressed *)
          CURLOPT_HTTP_TRANSFER_DECODING     =    CURLOPTTYPE_LONG + 157,
          CURLOPT_HTTP_CONTENT_DECODING      =    CURLOPTTYPE_LONG + 158,
          (* Permission used when creating new files and directories on the remote
          server for protocols that support it, SFTP/SCP/FILE *)
          CURLOPT_NEW_FILE_PERMS   =    CURLOPTTYPE_LONG + 159,
          CURLOPT_NEW_DIRECTORY_PERMS        =    CURLOPTTYPE_LONG + 160,
          (* Set the behavior of POST when redirecting. Values must be set to one
          of CURL_REDIR* defines below. This used to be called CURLOPT_POST301 *)
          CURLOPT_POSTREDIR        =    CURLOPTTYPE_VALUES + 161,
          (* used by scp/sftp to verify the host's public key *)
          CURLOPT_SSH_HOST_PUBLIC_KEY_MD5    =    CURLOPTTYPE_STRINGPOINT + 162,
          (* Callback function for opening socket (instead of socket(2)). Optionally,
          callback is able change the address or refuse to connect returning
          CURL_SOCKET_BAD.  The callback should have type
          curl_opensocket_callback *)
          CURLOPT_OPENSOCKETFUNCTION         =    CURLOPTTYPE_FUNCTIONPOINT + 163,
          CURLOPT_OPENSOCKETDATA   =    CURLOPTTYPE_CBPOINT + 164,
          (* POST volatile input fields. *)
          CURLOPT_COPYPOSTFIELDS   =    CURLOPTTYPE_OBJECTPOINT + 165,
          (* set transfer mode (;type=<a|i>) when doing FTP via an HTTP proxy *)
          CURLOPT_PROXY_TRANSFER_MODE        =    CURLOPTTYPE_LONG + 166,
          (* Callback function for seeking in the input stream *)
          CURLOPT_SEEKFUNCTION     =    CURLOPTTYPE_FUNCTIONPOINT + 167,
          CURLOPT_SEEKDATA         =    CURLOPTTYPE_CBPOINT + 168,
          (* CRL file *)
          CURLOPT_CRLFILE          =    CURLOPTTYPE_STRINGPOINT + 169,
          (* Issuer certificate *)
          CURLOPT_ISSUERCERT       =    CURLOPTTYPE_STRINGPOINT + 170,
          (* (IPv6) Address scope *)
          CURLOPT_ADDRESS_SCOPE    =    CURLOPTTYPE_LONG + 171,
          (* Collect certificate chain info and allow it to get retrievable with
          CURLINFO_CERTINFO after the transfer is complete. *)
          CURLOPT_CERTINFO         =    CURLOPTTYPE_LONG + 172,
          (* "name" and "pwd" to use when fetching. *)
          CURLOPT_USERNAME         =    CURLOPTTYPE_STRINGPOINT + 173,
          CURLOPT_PASSWORD         =    CURLOPTTYPE_STRINGPOINT + 174,
          (* "name" and "pwd" to use with Proxy when fetching. *)
          CURLOPT_PROXYUSERNAME    =    CURLOPTTYPE_STRINGPOINT + 175,
          CURLOPT_PROXYPASSWORD    =    CURLOPTTYPE_STRINGPOINT + 176,
          (* Comma separated list of hostnames defining no-proxy zones. These should
          match both hostnames directly, and hostnames within a domain. For
          example, local.com will match local.com and www.local.com, but NOT
          notlocal.com or www.notlocal.com. For compatibility with other
          implementations of this, .local.com will be considered to be the same as
          local.com. A single * is the only valid wildcard, and effectively
          disables the use of proxy. *)
          CURLOPT_NOPROXY          =    CURLOPTTYPE_STRINGPOINT + 177,
          (* block size for TFTP transfers *)
          CURLOPT_TFTP_BLKSIZE     =    CURLOPTTYPE_LONG + 178,
          (* Socks Service *)
          (* DEPRECATED, do not use! *)
          CURLOPT_SOCKS5_GSSAPI_SERVICE =    CURLOPTTYPE_STRINGPOINT + 179,
          (* Socks Service *)
          CURLOPT_SOCKS5_GSSAPI_NEC=    CURLOPTTYPE_LONG + 180,
          (* set the bitmask for the protocols that are allowed to be used for the
          transfer, which thus helps the app which takes URLs from users or other
          external inputs and want to restrict what protocol(s) to deal
          with. Defaults to CURLPROTO_ALL. *)
          CURLOPT_PROTOCOLS        =    CURLOPTTYPE_LONG + 181,
          (* set the bitmask for the protocols that libcurl is allowed to follow to,
          as a subset of the CURLOPT_PROTOCOLS ones. That means the protocol needs
          to be set in both bitmasks to be allowed to get redirected to. *)
          CURLOPT_REDIR_PROTOCOLS  =    CURLOPTTYPE_LONG + 182,
          (* set the SSH knownhost file name to use *)
          CURLOPT_SSH_KNOWNHOSTS   =    CURLOPTTYPE_STRINGPOINT + 183,
          (* set the SSH host key callback, must point to a curl_sshkeycallback
          function *)
          CURLOPT_SSH_KEYFUNCTION  =    CURLOPTTYPE_FUNCTIONPOINT + 184,
          (* set the SSH host key callback custom pointer *)
          CURLOPT_SSH_KEYDATA      =    CURLOPTTYPE_CBPOINT + 185,
          (* set the SMTP mail originator *)
          CURLOPT_MAIL_FROM        =    CURLOPTTYPE_STRINGPOINT + 186,
          (* set the list of SMTP mail receiver(s) *)
          CURLOPT_MAIL_RCPT        =    CURLOPTTYPE_SLISTPOINT + 187,
          (* FTP: send PRET before PASV *)
          CURLOPT_FTP_USE_PRET     =    CURLOPTTYPE_LONG + 188,
          (* RTSP request method (OPTIONS, SETUP, PLAY, etc...) *)
          CURLOPT_RTSP_REQUEST     =    CURLOPTTYPE_VALUES + 189,
          (* The RTSP session identifier *)
          CURLOPT_RTSP_SESSION_ID  =    CURLOPTTYPE_STRINGPOINT + 190,
          (* The RTSP stream URI *)
          CURLOPT_RTSP_STREAM_URI  =    CURLOPTTYPE_STRINGPOINT + 191,
          (* The Transport: header to use in RTSP requests *)
          CURLOPT_RTSP_TRANSPORT   =    CURLOPTTYPE_STRINGPOINT + 192,
          (* Manually initialize the client RTSP CSeq for this handle *)
          CURLOPT_RTSP_CLIENT_CSEQ =    CURLOPTTYPE_LONG + 193,
          (* Manually initialize the server RTSP CSeq for this handle *)
          CURLOPT_RTSP_SERVER_CSEQ =    CURLOPTTYPE_LONG + 194,
          (* The stream to pass to INTERLEAVEFUNCTION. *)
          CURLOPT_INTERLEAVEDATA   =    CURLOPTTYPE_CBPOINT + 195,
          (* Let the application define a custom write method for RTP data *)
          CURLOPT_INTERLEAVEFUNCTION    =    CURLOPTTYPE_FUNCTIONPOINT + 196,
          (* Turn on wildcard matching *)
          CURLOPT_WILDCARDMATCH    =    CURLOPTTYPE_LONG + 197,
          (* Directory matching callback called before downloading of an
          individual file (chunk) started *)
          CURLOPT_CHUNK_BGN_FUNCTION    =    CURLOPTTYPE_FUNCTIONPOINT + 198,
          (* Directory matching callback called after the file (chunk)
          was downloaded, or skipped *)
          CURLOPT_CHUNK_END_FUNCTION    =    CURLOPTTYPE_FUNCTIONPOINT + 199,
          (* Change match (fnmatch-like) callback for wildcard matching *)
          CURLOPT_FNMATCH_FUNCTION =    CURLOPTTYPE_FUNCTIONPOINT + 200,
          (* Let the application define custom chunk data pointer *)
          CURLOPT_CHUNK_DATA       =    CURLOPTTYPE_CBPOINT + 201,
          (* FNMATCH_FUNCTION user pointer *)
          CURLOPT_FNMATCH_DATA     =    CURLOPTTYPE_CBPOINT + 202,
          (* send linked-list of name:port:address sets *)
          CURLOPT_RESOLVE     =    CURLOPTTYPE_SLISTPOINT + 203,
          (* Set a username for authenticated TLS *)
          CURLOPT_TLSAUTH_USERNAME =    CURLOPTTYPE_STRINGPOINT + 204,
          (* Set a password for authenticated TLS *)
          CURLOPT_TLSAUTH_PASSWORD =    CURLOPTTYPE_STRINGPOINT + 205,
          (* Set authentication type for authenticated TLS *)
          CURLOPT_TLSAUTH_TYPE     =    CURLOPTTYPE_STRINGPOINT + 206,
          (* Set to 1 to enable the "TE:" header in HTTP requests to ask for
          compressed transfer-encoded responses. Set to 0 to disable the use of TE:
          in outgoing requests. The current default is 0, but it might change in a
          future libcurl release.
          libcurl will ask for the compressed methods it knows of, and if that
          isn't any, it will not ask for transfer-encoding at all even if this
          option is set to 1.
          *)
          CURLOPT_TRANSFER_ENCODING     =    CURLOPTTYPE_LONG + 207,
          (* Callback function for closing socket (instead of close(2)). The callback
          should have type curl_closesocket_callback *)
          CURLOPT_CLOSESOCKETFUNCTION   =    CURLOPTTYPE_FUNCTIONPOINT + 208,
          CURLOPT_CLOSESOCKETDATA  =    CURLOPTTYPE_CBPOINT + 209,
          (* allow GSSAPI credential delegation *)
          CURLOPT_GSSAPI_DELEGATION     =    CURLOPTTYPE_VALUES + 210,
          (* Set the name servers to use for DNS resolution.
          * Only supported by the c-ares DNS backend *)
          CURLOPT_DNS_SERVERS      =    CURLOPTTYPE_STRINGPOINT + 211,
          (* Time-out accept operations (currently for FTP only) after this amount
          of milliseconds. *)
          CURLOPT_ACCEPTTIMEOUT_MS =    CURLOPTTYPE_LONG + 212,
          (* Set TCP keepalive *)
          CURLOPT_TCP_KEEPALIVE    =    CURLOPTTYPE_LONG + 213,
          (* non-universal keepalive knobs (Linux, AIX, HP-UX, more) *)
          CURLOPT_TCP_KEEPIDLE     =    CURLOPTTYPE_LONG + 214,
          CURLOPT_TCP_KEEPINTVL    =    CURLOPTTYPE_LONG + 215,
          (* Enable/disable specific SSL features with a bitmask, see CURLSSLOPT_* *)
          CURLOPT_SSL_OPTIONS      =    CURLOPTTYPE_VALUES + 216,
          (* Set the SMTP auth originator *)
          CURLOPT_MAIL_AUTH        =    CURLOPTTYPE_STRINGPOINT + 217,
          (* Enable/disable SASL initial response *)
          CURLOPT_SASL_IR          =    CURLOPTTYPE_LONG + 218,
          (* Function that will be called instead of the internal progress display
          * function. This function should be defined as the curl_xferinfo_callback
          * prototype defines. (Deprecates CURLOPT_PROGRESSFUNCTION) *)
          CURLOPT_XFERINFOFUNCTION =    CURLOPTTYPE_FUNCTIONPOINT + 219,
          (* The XOAUTH2 bearer token *)
          CURLOPT_XOAUTH2_BEARER   =    CURLOPTTYPE_STRINGPOINT + 220,
          (* Set the interface string to use as outgoing network
          * interface for DNS requests.
          * Only supported by the c-ares DNS backend *)
          CURLOPT_DNS_INTERFACE    =    CURLOPTTYPE_STRINGPOINT + 221,
          (* Set the local IPv4 address to use for outgoing DNS requests.
          * Only supported by the c-ares DNS backend *)
          CURLOPT_DNS_LOCAL_IP4    =    CURLOPTTYPE_STRINGPOINT + 222,
          (* Set the local IPv6 address to use for outgoing DNS requests.
          * Only supported by the c-ares DNS backend *)
          CURLOPT_DNS_LOCAL_IP6    =    CURLOPTTYPE_STRINGPOINT + 223,
          (* Set authentication options directly *)
          CURLOPT_LOGIN_OPTIONS    =    CURLOPTTYPE_STRINGPOINT + 224,
          (* Enable/disable TLS NPN extension (http2 over ssl might fail without) *)
          CURLOPT_SSL_ENABLE_NPN   =    CURLOPTTYPE_LONG + 225,
          (* Enable/disable TLS ALPN extension (http2 over ssl might fail without) *)
          CURLOPT_SSL_ENABLE_ALPN  =    CURLOPTTYPE_LONG + 226,
          (* Time to wait for a response to an HTTP request containing an
          * Expect: 100-continue header before sending the data anyway. *)
          CURLOPT_EXPECT_100_TIMEOUT_MS =    CURLOPTTYPE_LONG + 227,
          (* This points to a linked list of headers used for proxy requests only,
          struct curl_slist kind *)
          CURLOPT_PROXYHEADER =    CURLOPTTYPE_SLISTPOINT + 228,
          (* Pass in a bitmask of "header options" *)
          CURLOPT_HEADEROPT   =    CURLOPTTYPE_VALUES + 229,
          (* The public key in DER form used to validate the peer public key
          this option is used only if SSL_VERIFYPEER is true *)
          CURLOPT_PINNEDPUBLICKEY       =    CURLOPTTYPE_STRINGPOINT + 230,
          (* Path to Unix domain socket *)
          CURLOPT_UNIX_SOCKET_PATH      =    CURLOPTTYPE_STRINGPOINT + 231,
          (* Set if we should verify the certificate status. *)
          CURLOPT_SSL_VERIFYSTATUS      =    CURLOPTTYPE_LONG + 232,
          (* Set if we should enable TLS false start. *)
          CURLOPT_SSL_FALSESTART        =    CURLOPTTYPE_LONG + 233,
          (* Do not squash dot-dot sequences *)
          CURLOPT_PATH_AS_IS  =    CURLOPTTYPE_LONG + 234,
          (* Proxy Service Name *)
          CURLOPT_PROXY_SERVICE_NAME    =    CURLOPTTYPE_STRINGPOINT + 235,
          (* Service Name *)
          CURLOPT_SERVICE_NAME=    CURLOPTTYPE_STRINGPOINT + 236,
          (* Wait/don't wait for pipe/mutex to clarify *)
          CURLOPT_PIPEWAIT    =    CURLOPTTYPE_LONG + 237,
          (* Set the protocol used when curl is given a URL without a protocol *)
          CURLOPT_DEFAULT_PROTOCOL      =    CURLOPTTYPE_STRINGPOINT + 238,
          (* Set stream weight, 1 - 256 (default is 16) *)
          CURLOPT_STREAM_WEIGHT         =    CURLOPTTYPE_LONG + 239,
          (* Set stream dependency on another CURL handle *)
          CURLOPT_STREAM_DEPENDS        =    CURLOPTTYPE_OBJECTPOINT + 240,
          (* Set E-xclusive stream dependency on another CURL handle *)
          CURLOPT_STREAM_DEPENDS_E      =    CURLOPTTYPE_OBJECTPOINT + 241,
          (* Do not send any tftp option requests to the server *)
          CURLOPT_TFTP_NO_OPTIONS       =    CURLOPTTYPE_LONG + 242,
          (* Linked-list of host:port:connect-to-host:connect-to-port,
          overrides the URL's host:port (only for the network layer) *)
          CURLOPT_CONNECT_TO  =    CURLOPTTYPE_SLISTPOINT + 243,
          (* Set TCP Fast Open *)
          CURLOPT_TCP_FASTOPEN=    CURLOPTTYPE_LONG + 244,
          (* Continue to send data if the server responds early with an
          * HTTP status code >= 300 *)
          CURLOPT_KEEP_SENDING_ON_ERROR =    CURLOPTTYPE_LONG + 245,
          (* The CApath or CAfile used to validate the proxy certificate
          this option is used only if PROXY_SSL_VERIFYPEER is true *)
          CURLOPT_PROXY_CAINFO=    CURLOPTTYPE_STRINGPOINT + 246,
          (* The CApath directory used to validate the proxy certificate
          this option is used only if PROXY_SSL_VERIFYPEER is true *)
          CURLOPT_PROXY_CAPATH=    CURLOPTTYPE_STRINGPOINT + 247,
          (* Set if we should verify the proxy in ssl handshake,
          set 1 to verify. *)
          CURLOPT_PROXY_SSL_VERIFYPEER  =    CURLOPTTYPE_LONG + 248,
          (* Set if we should verify the Common name from the proxy certificate in ssl
          * handshake, set 1 to check existence, 2 to ensure that it matches
          * the provided hostname. *)
          CURLOPT_PROXY_SSL_VERIFYHOST  =    CURLOPTTYPE_LONG + 249,
          (* What version to specifically try to use for proxy.
          See CURL_SSLVERSION defines below. *)
          CURLOPT_PROXY_SSLVERSION      =    CURLOPTTYPE_VALUES + 250,
          (* Set a username for authenticated TLS for proxy *)
          CURLOPT_PROXY_TLSAUTH_USERNAME=    CURLOPTTYPE_STRINGPOINT + 251,
          (* Set a password for authenticated TLS for proxy *)
          CURLOPT_PROXY_TLSAUTH_PASSWORD=    CURLOPTTYPE_STRINGPOINT + 252,
          (* Set authentication type for authenticated TLS for proxy *)
          CURLOPT_PROXY_TLSAUTH_TYPE    =    CURLOPTTYPE_STRINGPOINT + 253,
          (* name of the file keeping your private SSL-certificate for proxy *)
          CURLOPT_PROXY_SSLCERT         =    CURLOPTTYPE_STRINGPOINT + 254,
          (* type of the file keeping your SSL-certificate ("DER", "PEM", "ENG") for
          proxy *)
          CURLOPT_PROXY_SSLCERTTYPE     =    CURLOPTTYPE_STRINGPOINT + 255,
          (* name of the file keeping your private SSL-key for proxy *)
          CURLOPT_PROXY_SSLKEY          =    CURLOPTTYPE_STRINGPOINT + 256,
          (* type of the file keeping your private SSL-key ("DER", "PEM", "ENG") for
          proxy *)
          CURLOPT_PROXY_SSLKEYTYPE      =    CURLOPTTYPE_STRINGPOINT + 257,
          (* password for the SSL private key for proxy *)
          CURLOPT_PROXY_KEYPASSWD       =    CURLOPTTYPE_STRINGPOINT + 258,
          (* Specify which SSL ciphers to use for proxy *)
          CURLOPT_PROXY_SSL_CIPHER_LIST =    CURLOPTTYPE_STRINGPOINT + 259,
          (* CRL file for proxy *)
          CURLOPT_PROXY_CRLFILE    =    CURLOPTTYPE_STRINGPOINT + 260,
          (* Enable/disable specific SSL features with a bitmask for proxy, see
          CURLSSLOPT_* *)
          CURLOPT_PROXY_SSL_OPTIONS=    CURLOPTTYPE_LONG + 261,
          (* Name of pre proxy to use. *)
          CURLOPT_PRE_PROXY   =    CURLOPTTYPE_STRINGPOINT + 262,
          (* The public key in DER form used to validate the proxy public key
          this option is used only if PROXY_SSL_VERIFYPEER is true *)
          CURLOPT_PROXY_PINNEDPUBLICKEY =    CURLOPTTYPE_STRINGPOINT + 263,
          (* Path to an abstract Unix domain socket *)
          CURLOPT_ABSTRACT_UNIX_SOCKET  =    CURLOPTTYPE_STRINGPOINT + 264,
          (* Suppress proxy CONNECT response headers from user callbacks *)
          CURLOPT_SUPPRESS_CONNECT_HEADERS   =    CURLOPTTYPE_LONG + 265,
          (* The request target, instead of extracted from the URL *)
          CURLOPT_REQUEST_TARGET   =    CURLOPTTYPE_STRINGPOINT + 266,
          (* bitmask of allowed auth methods for connections to SOCKS5 proxies *)
          CURLOPT_SOCKS5_AUTH =    CURLOPTTYPE_LONG + 267,
          (* Enable/disable SSH compression *)
          CURLOPT_SSH_COMPRESSION  =    CURLOPTTYPE_LONG + 268,
          (* Post MIME data. *)
          CURLOPT_MIMEPOST    =    CURLOPTTYPE_OBJECTPOINT + 269,
          (* Time to use with the CURLOPT_TIMECONDITION. Specified in number of
          seconds since 1 Jan 1970. *)
          CURLOPT_TIMEVALUE_LARGE  =    CURLOPTTYPE_OFF_T + 270,
          (* Head start in milliseconds to give happy eyeballs. *)
          CURLOPT_HAPPY_EYEBALLS_TIMEOUT_MS  =    CURLOPTTYPE_LONG + 271,
          (* Function that will be called before a resolver request is made *)
          CURLOPT_RESOLVER_START_FUNCTION    =    CURLOPTTYPE_FUNCTIONPOINT + 272,
          (* User data to pass to the resolver start callback. *)
          CURLOPT_RESOLVER_START_DATA        =    CURLOPTTYPE_CBPOINT + 273,
          (* send HAProxy PROXY protocol header? *)
          CURLOPT_HAPROXYPROTOCOL  =    CURLOPTTYPE_LONG + 274,
          (* shuffle addresses before use when DNS returns multiple *)
          CURLOPT_DNS_SHUFFLE_ADDRESSES      =    CURLOPTTYPE_LONG + 275,
          (* Specify which TLS 1.3 ciphers suites to use *)
          CURLOPT_TLS13_CIPHERS    =    CURLOPTTYPE_STRINGPOINT + 276,
          CURLOPT_PROXY_TLS13_CIPHERS        =    CURLOPTTYPE_STRINGPOINT + 277,
          (* Disallow specifying username/login in URL. *)
          CURLOPT_DISALLOW_USERNAME_IN_URL   =    CURLOPTTYPE_LONG + 278,
          (* DNS-over-HTTPS URL *)
          CURLOPT_DOH_URL     =    CURLOPTTYPE_STRINGPOINT + 279,
          (* Preferred buffer size to use for uploads *)
          CURLOPT_UPLOAD_BUFFERSIZE     =    CURLOPTTYPE_LONG + 280,
          (* Time in ms between connection upkeep calls for long-lived connections. *)
          CURLOPT_UPKEEP_INTERVAL_MS    =    CURLOPTTYPE_LONG + 281,
          (* Specify URL using CURL URL API. *)
          CURLOPT_CURLU  =    CURLOPTTYPE_OBJECTPOINT + 282,
          (* add trailing data just after no more data is available *)
          CURLOPT_TRAILERFUNCTION  =    CURLOPTTYPE_FUNCTIONPOINT + 283,
          (* pointer to be passed to HTTP_TRAILER_FUNCTION *)
          CURLOPT_TRAILERDATA =    CURLOPTTYPE_CBPOINT + 284,
          (* set this to 1L to allow HTTP/0.9 responses or 0L to disallow *)
          CURLOPT_HTTP09_ALLOWED   =    CURLOPTTYPE_LONG + 285,
          (* alt-svc control bitmask *)
          CURLOPT_ALTSVC_CTRL =    CURLOPTTYPE_LONG + 286,
          (* alt-svc cache file name to possibly read from/write to *)
          CURLOPT_ALTSVC =    CURLOPTTYPE_STRINGPOINT + 287,
          (* maximum age (idle time) of a connection to consider it for reuse
          * (in seconds) *)
          CURLOPT_MAXAGE_CONN =    CURLOPTTYPE_LONG + 288,
          (* SASL authorization identity *)
          CURLOPT_SASL_AUTHZID=    CURLOPTTYPE_STRINGPOINT + 289,
          (* allow RCPT TO command to fail for some recipients *)
          CURLOPT_MAIL_RCPT_ALLOWFAILS  =    CURLOPTTYPE_LONG + 290,
          (* the private SSL-certificate as a "blob" *)
          CURLOPT_SSLCERT_BLOB     =    CURLOPTTYPE_BLOB + 291,
          CURLOPT_SSLKEY_BLOB =    CURLOPTTYPE_BLOB + 292,
          CURLOPT_PROXY_SSLCERT_BLOB    =    CURLOPTTYPE_BLOB + 293,
          CURLOPT_PROXY_SSLKEY_BLOB     =    CURLOPTTYPE_BLOB + 294,
          CURLOPT_ISSUERCERT_BLOB  =    CURLOPTTYPE_BLOB + 295,
          (* Issuer certificate for proxy *)
          CURLOPT_PROXY_ISSUERCERT =    CURLOPTTYPE_STRINGPOINT + 296,
          CURLOPT_PROXY_ISSUERCERT_BLOB =    CURLOPTTYPE_BLOB + 297,
          (* the EC curves requested by the TLS client (RFC 8422, 5.1);
          * OpenSSL support via 'set_groups'/'set_curves':
          * https://www.openssl.org/docs/manmaster/man3/SSL_CTX_set1_groups.html
          *)
          CURLOPT_SSL_EC_CURVES    =    CURLOPTTYPE_STRINGPOINT + 298,
          (* HSTS bitmask *)
          CURLOPT_HSTS_CTRL   =    CURLOPTTYPE_LONG + 299,
          (* HSTS file name *)
          CURLOPT_HSTS   =    CURLOPTTYPE_STRINGPOINT + 300,
          (* HSTS read callback *)
          CURLOPT_HSTSREADFUNCTION =    CURLOPTTYPE_FUNCTIONPOINT + 301,
          CURLOPT_HSTSREADDATA     =    CURLOPTTYPE_CBPOINT + 302,
          (* HSTS write callback *)
          CURLOPT_HSTSWRITEFUNCTION     =    CURLOPTTYPE_FUNCTIONPOINT + 303,
          CURLOPT_HSTSWRITEDATA    =    CURLOPTTYPE_CBPOINT + 304,
          (* Parameters for V4 signature *)
          CURLOPT_AWS_SIGV4   =    CURLOPTTYPE_STRINGPOINT + 305,
          (* Same as CURLOPT_SSL_VERIFYPEER but for DoH (DNS-over-HTTPS) servers. *)
          CURLOPT_DOH_SSL_VERIFYPEER    =    CURLOPTTYPE_LONG + 306,
          (* Same as CURLOPT_SSL_VERIFYHOST but for DoH (DNS-over-HTTPS) servers. *)
          CURLOPT_DOH_SSL_VERIFYHOST    =    CURLOPTTYPE_LONG + 307,
          (* Same as CURLOPT_SSL_VERIFYSTATUS but for DoH (DNS-over-HTTPS) servers. *)
          CURLOPT_DOH_SSL_VERIFYSTATUS  =    CURLOPTTYPE_LONG + 308,
          (* The CA certificates as "blob" used to validate the peer certificate
          this option is used only if SSL_VERIFYPEER is true *)
          CURLOPT_CAINFO_BLOB =    CURLOPTTYPE_BLOB + 309,
          (* The CA certificates as "blob" used to validate the proxy certificate
          this option is used only if PROXY_SSL_VERIFYPEER is true *)
          CURLOPT_PROXY_CAINFO_BLOB     =    CURLOPTTYPE_BLOB + 310,
          (* used by scp/sftp to verify the host's public key *)
          CURLOPT_SSH_HOST_PUBLIC_KEY_SHA256 =    CURLOPTTYPE_STRINGPOINT + 311,
          (* Function that will be called immediately before the initial request
          is made on a connection (after any protocol negotiation step).  *)
          CURLOPT_PREREQFUNCTION   =    CURLOPTTYPE_FUNCTIONPOINT + 312,
          (* Data passed to the CURLOPT_PREREQFUNCTION callback *)
          CURLOPT_PREREQDATA  =    CURLOPTTYPE_CBPOINT + 313,
          (* maximum age (since creation) of a connection to consider it for reuse
          * (in seconds) *)
          CURLOPT_MAXLIFETIME_CONN =    CURLOPTTYPE_LONG + 314,
          (* Set MIME option flags. *)
          CURLOPT_MIME_OPTIONS     =    CURLOPTTYPE_LONG + 315,
          (* set the SSH host key callback, must point to a curl_sshkeycallback
          function *)
          CURLOPT_SSH_HOSTKEYFUNCTION   =    CURLOPTTYPE_FUNCTIONPOINT + 316,
          (* set the SSH host key callback custom pointer *)
          CURLOPT_SSH_HOSTKEYDATA  =    CURLOPTTYPE_CBPOINT + 317,
          (* specify which protocols that are allowed to be used for the transfer,
          which thus helps the app which takes URLs from users or other external
          inputs and want to restrict what protocol(s) to deal with. Defaults to
          all built-in protocols. *)
          CURLOPT_PROTOCOLS_STR    =    CURLOPTTYPE_STRINGPOINT + 318,
          (* specify which protocols that libcurl is allowed to follow directs to *)
          CURLOPT_REDIR_PROTOCOLS_STR   =    CURLOPTTYPE_STRINGPOINT + 319,
          (* websockets options *)
          CURLOPT_WS_OPTIONS  =    CURLOPTTYPE_LONG + 320,
          (* CA cache timeout *)
          CURLOPT_CA_CACHE_TIMEOUT =    CURLOPTTYPE_LONG + 321,
          (* Can leak things, gonna exit() soon *)
          CURLOPT_QUICK_EXIT  =    CURLOPTTYPE_LONG + 322,
          (* set a specific client IP for HAProxy PROXY protocol header? *)
          CURLOPT_HAPROXY_CLIENT_IP     =    CURLOPTTYPE_STRINGPOINT + 323,
          (* millisecond version *)
          CURLOPT_SERVER_RESPONSE_TIMEOUT_MS =    CURLOPTTYPE_LONG + 324,
          (* the last unused *)
          CURLOPT_LASTENTRY
     );

     function curl_easy_init: CURL; cdecl; external CURL_EXTERN;
     function curl_easy_setopt(PCURL: CURL; option: CURLoption): CURLcode; cdecl; varargs; external CURL_EXTERN;
     function curl_easy_perform(PCURL: CURL): CURLcode; cdecl; external CURL_EXTERN;
     procedure curl_easy_cleanup(PCURL: CURL); cdecl; external CURL_EXTERN;

const
     CURLOPT_PROGRESSDATA          =    CURLoption.CURLOPT_XFERINFODATA;
implementation

end.
