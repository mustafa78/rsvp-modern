import LookupManagement from './LookupManagement';

export default function StorageLocationList() {
  return (
    <LookupManagement
      type="storage-locations"
      title="Storage Locations"
      description="Manage storage locations like refrigerator, freezer, pantry, etc."
    />
  );
}
