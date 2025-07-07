# Source: mtls.go - generateCert function
Feature: mTLS Certificate Generation

  Background:
    The `generateCert` function creates temporary, self-signed certificates for AutoMTLS.
    The properties of these certificates and keys must be consistent and valid for mTLS across platforms.

  Scenario: generateCert successfully produces a PEM-encoded certificate and private key
    When `generateCert()` is called
    Then it should return a non-nil PEM-encoded certificate byte slice
    And it should return a non-nil PEM-encoded EC private key byte slice
    And it should return a nil error

  Scenario: Properties of the generated certificate
    Given `generateCert()` is called successfully, yielding a PEM-encoded certificate
    When the PEM-encoded certificate is parsed
    Then the parsed x509.Certificate should have the following properties:
      | Property              | Expected Value / Contains                     | Notes                                      |
      | Subject CommonName    | "localhost"                                   |                                            |
      | Subject Organization  | ["HashiCorp"]                                 |                                            |
      | DNSNames              | ["localhost"]                                 |                                            |
      | IsCA                  | true                                          | Self-signed CA for this mTLS context       |
      | BasicConstraintsValid | true                                          |                                            |
      | ExtKeyUsage           | ClientAuth, ServerAuth                        | Suitable for both client and server in mTLS|
      | KeyUsage              | DigitalSignature, KeyEncipherment, KeyAgreement, CertSign | Comprehensive usages for a CA cert       |
      | SignatureAlgorithm    | ECDSAWithSHA521 (or other P521 compatible)    | Based on elliptic.P521() key             |
      | PublicKeyAlgorithm    | ECDSA                                         |                                            |
    And its "NotBefore" time should be approximately 30 seconds before the current time
    And its "NotAfter" time should be approximately 30 years after the current time

  Scenario: Properties of the generated private key
    Given `generateCert()` is called successfully, yielding a PEM-encoded private key
    When the PEM-encoded private key is parsed
    Then it should be a valid ECDSA private key corresponding to the P-521 curve

  Scenario: generateCert handles errors from cryptographic operations (conceptual)
    Given a scenario where `ecdsa.GenerateKey` will return an error "key_gen_err"
    When `generateCert()` is called
    Then it should return nil for certificate, nil for private key, and an error "key_gen_err"
    # Similar checks for errors from rand.Int, x509.CreateCertificate, pem.Encode, x509.MarshalECPrivateKey
    # This ensures that failures in underlying crypto libraries are propagated.tool_code
read_files(["features/client_security/mtls_cert_generation.feature"])
