import React, { useState } from 'react';
import { Button } from '@patternfly/react-core';
import {
  PlusCircleIcon,
  EditIcon,
  TrashIcon
} from '@patternfly/react-icons';

interface IconButtonsProps {
  onAdd: () => void;
  onEdit: () => void;
  onDelete: () => void;
}

/**
 * WORKSHOP TIER 2: Moderate Complexity Migration
 * 
 * Migration completed:
 * - Button: Icon as child → icon prop ✅
 * - All three buttons updated ✅
 * - isDanger prop stays the same ✅
 * 
 * Date: 2026-01-19
 */
export const IconButtons: React.FC<IconButtonsProps> = ({
  onAdd,
  onEdit,
  onDelete
}) => {
  const [actionLog, setActionLog] = useState<string[]>([]);

  const handleAction = (action: string, callback: () => void) => {
    setActionLog(prev => [...prev, action].slice(-3)); // Keep last 3 actions
    callback();
  };

  return (
    <div>
      <div style={{ display: 'flex', gap: '8px', marginBottom: '12px' }}>
        <Button
          variant="plain"
          onClick={() => handleAction('Added item', onAdd)}
          aria-label="Add"
          icon={<PlusCircleIcon />}
        />
        <Button
          variant="plain"
          onClick={() => handleAction('Edited item', onEdit)}
          aria-label="Edit"
          icon={<EditIcon />}
        />
        <Button
          variant="plain"
          onClick={() => handleAction('Deleted item', onDelete)}
          isDanger
          aria-label="Delete"
          icon={<TrashIcon />}
        />
      </div>

      {actionLog.length > 0 && (
        <div data-testid="action-log" style={{ fontSize: '12px', color: '#666' }}>
          <strong>Recent actions:</strong>
          <ul style={{ margin: '4px 0', paddingLeft: '20px' }}>
            {actionLog.map((action, idx) => (
              <li key={idx}>{action}</li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};
