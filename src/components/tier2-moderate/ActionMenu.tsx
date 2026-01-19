import React, { useState } from 'react';
import {
  Dropdown,
  DropdownItem,
  DropdownList,
  MenuToggle
} from '@patternfly/react-core';
import { EllipsisVIcon } from '@patternfly/react-icons';

interface ActionMenuProps {
  onEdit: () => void;
  onDelete: () => void;
  isDisabled?: boolean;
}

/**
 * WORKSHOP TIER 2: Moderate Complexity Migration
 * 
 * Migration completed:
 * - Removed DropdownToggle import (deprecated in v6) ✅
 * - MenuToggle icon: child → icon prop ✅
 * - isDisabled → isDisabled (stays the same) ✅
 * 
 * Date: 2026-01-19
 */
export const ActionMenu: React.FC<ActionMenuProps> = ({
  onEdit,
  onDelete,
  isDisabled = false
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [lastAction, setLastAction] = useState<string>('');

  const handleEdit = () => {
    setLastAction('Edit');
    onEdit();
    setIsOpen(false);
  };

  const handleDelete = () => {
    setLastAction('Delete');
    onDelete();
    setIsOpen(false);
  };

  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
      <Dropdown
        isOpen={isOpen}
        onOpenChange={setIsOpen}
        toggle={(toggleRef) => (
          <MenuToggle
            ref={toggleRef}
            variant="plain"
            isDisabled={isDisabled}
            onClick={() => setIsOpen(!isOpen)}
            icon={<EllipsisVIcon />}
          />
        )}
      >
        <DropdownList>
          <DropdownItem onClick={handleEdit}>Edit</DropdownItem>
          <DropdownItem onClick={handleDelete}>Delete</DropdownItem>
        </DropdownList>
      </Dropdown>
      {lastAction && (
        <span data-testid="last-action" style={{ fontSize: '14px', color: '#666' }}>
          Last action: {lastAction}
        </span>
      )}
    </div>
  );
};
