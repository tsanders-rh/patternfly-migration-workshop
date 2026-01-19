import React, { useState } from 'react';
import { Button } from '@patternfly/react-core';
import './PageHeader.css';

interface PageHeaderProps {
  title: string;
  subtitle?: string;
}

/**
 * WORKSHOP TIER 1: CSS Class Migration
 * 
 * Migration completed:
 * - pf-v5-c-* → pf-v6-c-* ✅
 * - pf-v5-u-* → pf-v6-u-* ✅
 * - CSS tokens in PageHeader.css updated ✅
 * 
 * Date: 2026-01-19
 */
export const PageHeader: React.FC<PageHeaderProps> = ({ title, subtitle }) => {
  const [showSubtitle, setShowSubtitle] = useState(true);

  return (
    <div className="pf-v6-c-page__main-section page-header">
      <h1 className="pf-v6-c-title pf-m-2xl">{title}</h1>
      {subtitle && showSubtitle && (
        <p className="pf-v6-u-color-200">{subtitle}</p>
      )}
      {subtitle && (
        <Button
          variant="link"
          onClick={() => setShowSubtitle(!showSubtitle)}
          data-testid="toggle-subtitle"
        >
          {showSubtitle ? 'Hide' : 'Show'} subtitle
        </Button>
      )}
    </div>
  );
};
