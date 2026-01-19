import React from 'react';
import {
  Content,
  Card,
  CardBody
} from '@patternfly/react-core';

interface UserProfileProps {
  name: string;
  role: string;
  email: string;
}

/**
 * WORKSHOP TIER 1: Simple Migration
 * 
 * Migration completed:
 * - Text → Content ✅
 * - TextContent → Content (wrapper) ✅
 * - No prop changes needed ✅
 * 
 * Date: 2026-01-19
 */
export const UserProfile: React.FC<UserProfileProps> = ({ name, role, email }) => {
  return (
    <Card>
      <CardBody>
        <Content>
          <Content component="h2">{name}</Content>
          <Content component="p">{role}</Content>
          <Content component="small">{email}</Content>
        </Content>
      </CardBody>
    </Card>
  );
};
