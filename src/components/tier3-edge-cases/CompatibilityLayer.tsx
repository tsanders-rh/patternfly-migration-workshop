import React from 'react';
// Intentionally importing both for gradual migration support
import { Text } from '@patternfly/react-core';

interface CompatibilityLayerProps {
  children: string;
}

/**
 * This is a compatibility wrapper to support gradual migration.
 * DO NOT auto-fix this component - it intentionally uses both old and new APIs.
 */
export const CompatibilityLayer: React.FC<CompatibilityLayerProps> = ({
  children
}) => {
  // In real implementation, would conditionally use Content or Text
  // For this demo, just use Text to trigger the violation
  // Note: useV6 parameter removed as it's not currently used
  return <Text component="p">{children}</Text>;
};
