# Releasing RiskGlass

RiskGlass packages its SwiftPM executable directly into a standard macOS app
bundle. This keeps the package manifest as the source of truth and avoids a
second, generated Xcode project.

## Preview release

Create and push a semantic-version tag:

```bash
git tag v0.1.0
git push origin v0.1.0
```

The release workflow runs the tests, creates a hardened-runtime app with an
ad-hoc signature, publishes a ZIP archive, and attaches its SHA-256 checksum.

## Developer ID release

A public build that opens without a Gatekeeper exception must be signed and
notarized with an Apple Developer ID certificate. Import the certificate into
the build machine's keychain, then package with its identity:

```bash
SIGNING_IDENTITY="Developer ID Application: Example (TEAMID)" \
  VERSION=0.1.0 ./scripts/package-app.sh
```

Store the following values as GitHub Actions secrets before automating that
step on a protected release environment:

- `MACOS_CERTIFICATE`: base64-encoded Developer ID Application certificate
- `MACOS_CERTIFICATE_PASSWORD`: certificate export password
- `APPLE_ID`: Apple Developer account email
- `APPLE_TEAM_ID`: Apple Developer team identifier
- `APPLE_APP_SPECIFIC_PASSWORD`: app-specific notarization password

Submit the signed archive with `xcrun notarytool`, staple the notarization
ticket to the app, rebuild the archive, and verify it before publishing:

```bash
xcrun notarytool submit dist/RiskGlass-0.1.0-macOS.zip \
  --apple-id "$APPLE_ID" \
  --team-id "$APPLE_TEAM_ID" \
  --password "$APPLE_APP_SPECIFIC_PASSWORD" \
  --wait
xcrun stapler staple dist/RiskGlass.app
spctl --assess --type execute --verbose dist/RiskGlass.app
```

Never expose certificate material or notarization credentials in a pull
request workflow.
