import React, { useState } from 'react';
import { Label } from '@patternfly/react-core';

interface StatusBadgeProps {
  status: 'active' | 'inactive' | 'pending';
  isDisabled?: boolean;
}

/**
 * WORKSHOP TIER 1: Simple Migration
 * 
 * Migration completed:
 * - Chip → Label ✅
 * - isDisabled prop → kept for compatibility (Label supports it) ✅
 * - isReadOnly removed (Label is compact by default) ✅
 * - Removed unused getColor function ✅
 * 
 * Date: 2026-01-19
 */
export const StatusBadge: React.FC<StatusBadgeProps> = ({
  status,
  isDisabled = false
}) => {
  const [clickCount, setClickCount] = useState(0);

  const handleClick = () => {
    if (!isDisabled) {
      setClickCount(prev => prev + 1);
    }
  };

  const getColorVariant = () => {
    switch (status) {
      case 'active': return 'green';
      case 'inactive': return 'red';
      case 'pending': return 'orange';
      default: return 'grey';
    }
  };

  return (
    <div style={{ display: 'inline-flex', alignItems: 'center', gap: '8px' }}>
      <Label
        color={getColorVariant()}
        isCompact
        onClick={handleClick}
        style={{ cursor: isDisabled ? 'not-allowed' : 'pointer', opacity: isDisabled ? 0.6 : 1 }}
      >
        {status}
      </Label>
      {clickCount > 0 && (
        <span data-testid="click-count" style={{ fontSize: '12px', color: '#666' }}>
          Clicked {clickCount}x
        </span>
      )}
    </div>
  );
};
