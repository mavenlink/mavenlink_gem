![](http://project-management.com/wp-content/uploads/2013/09/Mavenlink-Logo.jpg)

## Mavenlink API
[![Build Status](https://travis-ci.org/einzige/mavenlink.svg?branch=master&update_cache=true)](https://travis-ci.org/einzige/mavenlink)
[![Dependency Status](https://gemnasium.com/einzige/mavenlink.svg)](https://gemnasium.com/einzige/mavenlink)

### Usage

#### Setting up access token

In order to be able to perform any requests you should set `outh_token` obtained by your Mavenlink Account.

```ruby
Mavenlink.oauth_token = "your_token"
```

If you are using __Rails__, put this line into `config/initializers/mavenlink.rb`

#### Creating new records
```ruby
workspace = Mavenlink::Workspace.create(title: 'new workspace', creator_role: 'buyer')

# Exactly the same:
workspace = Mavenlink::Workspace.new(title: 'New workspace', creator_role: 'maven')
workspace.save # will call "create" and store record in Mavenlink db
workspace.new_record? # -> false
```

#### Fetching records
```ruby
Mavenlink::Workspace.find(9)
# Same as:
Mavenlink.client.workspaces.find(9)
```

#### Updating records
```ruby
workspace = Mavenlink::Workspace.find(1)

workspace.title = 'new title' # writes attribute
workspace.save                # returns true if record has been saved
workspace.save!               # will raise exception if record is invalid
```

#### Destroying records
```ruby
post = Mavenlink::Post.find(1)
post.destroy
```

#### Associations
```ruby
workspace.participants        # will return participants as an array of Mavenlink::User instances, will do http API call if association is not "included"
workspace.participants        # now it returns cached value
workspace.participants.first  # returns Mavenlink::User record
workspace.participants(true)  # flushes association cache
workspace.reload              # reloads from remote host

participant = workspace.participants.first
participant.full_name = 'new name'
participant.save # performs "update" query, full_name will be changed
```

In order to include association use `include` as follows:
```ruby
Mavenlink::Workspace.scoped.include(:participants).search('My Workspace')

Mavenlink::Workspace.scoped.search('My Workspace').order(:updated_at, :desc).each do |workspace|
  if workspace.valid?
    workspace.destroy
  end
end
```

#### Search

```ruby
Mavenlink::Workspace.scoped.search('Something')
Mavenlink.client.workspaces.search('Something')
```

#### Filtering

```ruby
Mavenlink::Workspace.scoped.filter(include_archived: true).all
Mavenlink.client.workspaces.filter(include_archived: true).all
```

#### Pagination

```ruby
Mavenlink::Workspace.scoped.page(2).per_page(3)
Mavenlink.client.workspaces.page(2).per_page(3)
```

```ruby
Mavenlink::Workspace.scoped.limit(2).offset(3)
Mavenlink.client.workspaces.limit(2).offset(3)
```

You'll never receive full results set if number of records in requested collection is greater than 200.
Pagination allows you to go through entire collection.

```ruby
Mavenlink::Workspace.scoped.each_page do |page|
  page.each do |workspace|
    p workspace.inspect
  end
end
```

Use your paginator as Enumerable:
```ruby
Mavenlink::Workspace.scoped.each_page(200).to_a     # 200 records per page
Mavenlink::Workspace.scoped.each_page.to_a.flatten  # Returns full collection
Mavenlink::Workspace.scoped.each_page(2).each_with_index { |page, i| puts i }
```

#### Client side validation
By default client side validation is disabled, you can enable it by setting `perform_validations` to `true`

```ruby
Mavenlink.perform_validations = true
```

Now any record will be validated before you perform any request to change its attributes.

```ruby
workspace = Workspace.new(title: 'My workspace')
workspace.save # -> returns false
workspace.errors.full_messages # -> ["Creator role is not included in the list"]
```

#### Invite new user

```ruby
Mavenlink::Workspace.find(7).invite(email: 'john@doe.com', full_name: 'John Doe', invitee_role: 'maven')
```

#### Custom requests

```ruby
client.get('/custom_path', {param: 'anything'})
client.post('/custom_path', {param: 'anything'})
client.put('/custom_path', {param: 'anything'})
client.delete('/custom_path', {param: 'anything'})
```

### More examples

```ruby
client = Mavenlink::Client.new(oauth_token: '...')
client.workspaces.each { |workspace| do_something(workspace) }

client.workspaces.include('participants')
client.workspaces.include('participants, creator')
client.workspaces.include('participants', 'creator')
client.workspaces.include(['participants', 'creator'])
client.workspaces.include(:participants, :creator)

client.workspaces.find(2) # Returns one Mavenlink::Workspace

client.workspaces      # Returns sort of "active record relation collection"
client.workspaces.to_a # Same as calling #to_a on activerecord scope
client.workspaces.all  # Same as calling #to_a on activerecord scope

client.workspaces.page(3).per_page(20)
client.workspaces.limit(100).offset(10)
client.workspaces.filter(by_something: true)
client.workspaces.search('some text')

client.workspaces.order(:updated_at)
client.workspaces.order('updated_at:desc')
client.workspaces.order(:updated_at, :desc)
client.workspaces.order(:updated_at, 'ASC')
client.workspaces.order(:updated_at, true)

client.workspaces.create(title: 'New workspace')
client.workspaces.only(8).update(title: 'new title')
client.workspaces.only(8).delete

# ...
```

### Running Developer Console

Run in your project directory `bundle exec mavenlink-console` or `TOKEN=your_oauth_token bundle exec mavenlink-console`.
Or just `mavenlink-console` (depending on your current setup).

## Contributing

1. Fork
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request (`git pull-request`)

## License

Created by Mavenlink, Inc. and available under the MIT License.
