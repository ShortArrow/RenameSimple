[CmdletBinding()]
param (
  # Parameter help description
  [Parameter(AttributeValues)]
  [ParameterType]
  $ParameterName
)

function Select-Folder1 {
  param (
    
  )
  
  # enable [System.Windows.Forms] Assambly
  [void][System.Reflection.Assembly]::Load("System.Windows.Forms")#, Version=2.0.0.0, Culture=Neutral, PublicKeyToken=b77a5c561934e089")
  
  # make instance from OpenFileDialog class,setting nessesary info
  $dialog = New-Object System.Windows.Forms.OpenFileDialog
  # $dialog.Filter = "画像ファイル(*.PNG;*.JPG;*.GIF)|*.PNG;*.JPG;*.JPEG;*.GIF"
  $dialog.Filter = "対象ファイル(*.*)|*.*"
  $dialog.InitialDirectory = ""
  $dialog.Title = "ファイルを選択してください"
  $dialog.MultiSelect = $true
  
  # show dialog
  if($dialog.ShowDialog() -eq "OK"){
    # if click ok button,show selected file path
    Write-Host $dialog.FileName + " が選択されました。"
  }
  return $dialog.FileName
}
