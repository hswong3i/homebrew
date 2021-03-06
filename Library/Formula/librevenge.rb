class Librevenge < Formula
  desc "Base library for writing document import filters"
  homepage "https://sourceforge.net/p/libwpd/wiki/librevenge/"
  url "http://dev-www.libreoffice.org/src/librevenge-0.0.2.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libwpd/librevenge/librevenge-0.0.2/librevenge-0.0.2.tar.bz2"
  sha256 "dedd6fe1f643fc2f254f2ad3719547084bd86bcc482104b995caf3b828368b18"

  bottle do
    cellar :any
    revision 2
    sha256 "3918ba5cde28067e9afd41881efd7948b79355751179cd01d4b34efa319bfbd1" => :el_capitan
    sha256 "b4b7a9049414395115d58fc95c48dfb2eb79fd0255e8ca85e1b076db891eeccb" => :yosemite
    sha256 "3b5bced358dc205d7a848854a9460bb5a49abaec97ada3d284ef2ad9262aa882" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost"

  # Fix build with Boost 1.59
  # https://sourceforge.net/p/libwpd/tickets/6/
  # https://sourceforge.net/p/libwpd/librevenge/ci/0beee70d1bf52f0d81b60ee8c373e477991fe546/
  patch :DATA

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <librevenge/librevenge.h>
      int main() {
        librevenge::RVNGString str;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-lrevenge-0.0",
                   "-I#{include}/librevenge-0.0", "-L#{lib}"
  end
end
__END__
diff --git a/src/lib/Makefile.in b/src/lib/Makefile.in
index d05d38f..692fcd0 100644
--- a/src/lib/Makefile.in
+++ b/src/lib/Makefile.in
@@ -467,7 +467,7 @@ librevenge_@RVNG_MAJOR_VERSION@_@RVNG_MINOR_VERSION@_include_HEADERS = \
 AM_CXXFLAGS = -I$(top_srcdir)/inc $(DEBUG_CXXFLAGS) $(ZLIB_CFLAGS) \
	$(am__append_1)
 librevenge_@RVNG_MAJOR_VERSION@_@RVNG_MINOR_VERSION@_la_CPPFLAGS =  \
-	-DLIBREVENGE_BUILD $(am__append_2)
+	-DLIBREVENGE_BUILD -DBOOST_ERROR_CODE_HEADER_ONLY $(am__append_2)
 librevenge_@RVNG_MAJOR_VERSION@_@RVNG_MINOR_VERSION@_la_LIBADD = @LIBREVENGE_WIN32_RESOURCE@
 librevenge_@RVNG_MAJOR_VERSION@_@RVNG_MINOR_VERSION@_la_DEPENDENCIES = @LIBREVENGE_WIN32_RESOURCE@
 librevenge_@RVNG_MAJOR_VERSION@_@RVNG_MINOR_VERSION@_la_LDFLAGS = $(version_info) -export-dynamic $(no_undefined)
