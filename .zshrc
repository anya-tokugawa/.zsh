: "Define Function" 
	function chpwd() { ls -F } # auto display list directory after changed directory
: "Chk Update"
	function zsh_update() {
		
		cd $HOME/.zsh
			LATEST_ZSH_VERSION=`git describe --abbrev=0`
			CURRENT_ZSH_VERSION=`git describe --abbrev=0 --tags`
		cd $OLDPWD
		if($CURRENT_ZSH_VERSION != $LATEST_ZSH_VERSION){
			echo "*** THIS ZSH_CONF VERSION IS NOT LATEST! - You can pull latest!"
		}
	}
	zsh_update() &
