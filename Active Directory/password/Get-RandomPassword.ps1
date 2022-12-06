function Get-RandomPassword {
    #param ()
    $uppercase = "ABCDEFGHKLMNOPRSTUVWXYZ".tochararray() 
    $lowercase = "abcdefghiklmnoprstuvwxyz".tochararray() 
    $number = "0123456789".tochararray() 
    $special = "$%&/()=?}{@#*+!".tochararray() 
        For ($i=0; $i -le 10; $i++) {
            $password =($uppercase | Get-Random -count 1) -join ''
            $password +=($lowercase | Get-Random -count 5) -join ''
            $password +=($number | Get-Random -count 1) -join ''
            $password +=($special | Get-Random -count 1) -join ''
            $passwordarray=$password.tochararray() 
            $Randompassword=($passwordarray | Get-Random -Count 8) -join ''
        }
        return $Randompassword
}
