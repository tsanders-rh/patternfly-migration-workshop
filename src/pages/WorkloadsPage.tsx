import React, { useState } from 'react';
import {
  PageSection,
  Title,
  Card,
  CardBody,
  Breadcrumb,
  BreadcrumbItem,
  Tabs,
  Tab,
  TabTitleText,
  Divider
} from '@patternfly/react-core';
import {
  ActionMenu,
  IconButtons,
  EmptyStateExample
} from '../components';

interface WorkloadsPageProps {
  activeItem: string;
}

export const WorkloadsPage: React.FC<WorkloadsPageProps> = ({ activeItem }) => {
  const [activeTabKey, setActiveTabKey] = useState(0);
  const [interactionsCount, setInteractionsCount] = useState(0);

  const handleInteraction = () => {
    setInteractionsCount(prev => prev + 1);
  };

  return (
    <>
      <PageSection variant="light">
        <Breadcrumb>
          <BreadcrumbItem to="#">Home</BreadcrumbItem>
          <BreadcrumbItem to="#">Workloads</BreadcrumbItem>
          <BreadcrumbItem isActive>
            {activeItem === 'pods' ? 'Pods' : 'Deployments'}
          </BreadcrumbItem>
        </Breadcrumb>
        <Title headingLevel="h1" size="2xl" className="pf-v5-u-mt-md">
          {activeItem === 'pods' ? 'Pods' : 'Deployments'}
        </Title>
        <p className="pf-v5-u-mt-sm pf-v5-u-color-200">
          Tier 2 Migration Patterns: Moderate complexity structural changes
        </p>
      </PageSection>
      <Divider />
      <PageSection>
        <div className="pf-v5-u-mb-md pf-v5-u-p-sm pf-v5-u-background-color-100" style={{ borderRadius: '4px' }}>
          <strong>Interactions logged:</strong> {interactionsCount}
        </div>

        <Card className="pf-v5-u-mb-md">
          <CardBody>
            <Tabs
              activeKey={activeTabKey}
              onSelect={(_event, tabIndex) => setActiveTabKey(tabIndex as number)}
            >
              <Tab eventKey={0} title={<TabTitleText>Details</TabTitleText>}>
                <div className="pf-v5-u-p-md">
                  <Title headingLevel="h2" size="lg" className="pf-v5-u-mb-md">
                    Resource Actions
                  </Title>
                  <p className="pf-v5-u-mb-md pf-v5-u-font-size-sm pf-v5-u-color-200">
                    Demonstrates MenuToggle icon restructuring (icon as child → icon prop)
                  </p>
                  <ActionMenu
                    onEdit={handleInteraction}
                    onDelete={handleInteraction}
                  />
                </div>
              </Tab>
              <Tab eventKey={1} title={<TabTitleText>Actions</TabTitleText>}>
                <div className="pf-v5-u-p-md">
                  <Title headingLevel="h2" size="lg" className="pf-v5-u-mb-md">
                    Quick Actions
                  </Title>
                  <p className="pf-v5-u-mb-md pf-v5-u-font-size-sm pf-v5-u-color-200">
                    Demonstrates Button icon prop migration
                  </p>
                  <IconButtons
                    onAdd={handleInteraction}
                    onEdit={handleInteraction}
                    onDelete={handleInteraction}
                  />
                </div>
              </Tab>
              <Tab eventKey={2} title={<TabTitleText>Filters</TabTitleText>}>
                <div className="pf-v5-u-p-md">
                  <Title headingLevel="h2" size="lg" className="pf-v5-u-mb-md">
                    Search Results
                  </Title>
                  <p className="pf-v5-u-mb-md pf-v5-u-font-size-sm pf-v5-u-color-200">
                    Demonstrates EmptyState structural changes
                  </p>
                  <EmptyStateExample onAction={handleInteraction} />
                </div>
              </Tab>
            </Tabs>
          </CardBody>
        </Card>

        <div
          className="pf-v5-u-p-md pf-v5-u-background-color-200"
          style={{ borderRadius: '4px', border: '1px solid #d2d2d2' }}
        >
          <strong>Migration Notes:</strong>
          <ul className="pf-v5-u-mt-sm pf-v5-u-font-size-sm">
            <li>MenuToggle: Icon as child → icon prop</li>
            <li>Button: Icon component child → icon prop</li>
            <li>EmptyState: Structural component consolidation</li>
            <li>More complex AI reasoning required</li>
          </ul>
        </div>
      </PageSection>
    </>
  );
};
