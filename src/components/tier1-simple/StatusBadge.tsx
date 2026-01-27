import React, { useState } from 'react';
import { Chip } from '@patternfly/react-core';

interface StatusBadgeProps {
  status: 'active' | 'inactive' | 'pending';
  isDisabled?: boolean;
}

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

  return (
    <div style={{ display: 'inline-flex', alignItems: 'center', gap: '8px' }}>
      <Chip
        isReadOnly
        onClick={handleClick}
      >
        {status}
      </Chip>
      {clickCount > 0 && (
        <span data-testid="click-count" style={{ fontSize: '12px', color: '#666' }}>
          Clicked {clickCount}x
        </span>
      )}
    </div>
  );
};
