import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/Domain.dart';
import "package:test/test.dart";

void main() {
  test('Test splitDomainName', () {
    expect(DomainUtils.splitDomainName("example.com"), ["example", "com"]);
    expect(DomainUtils.splitDomainName("subdomain.example.com"),
        ["subdomain", "example", "com"]);
  });

  test('Test parseDomain', () {
    Domain domain = DomainUtils.parseDomain("example.com");
    expect(domain.toString(), "example.com");
    expect(domain.sld, "example");
    expect(domain.tld, "com");
    expect(domain.subTld, null);

    domain = DomainUtils.parseDomain("example.co.uk");
    expect(domain.sld, "example");
    expect(domain.tld, "uk");
    expect(domain.subTld, "co");

    domain = DomainUtils.parseDomain("subdomain.example.co.uk");
    expect(domain.sld, "example");
    expect(domain.tld, "uk");
    expect(domain.subTld, "co");

    domain = DomainUtils.parseDomain("example");
    expect(domain, null);

    domain = DomainUtils.parseDomain("star.bd");
    expect(domain.sld, "star");
    expect(domain.subTld, null);
    expect(domain.tld, "bd");

    domain = DomainUtils.parseDomain("whatever.fantasy.example.com");
    expect(domain.toString(), "example.com");
    expect(domain.sld, "example");
    expect(domain.subTld, null);
    expect(domain.tld, "com");

    domain = DomainUtils.parseDomain("公司.cn");
    expect(domain.toString(), "公司.cn");
    expect(domain.sld, "公司");
    expect(domain.subTld, null);
    expect(domain.tld, "cn");

    domain = DomainUtils.parseDomain("test.我爱你");
    expect(domain.toString(), "test.我爱你");
    expect(domain.sld, "test");
    expect(domain.subTld, null);
    expect(domain.tld, "我爱你");

    domain = DomainUtils.parseDomain("xn--6qq986b3xl.com");
    expect(domain.toString(), "xn--6qq986b3xl.com");
    expect(domain.sld, "xn--6qq986b3xl");
    expect(domain.subTld, null);
    expect(domain.tld, "com");

    domain = DomainUtils.parseDomain("test.xn--6qq986b3xl");
    expect(domain.toString(), "test.xn--6qq986b3xl");
    expect(domain.sld, "test");
    expect(domain.subTld, null);
    expect(domain.tld, "xn--6qq986b3xl");

    domain = DomainUtils.parseDomain("test.москва");
    expect(domain.toString(), "test.москва");
    expect(domain.sld, "test");
    expect(domain.subTld, null);
    expect(domain.tld, "москва");

    domain = DomainUtils.parseDomain("www.example.com");
    expect(domain.toString(), "example.com");
    expect(domain.sld, "example");
    expect(domain.subTld, null);
    expect(domain.tld, "com");
  });

  test('Test isCCTLD', () {
    expect(DomainUtils.isCCTLD("com"), false);
    expect(DomainUtils.isCCTLD("de"), true);
    expect(DomainUtils.isCCTLD("xn--mgba3a4f16a"), true);
  });

  test('Test isGTLD', () {
    expect(DomainUtils.isGTLD("com"), true);
    expect(DomainUtils.isGTLD("de"), false);
    expect(DomainUtils.isGTLD("xn--mgba3a4f16a"), false);
  });

  test('Test isNGTLD', () {
    expect(DomainUtils.isNGTLD("rocks"), true);
    expect(DomainUtils.isNGTLD("de"), false);
    expect(DomainUtils.isNGTLD("xn--mgba3a4f16a"), false);
  });

  test('Test isTld', () {
    expect(DomainUtils.isTld("rocks"), true);
    expect(DomainUtils.isTld("de"), true);
    expect(DomainUtils.isTld("xn--mgba3a4f16a"), true);
    expect(DomainUtils.isTld("fooBar"), false);
  });

  test('Test isSubDomain', () {
    expect(DomainUtils.isSubDomain("www.test.de"), true);
    expect(DomainUtils.isSubDomain("sub1.test.de"), true);
    expect(DomainUtils.isSubDomain("sub2.sub1.test.de"), true);
    expect(DomainUtils.isSubDomain("www.test.de.com"), true);
    expect(DomainUtils.isSubDomain("test.de.com"), false);
    expect(DomainUtils.isSubDomain("test.de"), false);
  });

  test('Test isSubTld', () {
    expect(DomainUtils.isSubTld("ac", "com"), true);
    expect(DomainUtils.isSubTld("ae", "net"), true);
    expect(DomainUtils.isSubTld("aero", "agents"), true);
    expect(DomainUtils.isSubTld("com", "foobar"), false);
    expect(DomainUtils.isSubTld("de", "subtld"), false);
  });

  test('Test isDomainName', () {
    expect(DomainUtils.isDomainName("example.co.uk"), true);
    expect(DomainUtils.isDomainName("example"), false);
    expect(DomainUtils.isDomainName("example.com"), true);
    expect(DomainUtils.isDomainName("example.qwertzu"), false);
  });

  test('Test isSubDomainOf', () {
    expect(DomainUtils.isSubDomainOf("sub1.domain.com", "domain.com"), true);
    expect(DomainUtils.isSubDomainOf("sub2.sub1.domain.com", "sub1.domain.com"),
        true);
    expect(DomainUtils.isSubDomainOf("sub1.domain2.com", "domain.com"), false);
  });

  test('Test getDomainFromUrl', () {
    expect(DomainUtils.getDomainFromUrl("http://example.com").toString(),
        "example.com");
    expect(
        DomainUtils.getDomainFromUrl("https://example.com/foobar").toString(),
        "example.com");
    expect(
        DomainUtils.getDomainFromUrl("https://example.com/foobar?key=foo")
            .toString(),
        "example.com");
    expect(DomainUtils.getDomainFromUrl("www.example.com").toString(),
        "example.com");
    expect(DomainUtils.getDomainFromUrl("http://www.example.com").toString(),
        "example.com");
    expect(DomainUtils.getDomainFromUrl("https://www.example.com").toString(),
        "example.com");
    expect(DomainUtils.getDomainFromUrl("http://sub1.example.com").toString(),
        "example.com");
    expect(DomainUtils.getDomainFromUrl("https://sub1.example.com").toString(),
        "example.com");
  });
}
