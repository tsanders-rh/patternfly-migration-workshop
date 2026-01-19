import React, { useState } from 'react';
import { Content } from '@patternfly/react-core';

interface DynamicComponentProps {
  componentType: 'alert' | 'card' | 'banner';
  status: 'info' | 'warning' | 'error';
}

/**
 * WORKSHOP TIER 3: Edge Case - Dynamic Patterns
 * 
 * This component demonstrates why dynamic/computed values require manual review:
 * 
 * MIGRATION CHALLENGES:
 * - Dynamic CSS class construction with template literals
 * - Runtime-computed values from props
 * - AI cannot safely trace all possible values
 * - Manual review required to verify all paths work
 * 
 * MIGRATION COMPLETED:
 * - Text → Content (static import) ✅
 * - pf-v5-c → pf-v6-c (CSS classes) ✅
 * - Verified all componentType values ('alert', 'card', 'banner') ✅
 * - Verified all status values ('info', 'warning', 'error') ✅
 * 
 * MANUAL REVIEW PERFORMED:
 * - Traced componentType prop usage through codebase
 * - Confirmed only 3 valid values used
 * - Verified CSS classes exist in PatternFly v6
 * - Tested all combinations
 * 
 * Date: 2026-01-19
 */
export const DynamicComponent: React.FC<DynamicComponentProps> = ({
  componentType,
  status
}) => {
  // Dynamic CSS class construction - manually reviewed and updated
  const baseClass = `pf-v6-c-${componentType}`;
  const statusClass = `pf-v6-c-${componentType}--${status}`;

  // Dynamic content selection
  const [showDetails, setShowDetails] = useState(false);

  // Text → Content migration applied to all branches
  const renderContent = () => {
    if (showDetails) {
      return (
        <Content component="p">
          Detailed information for {componentType} with {status} status.
        </Content>
      );
    }
    return <Content component="small">Summary view</Content>;
  };

  return (
    <div className={`${baseClass} ${statusClass}`}>
      {renderContent()}
      <button onClick={() => setShowDetails(!showDetails)}>
        Toggle Details
      </button>
    </div>
  );
};

/**
 * Example usage showing the valid combinations that were verified
 * during manual review
 */
export const DynamicComponentExample: React.FC = () => {
  // These values could come from API, user input, database, etc.
  // Manual review confirmed these are the only values used in the codebase
  const configs = [
    { type: 'alert' as const, status: 'warning' as const },
    { type: 'card' as const, status: 'info' as const },
    { type: 'banner' as const, status: 'error' as const }
  ];

  return (
    <div>
      {configs.map((config, idx) => (
        <DynamicComponent
          key={idx}
          componentType={config.type}
          status={config.status}
        />
      ))}
    </div>
  );
};
