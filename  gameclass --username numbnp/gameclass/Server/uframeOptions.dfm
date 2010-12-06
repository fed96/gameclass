object frameOptions: TframeOptions
  Left = 0
  Top = 0
  Width = 451
  Height = 413
  TabOrder = 0
  object gbPayment: TGroupBox
    Left = 0
    Top = 0
    Width = 451
    Height = 217
    Align = alTop
    Caption = #1054#1087#1083#1072#1090#1072
    TabOrder = 0
    object pnlTopLeft: TPanel
      Left = 2
      Top = 15
      Width = 224
      Height = 200
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object gbChange: TGroupBox
        Left = 0
        Top = 112
        Width = 224
        Height = 88
        Align = alClient
        Caption = #1057#1076#1072#1095#1072
        TabOrder = 0
        object cbxDisableChange: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100
          TabOrder = 0
          OnClick = cbxDisableChangeClick
        end
        object cbxEnableChangeForPackets: TCheckBox
          Left = 8
          Top = 48
          Width = 201
          Height = 17
          Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1076#1083#1103' '#1087#1072#1082#1077#1090#1085#1099#1093' '#1090#1072#1088#1080#1092#1086#1074
          TabOrder = 2
          OnClick = cbxEnableChangeForPacketsClick
        end
        object cbxEnableChangeForReserveCancel: TCheckBox
          Left = 8
          Top = 64
          Width = 201
          Height = 17
          Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1076#1083#1103' '#1086#1090#1084#1077#1085#1099' '#1073#1088#1086#1085#1080
          TabOrder = 3
          OnClick = cbxEnableChangeForReserveCancelClick
        end
        object cbxEnableChangeForSeparateTraffic: TCheckBox
          Left = 8
          Top = 32
          Width = 209
          Height = 17
          Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1076#1083#1103' '#1086#1090#1076#1077#1083#1100#1085#1086#1075#1086' '#1090#1088#1072#1092#1080#1082#1072
          TabOrder = 1
          OnClick = cbxEnableChangeForSeparateTrafficClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 224
        Height = 112
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object gbPaymentMode: TGroupBox
          Left = 0
          Top = 0
          Width = 137
          Height = 112
          Align = alLeft
          Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
          TabOrder = 0
          object cbxPrepayOnly: TCheckBox
            Left = 8
            Top = 16
            Width = 120
            Height = 17
            Caption = #1058#1086#1083#1100#1082#1086' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1072
            TabOrder = 0
            OnClick = cbxPrepayOnlyClick
          end
          object gbPaymentModeDefault: TGroupBox
            Left = 8
            Top = 32
            Width = 121
            Height = 53
            Caption = #1055#1086'-'#1091#1084#1086#1083#1095#1072#1085#1080#1102
            TabOrder = 1
            object rbtnPrepay: TRadioButton
              Left = 8
              Top = 16
              Width = 105
              Height = 17
              Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072
              Checked = True
              TabOrder = 0
              TabStop = True
              OnClick = rbtnPrepayClick
            end
            object rbtnPostpay: TRadioButton
              Left = 8
              Top = 32
              Width = 105
              Height = 17
              Caption = #1055#1086#1089#1090#1086#1087#1083#1072#1090#1072
              TabOrder = 1
              OnClick = rbtnPostpayClick
            end
          end
          object cbxReserveDisable: TCheckBox
            Left = 8
            Top = 90
            Width = 110
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1073#1088#1086#1085#1100
            TabOrder = 2
            OnClick = cbxReserveDisableClick
          end
        end
        object pnlOperatingTime: TGroupBox
          Left = 137
          Top = 0
          Width = 87
          Height = 112
          Align = alClient
          Caption = '          '
          TabOrder = 1
          object lblOperatingTimeBegin: TLabel
            Left = 8
            Top = 16
            Width = 37
            Height = 13
            Caption = #1053#1072#1095#1072#1083#1086
          end
          object lblOperatingTimeEnd: TLabel
            Left = 8
            Top = 56
            Width = 55
            Height = 13
            Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077
          end
          object dtpOperatingTimeBegin: TDateTimePicker
            Left = 8
            Top = 32
            Width = 57
            Height = 21
            Date = 39624.464174976850000000
            Format = 'HH:mm'
            Time = 39624.464174976850000000
            Kind = dtkTime
            TabOrder = 0
            OnChange = dtpOperatingTimeBeginChange
          end
          object dtpOperatingTimeEnd: TDateTimePicker
            Left = 8
            Top = 72
            Width = 57
            Height = 21
            Date = 39624.464174976850000000
            Format = 'HH:mm'
            Time = 39624.464174976850000000
            Kind = dtkTime
            TabOrder = 1
            OnChange = dtpOperatingTimeEndChange
          end
          object cbxOperatingTime: TCheckBox
            Left = 8
            Top = 0
            Width = 57
            Height = 17
            Caption = #1042#1088#1077#1084#1103' '
            TabOrder = 2
            OnClick = cbxOperatingTimeClick
          end
        end
      end
    end
    object pnlTopRight: TPanel
      Left = 226
      Top = 15
      Width = 223
      Height = 200
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object gbSum: TGroupBox
        Left = 0
        Top = 0
        Width = 223
        Height = 153
        Align = alTop
        Caption = #1057#1091#1084#1084#1099
        TabOrder = 0
        object lblStartMoneyMin: TLabel
          Left = 8
          Top = 16
          Width = 88
          Height = 13
          Caption = #1052#1080#1085#1080#1084#1091#1084' '#1086#1087#1083#1072#1090#1099
        end
        object lblStartMoneyMax: TLabel
          Left = 8
          Top = 40
          Width = 94
          Height = 13
          Caption = #1052#1072#1082#1089#1080#1084#1091#1084' '#1086#1087#1083#1072#1090#1099
        end
        object lblAddMoneyMin: TLabel
          Left = 8
          Top = 64
          Width = 94
          Height = 13
          Caption = #1052#1080#1085#1080#1084#1091#1084' '#1076#1086#1087#1083#1072#1090#1099
        end
        object lblAddMoneyMax: TLabel
          Left = 8
          Top = 88
          Width = 100
          Height = 13
          Caption = #1052#1072#1082#1089#1080#1084#1091#1084' '#1076#1086#1087#1083#1072#1090#1099
        end
        object lblMaximumTrust: TLabel
          Left = 8
          Top = 112
          Width = 99
          Height = 13
          Caption = #1052#1072#1082#1089#1080#1084#1091#1084' '#1076#1086#1074#1077#1088#1080#1103
        end
        object edtStartMoneyMin: TEdit
          Left = 136
          Top = 13
          Width = 49
          Height = 21
          TabOrder = 0
          Text = '1'
          OnChange = edtStartMoneyMinChange
        end
        object edtStartMoneyMax: TEdit
          Left = 136
          Top = 37
          Width = 49
          Height = 21
          TabOrder = 1
          Text = '100'
          OnChange = edtStartMoneyMaxChange
        end
        object edtAddMoneyMin: TEdit
          Left = 136
          Top = 61
          Width = 49
          Height = 21
          TabOrder = 2
          Text = '1'
          OnChange = edtAddMoneyMinChange
        end
        object edtAddMoneyMax: TEdit
          Left = 136
          Top = 85
          Width = 49
          Height = 21
          TabOrder = 3
          Text = '100'
          OnChange = edtAddMoneyMaxChange
        end
        object edtMaximumTrust: TEdit
          Left = 136
          Top = 109
          Width = 49
          Height = 21
          TabOrder = 4
          Text = '200'
          OnChange = edtMaximumTrustChange
        end
      end
      object gbCurrency: TGroupBox
        Left = 0
        Top = 153
        Width = 223
        Height = 47
        Align = alClient
        Caption = #1042#1072#1083#1102#1090#1072
        TabOrder = 1
        object lblCurrency: TLabel
          Left = 8
          Top = 16
          Width = 152
          Height = 13
          Caption = #1050#1088#1072#1090#1082#1086#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077' '#1074#1072#1083#1102#1090#1099
        end
        object edtCurrency: TEdit
          Left = 168
          Top = 13
          Width = 33
          Height = 21
          TabOrder = 0
          Text = '$'
          OnChange = edtCurrencyChange
        end
      end
    end
  end
  object gbOthers: TGroupBox
    Left = 0
    Top = 217
    Width = 451
    Height = 64
    Align = alTop
    Caption = #1044#1088#1091#1075#1086#1077
    TabOrder = 1
    object lblClubName: TLabel
      Left = 8
      Top = 16
      Width = 82
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1082#1083#1091#1073#1072
    end
    object edtClubName: TEdit
      Left = 104
      Top = 13
      Width = 337
      Height = 21
      TabOrder = 0
      Text = 'My Club'
      OnChange = edtClubNameChange
    end
    object cbxDebugLog: TCheckBox
      Left = 8
      Top = 40
      Width = 161
      Height = 17
      Caption = #1042#1077#1089#1090#1080' '#1078#1091#1088#1085#1072#1083#1099' '#1086#1090#1083#1072#1076#1082#1080
      TabOrder = 1
      OnClick = cbxDebugLogClick
    end
  end
  object gbOperator: TGroupBox
    Left = 0
    Top = 343
    Width = 451
    Height = 58
    Align = alTop
    Caption = #1052#1072#1096#1080#1085#1072' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
    TabOrder = 2
    object lblIPAddress: TLabel
      Left = 8
      Top = 19
      Width = 43
      Height = 13
      Caption = 'IP-'#1072#1076#1088#1077#1089
    end
    object edtOperatorIP: TEdit
      Left = 56
      Top = 16
      Width = 89
      Height = 21
      TabOrder = 0
      Text = '288.288.288.288'
      OnChange = edtOperatorIPChange
    end
    object cbxPrinterControl: TCheckBox
      Left = 160
      Top = 16
      Width = 169
      Height = 17
      Caption = #1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1087#1077#1095#1072#1090#1100' '#1082#1072#1082' '#1091#1089#1083#1091#1075#1091
      TabOrder = 1
      OnClick = cbxPrinterControlClick
    end
    object cbxInternetControl: TCheckBox
      Left = 160
      Top = 32
      Width = 121
      Height = 17
      Caption = #1089#1095#1080#1090#1072#1090#1100' '#1090#1088#1072#1092#1092#1080#1082
      TabOrder = 2
      OnClick = cbxInternetControlClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 281
    Width = 451
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object gbRepair: TGroupBox
      Left = 0
      Top = 0
      Width = 228
      Height = 62
      Align = alLeft
      Caption = #1056#1077#1084#1086#1085#1090
      TabOrder = 0
      object lblMinutsForLongRepair: TLabel
        Left = 8
        Top = 36
        Width = 94
        Height = 13
        Caption = '<'#1056#1077#1084#1086#1085#1090' '#1085#1072#1076#1086#1083#1075#1086'>'
      end
      object lblMin: TLabel
        Left = 146
        Top = 36
        Width = 23
        Height = 13
        Caption = #1084#1080#1085'.'
      end
      object cbxEnableInternetRemont: TCheckBox
        Left = 8
        Top = 16
        Width = 129
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1072#1090#1100' '#1080#1085#1090#1077#1088#1085#1077#1090
        TabOrder = 0
        OnClick = cbxEnableInternetRemontClick
      end
      object edtMinutsForLongRepair: TEdit
        Left = 107
        Top = 33
        Width = 33
        Height = 21
        TabOrder = 1
        Text = '360'
        OnChange = edtMinutsForLongRepairChange
      end
    end
    object gbGuest: TGroupBox
      Left = 228
      Top = 0
      Width = 223
      Height = 62
      Align = alClient
      Caption = #1057#1077#1072#1085#1089' "'#1043#1086#1089#1090#1100'"'
      TabOrder = 1
      object lblTarif: TLabel
        Left = 8
        Top = 36
        Width = 33
        Height = 13
        Caption = #1058#1072#1088#1080#1092
      end
      object cbxGuestSession: TCheckBox
        Left = 8
        Top = 16
        Width = 201
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1077#1085#1080#1077' '#1089' '#1082#1083#1080#1077#1085#1090#1089#1082#1086#1075#1086' '#1084#1077#1089#1090#1072
        TabOrder = 0
        OnClick = cbxGuestSessionClick
      end
      object cboGuestSessionTarif: TComboBox
        Left = 51
        Top = 32
        Width = 166
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = cboGuestSessionTarifChange
      end
    end
  end
end
