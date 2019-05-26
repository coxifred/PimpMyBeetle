notify {'Git configuration':}


exec { "git_editor":
      path      => '/bin:/usr/bin',
      environment => ['HOME=/root'],
      command   => 'git config --global core.editor vi',
    }




