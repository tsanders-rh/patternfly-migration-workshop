import React from 'react';
// ⚠️ MIGRATION EXCEPTION: This component intentionally uses v5 patterns
// DO NOT MIGRATE - See explanation below
import { Content } from '@patternfly/react-core';

interface CompatibilityLayerProps {
  useV6: boolean;
  children: string;
}

/**
 * ⚠️ WORKSHOP TIER 3: MIGRATION EXCEPTION ⚠️
 * 
 * This component is intentionally kept with its original structure to demonstrate
 * scenarios where gradual migration is needed. In a real codebase, this might be:
 * 
 * 1. A compatibility layer supporting both v5 and v6 temporarily
 * 2. A component with external dependencies not yet migrated
 * 3. A shared library component with version-specific behavior
 * 
 * WORKSHOP NOTE:
 * - Original implementation would conditionally use Text (v5) or Content (v6)
 * - For this workshop, we use Content since Text is removed in v6
 * - The useV6 prop demonstrates the concept of gradual migration
 * - Real implementations would check version at runtime
 * 
 * Migration Status: PARTIALLY MIGRATED (internal only)
 * External API: STABLE - useV6 prop maintained for compatibility
 * Last reviewed: 2026-01-19
 * 
 * DO NOT auto-migrate this file in bulk updates.
 */
export const CompatibilityLayer: React.FC<CompatibilityLayerProps> = ({
  useV6: _useV6,
  children
}) => {
  // In a real implementation, would conditionally use Content or Text based on useV6
  // For this demo, using Content since Text is removed in v6
  // This demonstrates internal migration while keeping external API stable
  
  // Note: useV6 prop maintained for API compatibility but not used internally (renamed with _ prefix)
  return <Content component="p">{children}</Content>;
};
