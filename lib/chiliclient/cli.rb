require 'cri'
require 'uri'
require 'yaml'
require 'highline/import'
require 'chiliclient/chiliclient'

module ChiliClient::CLI

  @cmd = Cri::Command.define do
    name 'chili'
    usage 'chili [options] [command] [options]'
    summary 'to access redmine/chiliproject rest via commandline'
    description <<-DESC
      For --site, --username and --password parameters you can
      also use a yaml config file.

      To do so, just

        cp config.yaml.sample ~/.chili_config.yaml

    DESC

    flag :h, :help, 'show help for this command' do |value, cmd|
      puts @cmd.help
      exit 0
    end

    required :s, :site, 'URL to chili/redmine instance'
    required :u, :username, 'username at given site'
    required :p, :password, 'password at given site'

    opt :v, :version, 'show version information and quit' do
      puts Synrp.version_information
      exit 0
    end
  end

  @cmd.add_command Cri::Command.new_basic_help

  @cmd.define_command do
    name 'issues'
    usage 'issues [options]'

    option :q, :query, 'query id of an issue'

    run do |opts, args|

      ChiliClient::CLI.verify_opts_present(opts, [ :site, :user, :password ])

      unless opts[:query]
        p ChiliClient.get_issues(opts[:site], opts[:user], opts[:password])
      else
        p ChiliClient.get_safed_query(opts[:site], opts[:user], opts[:password], opts[:query])
      end
    end
  end

  def self.run(args)
    @cmd.run(ARGV)
  end

  def self.verify_opts_present(opts, req_opts)
    config_opts = read_config
    req_opts.each do |r_opt|
      unless opts[r_opt]
        if config_opts[r_opt.to_s]
          opts[r_opt] = config_opts[r_opt.to_s]
        elsif r_opt == :password
          opts[:password] = ask("Enter Password: ") {|q| q.echo = "*"}
          puts
        else
          $stderr.puts "--#{r_opt} option is required"
          exit 1
        end
      end
    end
    opts
  end

  def self.read_config
    begin
      return YAML.load_file(File.expand_path("~/.chili_config.yaml"))
    rescue
      begin
        current_dir = File.dirname(File.expand_path(__FILE__))
        return YAML.load_file(current_dir + "/config.yaml")
      rescue
      end
    end
    return {}
  end

end

