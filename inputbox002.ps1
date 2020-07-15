# Microsoft.VisualBasicアセンブリを有効化
[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")

# 入力ボックスを表示（入力値は変数$inputにセット）
$input = [Microsoft.VisualBasic.Interaction]::InputBox("メッセージを入力してください。", "Visual Basic関数")
# 入力値の文字列長が0以上である（空でない）場合に、結果を表示
if($input.Length -gt 0){
  "入力された値：" + $input
}


[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
$InputText = [Microsoft.VisualBasic.Interaction]::InputBox("Message","Title")
$InputText


[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
$vbInteraction = [Microsoft.VisualBasic.Interaction]
$inputMsg = $vbInteraction::InputBox("Input Messages","Title")
$inputMsg

Add-Type -AssemblyName "Microsoft.VisualBasic"
$Result = [Microsoft.VisualBasic.Interaction]::InputBox("何か値を入れてね！", "タイトル", "デフォルト値")
$Result

$Result = Read-Host
$Result
