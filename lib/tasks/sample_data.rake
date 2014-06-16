namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Partclass.create!(name: "EP")
    Partclass.create!(name: "CP")

    Type.create!(name: "文字列")
    Type.create!(name: "テーブル")
    Type.create!(name: "プログラム")

    Property.create!(company_id: 1, code: "MEMO", name: "定型メモ", propertyID: 1 )
    Property.create!(company_id: 1, code: "MEMO", name: "定型メモ", propertyID: 2 )
    Property.create!(company_id: 1, code: "MEMO", name: "定型メモ", propertyID: 3 )
    Property.create!(company_id: 1, code: "ES", name: "見積書（概算）", propertyID: 4 )
    Property.create!(company_id: 1, code: "QS", name: "見積書（確定）", propertyID: 5 )
    Property.create!(company_id: 1, code: "FS", name: "機能仕様書", propertyID: 6 )
    Property.create!(company_id: 1, code: "BD", name: "基本設計書", propertyID: 7 )
    Property.create!(company_id: 1, code: "DD", name: "詳細設計書", propertyID: 8 )
    Property.create!(company_id: 1, code: "DP", name: "製造設計書", propertyID: 9 )
    Property.create!(company_id: 1, code: "GD", name: "画面設計", propertyID: 10 )
    Property.create!(company_id: 1, code: "TD", name: "テーブル設計", propertyID: 11 )
    Property.create!(company_id: 1, code: "PF", name: "プログラムフロー", propertyID: 12 )
    Property.create!(company_id: 1, code: "SC", name: "ソースコード", propertyID: 13 )
    Property.create!(company_id: 1, code: "TS", name: "テスト仕様書", propertyID: 14 )
    Property.create!(company_id: 1, code: "TP", name: "テストプログラム", propertyID: 15 )
    Property.create!(company_id: 1, code: "TR", name: "テスト結果", propertyID: 16 )
    Property.create!(company_id: 1, code: "PG", name: "プログラム", propertyID: 17 )
    Property.create!(company_id: 1, code: "OTHER", name: "その他", propertyID: 18 )

    Part.create!(
        company_id: 1,
        property_id: 18,
        no: "first_ep",
        name: "EP1",
        partclass_id: 1,
        type_id: 1,
        classify_id: 1,
        description: "",
        content: "")
    Parameter.create!(part_id: 1,name: 'p1',description: "name")
    Parameter.create!(part_id: 1,name: 'p2',description: "age")

    ExportType.create!(name: "WORD")
    ExportType.create!(name: "EXCEL")
    ExportType.create!(name: "PDF")

    Automation.create!(
        name: 'EP1-AUTO',
        part_id: 1,
        export_type_id: 2
    )

    AutoParameter.create!(automation_id: 1,parameter_id: 1, value: "chenxp")
    AutoParameter.create!(automation_id: 1,parameter_id: 2, value: "25")
  end
end