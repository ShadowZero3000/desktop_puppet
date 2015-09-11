File { source_permissions => ignore }
Package{
  provider => chocolatey,
  ensure => 'present',
}
$username=hiera('username')
$appdata="C:/Users/${username}/AppData"
$packages=hiera('packages')

package{$packages:}

if 'keypass' in $packages {
  package{'keepass-keepasshttp':
    require => Package['keepass'],
  }
}

if 'sublimetext3.app' in $packages {
  #Sublime Text 3 customization
  file{"${appdata}/Roaming/Sublime Text 3/Local/License.sublime_license":
    content=>hiera('sublime_key'),
    require => Package['sublimetext3.app']
  }
  file{"${appdata}/Roaming/Sublime Text 3/Packages/User/Preferences.sublime-settings":
    content => hiera('sublime-preferences')
    #source => 'puppet:///modules/puppet_home/sublimetext3/User/Preferences.sublime-settings',
  }
}

if 'teamspeak' in $packages {
  # Teamspeak customization
  file{"${appdata}/Roaming/TS3Client":
    ensure => directory,
  }
  file{"${appdata}/Roaming/TS3Client/ts3clientui_qt.secrets.conf":
    ensure => present,
    replace => false,
    content => hiera('ts3client_tq.secrets.conf'),
    before => Package['teamspeak'],
  }
  file{"${appdata}/Roaming/TS3Client/resolved.dat":
    ensure => present,
    replace => false,
    content => hiera('ts3_resolved.dat',''),
    before => Package['teamspeak'],
  }
}