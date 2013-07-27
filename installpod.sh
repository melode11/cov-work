if test "$(gem query -n 'cocoapods' | grep 'cocoapods')" = "" ;
then
   echo "No cocoapods detected,start to install…";
   gem install cocoapods
   pod setup
else
   echo "Cocoapods have been detected."
fi
if test "$(gem update cocoapods | grep 'Nothing')"="" ;
then
   echo "cocoapods updated, run setup"
   pod setup
else
   echo "cocoapods is latest";
fi

pod install --verbose --no-integrate;