//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Observation


@Observable
class InternalMedicationSettingsViewModel<MI: MedicationInstance> {
    private var _medicationInstances: Set<MI>
    let medicationOptions: Set<MI.InstanceType>
    let createMedicationInstance: AddMedication<MI>.CreateMedicationInstance
    
    
    var medicationInstances: [MI] {
        _medicationInstances.sorted()
    }
    
    
    init(
        medicationInstances: Set<MI>,
        medicationOptions: Set<MI.InstanceType>,
        createMedicationInstance: @escaping AddMedication<MI>.CreateMedicationInstance
    ) {
        self._medicationInstances = medicationInstances
        self.medicationOptions = medicationOptions
        self.createMedicationInstance = createMedicationInstance
    }
    
    func set(medicationInstances: Set<MI>) {
        self._medicationInstances = medicationInstances
    }
    
    func duplicateOf(medication: MI.InstanceType, dosage: MI.InstanceDosage) -> Bool {
        medicationInstances.contains(where: { $0.type == medication && $0.dosage == dosage })
    }
    
    func insert(medicationInstance: MI) {
        _medicationInstances.insert(medicationInstance)
    }
    
    func remove(medicationInstance: MI) {
        _medicationInstances.remove(medicationInstance)
    }
    
    func edit(dosage: MI.InstanceDosage, of medicationInstance: MI) {
        guard medicationInstance.dosage != dosage else {
            return
        }
        
        remove(medicationInstance: medicationInstance)
        
        var modifiedMedication = medicationInstance
        modifiedMedication.dosage = dosage
        
        insert(medicationInstance: modifiedMedication)
    }
    
    func edit(schedule: Schedule, of medicationInstance: MI) {
        guard medicationInstance.schedule != schedule else {
            return
        }
        
        remove(medicationInstance: medicationInstance)
        
        var modifiedMedication = medicationInstance
        modifiedMedication.schedule = schedule
        
        insert(medicationInstance: modifiedMedication)
    }
}


extension MedicationSettingsViewModel {
    var internalViewModel: InternalMedicationSettingsViewModel<Medications> {
        let medicationInstances: Set<Medications>
        if Medications.self is AnyClass {
            guard Medications.self is Observation.Observable.Type else {
                preconditionFailure("If \(String(describing: Medications.self)) is a class type, it must conform to `Observable` using the `@Observable` macro.")
            }
            
            // If the medication instances are classes we need to make copies of them to ensure that we don't modify the original instances before the user presses save.
            medicationInstances = Set(
                self.medicationInstances.map { medicationInstance in
                    createMedicationInstance(
                        withType: medicationInstance.type,
                        dosage: medicationInstance.dosage,
                        schedule: medicationInstance.schedule
                    )
                }
            )
        } else {
            medicationInstances = self.medicationInstances
        }
        
        return InternalMedicationSettingsViewModel(
            medicationInstances: medicationInstances,
            medicationOptions: medicationOptions,
            createMedicationInstance: createMedicationInstance
        )
    }
}
