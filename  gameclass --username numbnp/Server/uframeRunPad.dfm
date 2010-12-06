object frameRunPad: TframeRunPad
  Left = 0
  Top = 0
  Width = 449
  Height = 411
  TabOrder = 0
  object pnlTop2: TPanel
    Left = 0
    Top = 0
    Width = 449
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object gbSessionStop: TGroupBox
      Left = 0
      Top = 0
      Width = 261
      Height = 40
      Align = alClient
      Caption = #1058#1072#1088#1080#1092' Internet'
      TabOrder = 0
      object cbxInternetControl: TCheckBox
        Left = 8
        Top = 16
        Width = 249
        Height = 17
        Caption = #1059#1087#1088#1072#1074#1083#1103#1090#1100' '#1079#1072#1082#1083#1072#1076#1082#1086#1081' Internet '#1080' '#1086#1082#1085#1072#1084#1080' IE'
        TabOrder = 0
        OnClick = cbxInternetControlClick
        OnKeyUp = cbxInternetControlKeyUp
      end
    end
    object gbOther: TGroupBox
      Left = 261
      Top = 0
      Width = 188
      Height = 40
      Align = alRight
      Caption = #1044#1088#1091#1075#1086#1077
      TabOrder = 1
      Visible = False
      object lblShellCurrent: TLabel
        Left = 8
        Top = 16
        Width = 106
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1084#1099#1081' '#1096#1077#1083#1083
      end
    end
  end
  object gbTabs: TGroupBox
    Left = 0
    Top = 40
    Width = 449
    Height = 371
    Align = alClient
    Caption = '    '
    TabOrder = 0
    object lblTarifs: TLabel
      Left = 8
      Top = 24
      Width = 41
      Height = 13
      Caption = #1058#1072#1088#1080#1092#1099
    end
    object lblTabsAll: TLabel
      Left = 148
      Top = 24
      Width = 49
      Height = 13
      Caption = #1047#1072#1082#1083#1072#1076#1082#1080
    end
    object lblTabsCurrent: TLabel
      Left = 316
      Top = 24
      Width = 50
      Height = 13
      Caption = #1057#1082#1088#1099#1074#1072#1090#1100
    end
    object cbxHideTabs: TCheckBox
      Left = 12
      Top = 0
      Width = 133
      Height = 17
      Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1079#1072#1082#1083#1072#1076#1082#1080
      TabOrder = 0
      OnClick = cbxHideTabsClick
      OnKeyUp = cbxHideTabsKeyUp
    end
    object butAddTabToHided: TButton
      Left = 285
      Top = 168
      Width = 25
      Height = 25
      Caption = '>>'
      TabOrder = 1
      OnClick = butAddTabToHidedClick
    end
    object butRemoveFromTabToHided: TButton
      Left = 285
      Top = 200
      Width = 25
      Height = 25
      Caption = '<<'
      TabOrder = 2
      OnClick = butRemoveFromTabToHidedClick
    end
    object Panel1: TPanel
      Left = 2
      Top = 336
      Width = 445
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object lblTab: TLabel
        Left = 8
        Top = 10
        Width = 49
        Height = 13
        Caption = #1047#1072#1082#1083#1072#1076#1082#1072
      end
      object butTabAdd: TButton
        Left = 223
        Top = 5
        Width = 70
        Height = 25
        Caption = 'add'
        Enabled = False
        TabOrder = 0
        OnClick = butTabAddClick
      end
      object butTabDelete: TButton
        Left = 374
        Top = 5
        Width = 70
        Height = 25
        Caption = 'delete'
        TabOrder = 1
        OnClick = butTabDeleteClick
      end
      object butTabUpdate: TButton
        Left = 299
        Top = 5
        Width = 70
        Height = 25
        Caption = 'update'
        Enabled = False
        TabOrder = 2
        OnClick = butTabUpdateClick
      end
      object editTab: TEdit
        Left = 64
        Top = 8
        Width = 153
        Height = 21
        TabOrder = 3
        OnChange = editTabChange
      end
    end
    object lbTarifs: TListBox
      Left = 8
      Top = 40
      Width = 129
      Height = 297
      ItemHeight = 13
      Items.Strings = (
        'gfhfgh'
        'fghfghfg'
        'fghfgh')
      TabOrder = 4
      OnClick = lbTarifsClick
      OnKeyPress = lbTarifsKeyPress
    end
    object lbTabs: TListBox
      Left = 148
      Top = 40
      Width = 129
      Height = 297
      ItemHeight = 13
      Items.Strings = (
        'gfhfgh'
        'fghfghfg'
        'fghfgh')
      TabOrder = 5
      OnClick = lbTabsClick
      OnKeyPress = lbTabsKeyPress
    end
    object lbHidedTabs: TListBox
      Left = 316
      Top = 40
      Width = 129
      Height = 297
      ItemHeight = 13
      Items.Strings = (
        'gfhfgh'
        'fghfghfg'
        'fghfgh')
      TabOrder = 6
      OnClick = lbHidedTabsClick
      OnKeyPress = lbHidedTabsKeyPress
    end
  end
end
