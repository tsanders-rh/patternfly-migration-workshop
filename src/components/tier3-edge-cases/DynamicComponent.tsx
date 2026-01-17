import React, { useState } from 'react';
// This import triggers a violation, but AI can't safely fix the dynamic usage below
import { Text } from '@patternfly/react-core';

interface DynamicComponentProps {
  componentType: 'alert' | 'card' | 'banner';
  status: 'info' | 'warning' | 'error';
}

/**
 * This component uses dynamic/computed values that AI cannot confidently modify.
 *
 * **IMPORTANT FOR WORKSHOP:**
 * - Triggers Text → Content violation (static import)
 * - Triggers pf-v5-c → pf-v6-c violation (CSS class)
 * - BUT: Values are computed from runtime props
 * - AI can't safely determine all possible values
 * - **MANUAL REVIEW REQUIRED** - need to trace prop usage
 *
 * This demonstrates AI limitations with dynamic/computed patterns.
 */
export const DynamicComponent: React.FC<DynamicComponentProps> = ({
  componentType,
  status
}) => {
  // Dynamic CSS class construction - AI can't safely refactor template literals
  const baseClass = `pf-v5-c-${componentType}`;
  const statusClass = `pf-v5-c-${componentType}--${status}`;

  // Dynamic content selection
  const [showDetails, setShowDetails] = useState(false);

  // AI sees Text import violation but can't trace where it's used conditionally
  const renderContent = () => {
    if (showDetails) {
      return (
        <Text component="p">
          Detailed information for {componentType} with {status} status.
        </Text>
      );
    }
    return <Text component="small">Summary view</Text>;
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
 * Example usage showing why dynamic patterns are risky for AI
 */
export const DynamicComponentExample: React.FC = () => {
  // These values could come from API, user input, database, etc.
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
