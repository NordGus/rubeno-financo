# frozen_string_literal: true

##
# FileSystem represents the mounting point for a pseudo file system abstraction over Active Storage so characters can
# store file related to other financo models (mountable) and define their own structure.
#
# Inspired by iPadOS and iOS Files App, where the file tree build by the children of FileSystem abstract the underlying
# implementation of how Active Storage store files and the feature can have a UX similar to said Files App, combined
# with the file versioning that Google Drive have.
#
# The versioning feature for files will increase the storage usage by financo, but I think it is a necessary compromise
# to ensure that the user don't lose data by accident, outside catastrophic hardware or bedrock software failure.
#
# Why use this instead of hard defining a hard attachment structure for the application?
#
# I'm not smart enough to enforce a universal structure for other people's finance documentation system being build
# around. My strong opinion is that everyone who wants to use a personal finances application to take control of their
# finances wants to:
#
#   1. Have a highly opinionated structure to register and track their income and expenses, and have an all encompassing
#      vision of their current financial health. financo provides this with its Account->Transaction->Account graph
#      model used on each archive's ledger.
#   2. Have a way to store documentation related to their different accounts so they have a centralized digital archive
#      of such documentation. Which financo's file system feature give them.
#   3. Structure how they store and navigate their stored files for their own systems of order and classification. Most
#      people know how to use a file explorer system on a digital device, because this kind of UX have been standardized
#      by mainstream OS Graphical User Interface for at least 30 years thanks to the explosion of Windows 95. Again this
#      file system feature provides them such possibility thanks to the file tree structure that the children of this
#      model can by used to build such systems.
class FileSystem < ApplicationRecord
  belongs_to :mountable, polymorphic: true
end
