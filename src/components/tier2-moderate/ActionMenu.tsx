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
          >
            <EllipsisVIcon />
          </MenuToggle>
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
