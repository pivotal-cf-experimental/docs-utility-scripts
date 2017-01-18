# Doc Ops Release Playbooks

## Overview

This document includes two playbooks:

1. The **New Release Playbook** describes how to publish edge documentation to production when a new release goes GA (general availability).

2. The **Edge Documentation Playbook**l describes how to publish edge documentation to our staging site. Edge content documents the new, unreleased version of PCF. We need this edge documentation for our writers, PMs, field engineers, product owners, and SMEs to review prior to publishing.

## Cadence

We follow a two-part routine for publishing our core PCF documentation that accommodates a sensible workflow for writers along a regular publishing cadence of new releases. 

This cycle consists of the following phases:

**Phase One**: When a new version of PCF goes GA, we complete the New Release Playbook procedures that publish the new release documentation to production. 
Our operational workflow during this stage includes these components:

* Write and publish content for the newly released version against master branches of OSS/PCF repos.
* Support prior release docs on their mapped numbered branches in OSS/PCF, including parallel git contribution for content that affects multiple versions. (ex: content for PCF 1.8 and OSS 239)

**Phase Two**: 30-60 days prior to a new release going GA, we complete the Edge Documentation Playbook to publish edge documentation to a password-protected staging site. Our operational workflow during this stage includes these components:

* Write and publish edge content for the upcoming release against master branches of OSS/PCF repos.
* Support current and prior versioned release docs on their mapped numbered branches, including parallel git contribution for content that affects multiple versions.

When the next version of PCF goes GA, complete the New Release Playbook to begin the cycle again.
