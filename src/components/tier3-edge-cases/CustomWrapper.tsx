import React from 'react';
import { Content } from '@patternfly/react-core';

// Type for Content component variants (replacing TextVariants)
type ContentVariant = 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6' | 'p' | 'small' | 'blockquote';

interface CustomTextProps {
  children: React.ReactNode;
  emphasis?: boolean;
  variant?: ContentVariant;
}

/**
 * WORKSHOP TIER 3: Edge Case - Custom Wrapper Migration
 * 
 * Migration Strategy:
 * - Internal implementation: Text → Content ✅
 * - External API: CustomText name kept stable ✅
 * - Props: TextVariants → custom type (compatible) ✅
 * 
 * This demonstrates migrating internals while keeping the public API stable.
 * External consumers don't need to change their code.
 * 
 * Migration completed: 2026-01-19
 */
export const CustomText: React.FC<CustomTextProps> = ({
  children,
  emphasis = false,
  variant = 'p'
}) => {
  return (
    <Content
      component={variant}
      className={emphasis ? 'custom-emphasis' : ''}
    >
      {children}
    </Content>
  );
};

/**
 * Example usage - consumers don't need to change their code
 * CustomText API remains stable despite internal migration
 */
export const ConsumerComponent: React.FC = () => {
  return (
    <div>
      <CustomText emphasis>Important text</CustomText>
      <CustomText variant="h3">Heading</CustomText>
    </div>
  );
};
