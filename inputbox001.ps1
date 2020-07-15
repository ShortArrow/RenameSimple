Add-Type -AssemblyName PresentationFramework
[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" 
  Height="150" Width="600"
  ResizeMode="CanResizeWithGrip" Title="InputBox">
<Window.Resources>
  <Style TargetType="Button">
    <Setter Property="Width" Value="150" />
    <Setter Property="Margin" Value="10,5" />
  </Style>
</Window.Resources>
<StackPanel FocusManager.FocusedElement="{Binding ElementName=inputText}">
  <TextBlock Text="入力してください。" Margin="10,10,10,5" />
  <TextBox Name="inputText" Text="" Margin="10,0,10,10" />
  <StackPanel Orientation="Horizontal">
    <Button Name="okButton" Content="OK" IsDefault="True" />
    <Button Name="cancelButton" Content="Cancel" IsCancel="True" />
  </StackPanel>
</StackPanel>
</Window>
'@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$txt1 = $window.FindName("inputText")
$okBtn = $window.FindName("okButton")
$cancelBtn = $window.FindName("cancelButton")

# 入力内容保存用
[string]$Script:InText = ""

# OKボタン押下時の処理
$okBtn_clicked = $okBtn.add_Click
$okBtn_clicked.Invoke({
  Write-Host "OK押された" -ForegroundColor Green
  $Script:InText = $txt1.Text
  $window.Close()
})

# Cancelボタン押下時の処理
$cancelBtn_clicked = $cancelBtn.add_Click
$cancelBtn_clicked.Invoke({
  Write-Host "Cancel押された" -ForegroundColor Green
  $window.Close()
})

# InputBox表示
$window.ShowDialog() > $null

# 入力結果表示
if ($Script:InText) {
    Write-Output ("入力された内容は、" + $Script:InText + "です。")
} else {
    Write-Output "何も入力されなかったかキャンセルされました。"
}