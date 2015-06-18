# File: model.rb

require 'pp'
require 'yaml'  # Rely on YAML for object persistence


# Module used as a namespace
module Sample
  # Assumption: the store has one examplar only of a video title
  Video = Struct.new(
    :title, # Title of the video (as an identifier)
    :state  # Current state of the video
  )

  # A member of the video store, i.e. a person that is allowed
  # to rent a video from the store.
  Member = Struct.new(
    :name # As an identifier
  )

  # Association object between a Video and a Member.
  # In our sample model, no rental history is performed
  Rental = Struct.new(
    :video, # Use the title of the rented video as key
    :member   # Use the name of the Member as key
  )

  # The identification of a store rental employee
  # that is authorized to use the rental software.
  User = Struct.new(
    :credential # user credential
  )

  # Simplistic domain model of a video rental store.
  class RentalStore
    MyDir = File.dirname(__FILE__) + '/'
    CatalogueFile = 'catalogue.yml'
    MembersFile = 'members.yml'
    RentalsFile = 'rentals.yml'
    UsersFile = 'users.yml'


    # The list of all videos owned by the store.
    attr_reader(:catalogue)

    # The list of all Members
    attr_reader(:members)

    # The list of all open-standing rentals
    attr_reader(:rentals)

    # The list of application user (credentials)
    attr_reader(:users)

    def initialize()
      init_catalogue
      init_members
      init_rentals
      init_users
    end


    # Clear the catalogue (= make it empty).
    def zap_catalogue!()
      catalogue.clear
      save_catalogue
      zap_rentals!
    end

    def zap_members!()
      members.clear
      save_members
      zap_rentals!
    end

    def zap_users!()
      users.clear
      save_users
    end

    # Search a Video object having the given title
    def search_video(aTitle)
      result = catalogue.find { |video| video.title.strip == aTitle.strip }
      if result.nil?
        msg = "Video with title '#{aTitle}' isn't in the catalogue."
        $stderr.puts msg
      end

      return result
    end

    def remove_video(aVideo)
      catalogue.delete(aVideo)
      save_catalogue
    end

    # Add a new video to the catalogue
    def add_video(aTitle)
      # Simplification: no check for title collision
      catalogue << Video.new(aTitle, :available)
      save_catalogue
    end

    def search_member(aName)
      mb = members.find { |person| person.name.strip == aName.strip }
      puts "No member with name #{aName}." if mb.nil?

      return mb
    end

    def add_member(aName)
      # Simplification: no check for name collision
      members << Member.new(aName)
      save_members
    end

    def search_user(aCredential)
      users.find { |user| user.credential.strip == aCredential.strip }
    end

    def add_user(aCredential)
      # Simplification: no check for credential collision
      users << User.new(aCredential)
      save_users
    end

    def search_rental(aTitle)
      rentals.find { |r| r.video.strip == aTitle.strip }
    end

    def add_rental(aVideo, aMember)
      rentals << Rental.new(aVideo.title, aMember.name)
      aVideo.state = :rented
      save_rentals
    end

    def close_rental(aRental)
      returned_video = search_video(aRental.video)
      returned_video.state = :available
      rentals.delete(aRental)
      save_rentals
    end

    private

    def init_catalogue()
      filepath = MyDir + CatalogueFile
      if File.exist?(filepath)
        @catalogue = YAML.load_file(filepath)
      else
        @catalogue = []
      end
    end

    def init_members()
      filepath = MyDir + MembersFile
      if File.exist?(filepath)
        @members = YAML.load_file(filepath)
      else
        @members = []
      end
    end

    def init_users()
      filepath = MyDir + UsersFile
      if File.exist?(filepath)
        @users = YAML.load_file(filepath)
      else
        @users = []
      end
    end

    def init_rentals()
      filepath = MyDir + RentalsFile
      if File.exist?(filepath)
        @rentals = YAML.load_file(filepath)
      else
        @rentals = []
      end
    end

    def zap_rentals!()
      rentals.clear
      save_rentals
    end

    def save_catalogue()
      filepath = MyDir + CatalogueFile
      File.open(filepath, 'w') { |f| YAML.dump(catalogue, f) }
    end

    def save_members()
      filepath = MyDir + MembersFile
      File.open(filepath, 'w') { |f| YAML.dump(members, f) }
    end

    def save_users()
      filepath = MyDir + UsersFile
      File.open(filepath, 'w') { |f| YAML.dump(users, f) }
    end

    def save_rentals()
      filepath = MyDir + RentalsFile
      File.open(filepath, 'w') { |f| YAML.dump(rentals, f) }
    end
  end # class
end # module

# End of file
