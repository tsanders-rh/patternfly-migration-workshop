import React, { useState } from 'react';
import {
  EmptyState,
  EmptyStateActions,
  EmptyStateBody,
  EmptyStateFooter,
  Button
} from '@patternfly/react-core';
import { SearchIcon, CheckCircleIcon } from '@patternfly/react-icons';

interface EmptyStateExampleProps {
  onAction: () => void;
}

/**
 * WORKSHOP TIER 2: Moderate Complexity Migration
 * 
 * Migration completed:
 * - EmptyStateIcon removed (icon passed directly) ✅
 * - EmptyStateHeader removed (use EmptyState props) ✅
 * - Actions moved to EmptyStateFooter/EmptyStateActions ✅
 * 
 * v6 EmptyState API changes:
 * - titleText, headingLevel, icon as direct props
 * - Actions wrapped in EmptyStateFooter + EmptyStateActions
 * 
 * Date: 2026-01-19
 */
export const EmptyStateExample: React.FC<EmptyStateExampleProps> = ({ onAction }) => {
  const [filtersCleared, setFiltersCleared] = useState(false);

  const handleClearFilters = () => {
    setFiltersCleared(true);
    onAction();

    // Reset after 2 seconds to allow re-testing
    setTimeout(() => setFiltersCleared(false), 2000);
  };

  if (filtersCleared) {
    return (
      <EmptyState
        titleText="Filters cleared!"
        headingLevel="h2"
        icon={CheckCircleIcon}
      >
        <EmptyStateBody data-testid="success-message">
          Try searching again with updated criteria.
        </EmptyStateBody>
      </EmptyState>
    );
  }

  return (
    <EmptyState
      titleText="No results found"
      headingLevel="h2"
      icon={SearchIcon}
    >
      <EmptyStateBody>
        Try adjusting your search criteria or filters.
      </EmptyStateBody>
      <EmptyStateFooter>
        <EmptyStateActions>
          <Button variant="primary" onClick={handleClearFilters}>
            Clear filters
          </Button>
        </EmptyStateActions>
      </EmptyStateFooter>
    </EmptyState>
  );
};
