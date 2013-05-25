require 'formula'

class Openresty < Formula
  homepage 'http://openresty.org/'
  url 'http://openresty.org/download/ngx_openresty-1.2.8.5.tar.gz'
  sha1 'dc0bf7f73c6e9e0ae2b77081413996b9eb293ec0'

  depends_on "pcre"

  def install
    # Build it
    system "./configure", "--with-luajit", "--prefix=#{prefix}"
    system "make", "install"

    # Name the binary openresty to avoid conflicting with the standard nginx
    bin.mkpath
    system "ln -s #{prefix}/nginx/sbin/nginx #{bin}/openresty"

    # Create the log directory
    logs = "#{prefix}/nginx/logs"
    mkpath logs
    touch "#{logs}/access.log"
    touch "#{logs}/error.log"
  end

  # Changes default port to 8081
  def patches
    DATA
  end

  test do
    system "openresty -t"
  end
end

__END__
--- a/bundle/nginx-1.2.8/conf/nginx.conf	2013-05-25 13:24:26.000000000 -0400
+++ b/bundle/nginx-1.2.8/conf/nginx.conf	2013-05-25 13:27:41.000000000 -0400
@@ -33,7 +33,7 @@
     #gzip  on;
 
     server {
-        listen       80;
+        listen       8081;
         server_name  localhost;
 
         #charset koi8-r;

