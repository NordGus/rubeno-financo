# Patch Notes

This is a patch for ActiveRecord, based on the work done in the gem [store_base_sti_class](https://github.com/appfolio/store_base_sti_class).
The whole idea for taking this code into financo is for making it easier to maintain and adapt seeing that the gem can
take a while to be updated. Because financo makes heavy use of STI (Single Table Inheritance) in its data model and
expects that polymorphic associations store the specific class of the associated record, this patch is needed.
