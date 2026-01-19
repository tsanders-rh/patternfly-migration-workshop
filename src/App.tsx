import React, { useState } from 'react';
import {
  Page,
  PageSidebar,
  PageSidebarBody,
  Masthead,
  MastheadToggle,
  MastheadMain,
  MastheadBrand,
  MastheadContent,
  Toolbar,
  ToolbarContent,
  ToolbarItem,
  Nav,
  NavList,
  NavItem,
  NavExpandable,
  Title,
  Flex,
  FlexItem,
  Button,
  ButtonVariant
} from '@patternfly/react-core';
import { BarsIcon } from '@patternfly/react-icons';
import {
  ProjectsPage,
  WorkloadsPage,
  StoragePage
} from './pages';
import './styles/components.css';
import './styles/tokens.css';

type PageType = 'projects' | 'workloads' | 'storage';

export const App: React.FC = () => {
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const [activePage, setActivePage] = useState<PageType>('projects');
  const [activeWorkloadsItem, setActiveWorkloadsItem] = useState('pods');

  const handlePageSelect = (page: PageType) => {
    setActivePage(page);
  };

  const headerToolbar = (
    <Toolbar isFullHeight isStatic>
      <ToolbarContent>
        <ToolbarItem>
          <div style={{ color: '#fff', padding: '0 16px', marginLeft: 'auto' }}>
            Workshop Demo
          </div>
        </ToolbarItem>
      </ToolbarContent>
    </Toolbar>
  );

  const header = (
    <Masthead>
      <MastheadToggle>
        <Button
          variant={ButtonVariant.plain}
          onClick={() => setIsSidebarOpen(!isSidebarOpen)}
          icon={<BarsIcon />}
          aria-label="Toggle navigation"
          style={{ color: '#fff' }}
        />
      </MastheadToggle>
      <MastheadMain>
        <MastheadBrand>
          <Flex alignItems={{ default: 'alignItemsCenter' }}>
            <FlexItem>
              <div style={{
                width: '32px',
                height: '32px',
                backgroundColor: '#ee0000',
                borderRadius: '4px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontWeight: 'bold',
                color: '#fff',
                marginRight: '12px'
              }}>
                OS
              </div>
            </FlexItem>
            <FlexItem>
              <Title headingLevel="h1" size="lg" style={{ color: '#fff' }}>
                Workshop Console
              </Title>
            </FlexItem>
          </Flex>
        </MastheadBrand>
      </MastheadMain>
      <MastheadContent>{headerToolbar}</MastheadContent>
    </Masthead>
  );

  const navigation = (
    <Nav aria-label="Console navigation">
      <NavList>
        <NavItem
          itemId="home"
          isActive={activePage === 'projects'}
          onClick={() => handlePageSelect('projects')}
        >
          Projects
        </NavItem>
        <NavExpandable
          title="Workloads"
          groupId="workloads"
          isActive={activePage === 'workloads'}
          isExpanded={activePage === 'workloads'}
        >
          <NavItem
            itemId="pods"
            groupId="workloads"
            isActive={activePage === 'workloads' && activeWorkloadsItem === 'pods'}
            onClick={() => {
              handlePageSelect('workloads');
              setActiveWorkloadsItem('pods');
            }}
          >
            Pods
          </NavItem>
          <NavItem
            itemId="deployments"
            groupId="workloads"
            isActive={activePage === 'workloads' && activeWorkloadsItem === 'deployments'}
            onClick={() => {
              handlePageSelect('workloads');
              setActiveWorkloadsItem('deployments');
            }}
          >
            Deployments
          </NavItem>
        </NavExpandable>
        <NavItem
          itemId="storage"
          isActive={activePage === 'storage'}
          onClick={() => handlePageSelect('storage')}
        >
          Storage
        </NavItem>
      </NavList>
    </Nav>
  );

  const sidebar = isSidebarOpen ? (
    <PageSidebar>
      <PageSidebarBody>{navigation}</PageSidebarBody>
    </PageSidebar>
  ) : null;

  const renderPage = () => {
    switch (activePage) {
      case 'projects':
        return <ProjectsPage />;
      case 'workloads':
        return <WorkloadsPage activeItem={activeWorkloadsItem} />;
      case 'storage':
        return <StoragePage />;
      default:
        return <ProjectsPage />;
    }
  };

  return (
    <Page masthead={header} sidebar={sidebar}>
      {renderPage()}
    </Page>
  );
};
