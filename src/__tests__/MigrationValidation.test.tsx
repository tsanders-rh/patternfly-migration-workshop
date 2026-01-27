import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { UserProfile } from '../components/tier1-simple/UserProfile';
import { StatusBadge } from '../components/tier1-simple/StatusBadge';
import { PageHeader } from '../components/tier1-simple/PageHeader';
import { ActionMenu } from '../components/tier2-moderate/ActionMenu';
import { IconButtons } from '../components/tier2-moderate/IconButtons';
import { EmptyStateExample } from '../components/tier2-moderate/EmptyStateExample';

describe('Migration Validation Suite', () => {
  describe('Tier 1: Simple Components - Interactive Validation', () => {
    it('UserProfile renders correctly', () => {
      render(<UserProfile name="Test User" role="Engineer" email="test@test.com" />);

      expect(screen.getByText('Test User')).toBeInTheDocument();
      expect(screen.getByText('Engineer')).toBeInTheDocument();
      expect(screen.getByText('test@test.com')).toBeInTheDocument();
    });

    it('StatusBadge renders with different statuses', () => {
      const { rerender } = render(<StatusBadge status="active" />);
      expect(screen.getByText('active')).toBeInTheDocument();

      rerender(<StatusBadge status="pending" />);
      expect(screen.getByText('pending')).toBeInTheDocument();

      rerender(<StatusBadge status="inactive" />);
      expect(screen.getByText('inactive')).toBeInTheDocument();
    });

    it('PageHeader renders title and subtitle', () => {
      render(<PageHeader title="Test Title" subtitle="Test Subtitle" />);

      expect(screen.getByText('Test Title')).toBeInTheDocument();
      expect(screen.getByText('Test Subtitle')).toBeInTheDocument();
    });

    it('PageHeader toggles subtitle', () => {
      render(<PageHeader title="Test" subtitle="Subtitle text" />);

      expect(screen.getByText('Subtitle text')).toBeInTheDocument();

      const toggleButton = screen.getByTestId('toggle-subtitle');
      fireEvent.click(toggleButton);

      expect(screen.queryByText('Subtitle text')).not.toBeInTheDocument();
      expect(toggleButton).toHaveTextContent('Show subtitle');
    });
  });

  describe('Tier 2: Interactive Components - Event Validation', () => {
    it('ActionMenu renders with handlers', () => {
      const onEdit = jest.fn();
      const onDelete = jest.fn();

      const { container } = render(<ActionMenu onEdit={onEdit} onDelete={onDelete} />);

      // Component renders without crashing
      expect(container.firstChild).toBeInTheDocument();
    });

    it('IconButtons renders all action buttons', () => {
      const handlers = {
        onAdd: jest.fn(),
        onEdit: jest.fn(),
        onDelete: jest.fn(),
      };

      render(<IconButtons {...handlers} />);

      // Should have three buttons
      expect(screen.getByLabelText('Add')).toBeInTheDocument();
      expect(screen.getByLabelText('Edit')).toBeInTheDocument();
      expect(screen.getByLabelText('Delete')).toBeInTheDocument();

      // Should not show log initially
      expect(screen.queryByTestId('action-log')).not.toBeInTheDocument();
    });

    it('IconButtons tracks actions when clicked', () => {
      const handlers = {
        onAdd: jest.fn(),
        onEdit: jest.fn(),
        onDelete: jest.fn(),
      };

      render(<IconButtons {...handlers} />);

      // Click Add button
      const addButton = screen.getByLabelText('Add');
      fireEvent.click(addButton);

      expect(handlers.onAdd).toHaveBeenCalled();
      expect(screen.getByTestId('action-log')).toBeInTheDocument();
      expect(screen.getByText('Added item')).toBeInTheDocument();
    });

    it('EmptyStateExample shows success state after clearing filters', async () => {
      const onAction = jest.fn();

      render(<EmptyStateExample onAction={onAction} />);

      // Initially shows empty state
      expect(screen.getByText('No results found')).toBeInTheDocument();

      // Click clear filters
      const clearButton = screen.getByText('Clear filters');
      fireEvent.click(clearButton);

      expect(onAction).toHaveBeenCalled();

      // Should show success state
      expect(screen.getByText('Filters cleared!')).toBeInTheDocument();
      expect(screen.getByTestId('success-message')).toBeInTheDocument();

      // Should reset after 2 seconds
      await waitFor(() => {
        expect(screen.getByText('No results found')).toBeInTheDocument();
      }, { timeout: 2500 });
    });
  });

  describe('Visual Regression', () => {
    it('UserProfile matches snapshot', () => {
      const { container } = render(
        <UserProfile name="Snap Test" role="Tester" email="snap@test.com" />
      );
      expect(container).toMatchSnapshot();
    });

    it('StatusBadge matches snapshot', () => {
      const { container } = render(<StatusBadge status="active" />);
      expect(container).toMatchSnapshot();
    });

    it('EmptyStateExample matches snapshot', () => {
      const { container } = render(
        <EmptyStateExample onAction={() => {}} />
      );
      expect(container).toMatchSnapshot();
    });
  });

  describe('Integration: Component Rendering', () => {
    it('all components render together without errors', () => {
      const { container } = render(
        <div>
          <StatusBadge status="active" />
          <ActionMenu onEdit={() => {}} onDelete={() => {}} />
          <IconButtons onAdd={() => {}} onEdit={() => {}} onDelete={() => {}} />
          <EmptyStateExample onAction={() => {}} />
        </div>
      );

      // Verify all components are present
      expect(screen.getByText('active')).toBeInTheDocument();
      expect(screen.getByLabelText('Add')).toBeInTheDocument();
      expect(screen.getByText('No results found')).toBeInTheDocument();
      expect(container).toBeTruthy();
    });
  });
});
