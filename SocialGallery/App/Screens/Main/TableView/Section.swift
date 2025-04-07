enum SectionType {
    case persons
}

enum RowType {
    case person
}

struct Section {
    let type: SectionType
    let rows: [RowType]
}

