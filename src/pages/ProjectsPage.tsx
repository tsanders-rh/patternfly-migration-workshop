import React from 'react';
import {
  PageSection,
  Title,
  Card,
  CardBody,
  Breadcrumb,
  BreadcrumbItem,
  Divider
} from '@patternfly/react-core';
import {
  UserProfile,
  StatusBadge,
  PageHeader
} from '../components';

export const ProjectsPage: React.FC = () => {
  return (
    <>
      <PageSection variant="light">
        <Breadcrumb>
          <BreadcrumbItem to="#">Home</BreadcrumbItem>
          <BreadcrumbItem isActive>Projects</BreadcrumbItem>
        </Breadcrumb>
        <Title headingLevel="h1" size="2xl" className="pf-v5-u-mt-md">
          Projects
        </Title>
        <p className="pf-v5-u-mt-sm pf-v5-u-color-200">
          Tier 1 Migration Patterns: Simple component renames and prop changes
        </p>
      </PageSection>
      <Divider />
      <PageSection>
        <Card className="pf-v5-u-mb-md">
          <CardBody>
            <Title headingLevel="h2" size="lg" className="pf-v5-u-mb-md">
              Project Members
            </Title>
            <p className="pf-v5-u-mb-md pf-v5-u-font-size-sm pf-v5-u-color-200">
              Demonstrates Text → Content component migration
            </p>
            <UserProfile
              name="Jane Doe"
              role="Senior Software Engineer"
              email="jane.doe@example.com"
            />
          </CardBody>
        </Card>

        <Card className="pf-v5-u-mb-md">
          <CardBody>
            <Title headingLevel="h2" size="lg" className="pf-v5-u-mb-md">
              Project Status
            </Title>
            <p className="pf-v5-u-mb-md pf-v5-u-font-size-sm pf-v5-u-color-200">
              Demonstrates Chip → Label migration and isDisabled → disabled prop changes
            </p>
            <PageHeader
              title="Component Examples"
              subtitle="PatternFly v5 → v6 Migration"
            />
            <div className="pf-v5-u-mt-md" style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
              <StatusBadge status="active" isDisabled={false} />
              <StatusBadge status="pending" />
              <StatusBadge status="inactive" isDisabled={true} />
            </div>
          </CardBody>
        </Card>

        <div
          className="pf-v5-u-p-md pf-v5-u-background-color-200"
          style={{ borderRadius: '4px', border: '1px solid #d2d2d2' }}
        >
          <strong>Migration Notes:</strong>
          <ul className="pf-v5-u-mt-sm pf-v5-u-font-size-sm">
            <li>Text component → Content component</li>
            <li>Chip component → Label component</li>
            <li>isDisabled prop → disabled prop</li>
            <li>CSS classes: pf-v5-* → pf-v6-*</li>
          </ul>
        </div>
      </PageSection>
    </>
  );
};
