import React, { useState } from 'react';
import {
  PageSection,
  Title,
  Card,
  CardBody,
  Breadcrumb,
  BreadcrumbItem,
  Button,
  Alert,
  Divider
} from '@patternfly/react-core';
import {
  CompatibilityLayer,
  ConsumerComponent
} from '../components';

export const StoragePage: React.FC = () => {
  const [showEdgeCases, setShowEdgeCases] = useState(true);

  return (
    <>
      <PageSection variant="light">
        <Breadcrumb>
          <BreadcrumbItem to="#">Home</BreadcrumbItem>
          <BreadcrumbItem isActive>Storage</BreadcrumbItem>
        </Breadcrumb>
        <Title headingLevel="h1" size="2xl" className="pf-v5-u-mt-md">
          Storage
        </Title>
        <p className="pf-v5-u-mt-sm pf-v5-u-color-200">
          Tier 3 Migration Patterns: Edge cases requiring manual intervention
        </p>
      </PageSection>
      <Divider />
      <PageSection>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
          <Title headingLevel="h2" size="xl">
            Edge Cases & Special Scenarios
          </Title>
          <Button
            variant="secondary"
            onClick={() => setShowEdgeCases(!showEdgeCases)}
          >
            {showEdgeCases ? 'Hide' : 'Show'} Edge Cases
          </Button>
        </div>

        {showEdgeCases && (
          <>
            <Alert
              variant="warning"
              title="AI Migration Limitations"
              className="pf-v5-u-mb-md"
              isInline
            >
              These patterns demonstrate scenarios where AI-assisted migration needs careful review
              or manual intervention.
            </Alert>

            <Card className="pf-v5-u-mb-md">
              <CardBody>
                <Title headingLevel="h3" size="lg" className="pf-v5-u-mb-md">
                  Compatibility Layer
                </Title>
                <Alert
                  variant="info"
                  title="⚠️ DO NOT auto-migrate"
                  className="pf-v5-u-mb-md"
                  isInline
                >
                  This component intentionally uses v5 patterns for gradual migration support.
                  Auto-migrating would break backward compatibility.
                </Alert>
                <CompatibilityLayer useV6={false}>
                  This component maintains dual v5/v6 support for gradual migrations
                </CompatibilityLayer>
              </CardBody>
            </Card>

            <Card className="pf-v5-u-mb-md">
              <CardBody>
                <Title headingLevel="h3" size="lg" className="pf-v5-u-mb-md">
                  Custom Wrapper Component
                </Title>
                <Alert
                  variant="info"
                  title="ℹ️ Migrate internals, keep API stable"
                  className="pf-v5-u-mb-md"
                  isInline
                >
                  Internal implementation should migrate to v6, but public API must remain stable.
                </Alert>
                <ConsumerComponent />
              </CardBody>
            </Card>

            <Card className="pf-v5-u-mb-md">
              <CardBody>
                <Title headingLevel="h3" size="lg" className="pf-v5-u-mb-md">
                  Dynamic Imports
                </Title>
                <Alert
                  variant="warning"
                  title="⚠️ AI cannot handle safely"
                  className="pf-v5-u-mb-md"
                  isInline
                >
                  Template literals in dynamic imports cannot be safely migrated by AI.
                  Requires manual review.
                </Alert>
                <div className="pf-v5-u-p-md pf-v5-u-background-color-100" style={{ borderRadius: '4px' }}>
                  <code>import(`@patternfly/react-core/$&#123;componentName&#125;`)</code>
                  <p className="pf-v5-u-mt-sm pf-v5-u-font-size-sm">
                    This pattern needs manual intervention to ensure correct migration.
                  </p>
                </div>
              </CardBody>
            </Card>

            <div
              className="pf-v5-u-p-md pf-v5-u-background-color-200"
              style={{ borderRadius: '4px', border: '1px solid #d2d2d2' }}
            >
              <strong>When to Reject AI Suggestions:</strong>
              <ul className="pf-v5-u-mt-sm pf-v5-u-font-size-sm">
                <li>Compatibility layers with intentional v5 usage</li>
                <li>Public APIs that must remain stable</li>
                <li>Dynamic imports with template literals</li>
                <li>Custom wrappers with specific version requirements</li>
                <li>Business logic tied to specific component versions</li>
              </ul>
            </div>
          </>
        )}
      </PageSection>
    </>
  );
};
