import LookupManagement from './LookupManagement';

export default function CategoryList() {
  return (
    <LookupManagement
      type="categories"
      title="Categories"
      description="Manage ingredient categories like produce, meat, dairy, etc."
    />
  );
}
