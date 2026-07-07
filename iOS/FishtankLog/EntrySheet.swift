import SwiftUI

struct EntrySheet: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    var editing: FishEntry?

    @State private var name: String = ""
    @State private var field1: String = ""
    @State private var field2: String = ""
    @State private var extraField: String = ""
    @State private var notes: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .accessibilityIdentifier("entryNameField")
                    TextField("Species", text: $field1)
                        .accessibilityIdentifier("entryField1Field")
                    TextField("Tank", text: $field2)
                        .accessibilityIdentifier("entryField2Field")
                    TextField("Last Water Test", text: $extraField)
                        .accessibilityIdentifier("entryExtraField")
                    TextField("Notes", text: $notes, axis: .vertical)
                        .accessibilityIdentifier("entryNotesField")

                }
            }
            .scrollDismissesKeyboard(.interactively)
            .contentShape(Rectangle())
            .onTapGesture { isFocused = false }
            .navigationTitle(editing == nil ? "Add Fish" : "Edit Fish")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("entryCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .accessibilityIdentifier("entrySaveButton")
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let e = editing {
                    name = e.name
                    field1 = e.species
                    field2 = e.tankName
                    extraField = e.lastTestDate
                    notes = e.notes
                }
            }
        }
    }

    private func save() {
        if var e = editing {
            e.name = name
            e.species = field1
            e.tankName = field2
            e.lastTestDate = extraField
            e.notes = notes
            store.update(e)
        } else {
            let entry = FishEntry(name: name, species: field1, tankName: field2, lastTestDate: extraField, notes: notes)
            store.add(entry)
        }
        dismiss()
    }
}
