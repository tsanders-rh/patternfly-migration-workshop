import { render, screen } from '@testing-library/react';
import { UserProfile } from '../components/tier1-simple/UserProfile';

describe('UserProfile', () => {
  it('renders user information correctly', () => {
    render(
      <UserProfile
        name="Jane Doe"
        role="Software Engineer"
        email="jane.doe@example.com"
      />
    );

    expect(screen.getByText('Jane Doe')).toBeInTheDocument();
    expect(screen.getByText('Software Engineer')).toBeInTheDocument();
    expect(screen.getByText('jane.doe@example.com')).toBeInTheDocument();
  });

  it('renders with different user data', () => {
    render(
      <UserProfile
        name="John Smith"
        role="Developer"
        email="john@example.com"
      />
    );

    expect(screen.getByText('John Smith')).toBeInTheDocument();
    expect(screen.getByText('Developer')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  it('matches snapshot', () => {
    const { container } = render(
      <UserProfile
        name="Snapshot Test"
        role="QA Engineer"
        email="qa@example.com"
      />
    );

    expect(container).toMatchSnapshot();
  });
});
