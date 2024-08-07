//
//  FinancialMovement.swift
//  coreDataPra
//
//  Created by Caio de Almeida Pessoa on 11/07/24.
//

import SwiftUI

struct FinancialMovement: View {
    
    @ObservedObject var viewModel: FinancialMovimentViewModel
    
    @State var typeOfList: TypeOfList = .allMoviments
    
    var body: some View {
        VStack {
            switch typeOfList {
            case .allMoviments:
                allMoviments
            case .ganhosPorDia:
                listPerDayGanho
            case .gastosPorDia:
                listPerDayGasto
            case .ganhosPorMes:
                listPerMonthGanho
            case .gastosPorMes:
                listPerMonthGasto
            }
            Button {
                viewModel.isShowingSheet = true
            } label: {
                HStack{
                    Spacer()
                    Text("Nova Movimentação")
                    Spacer()
                }
            }
            .sheet(isPresented: $viewModel.isShowingSheet){
                AddMovimentSheet(viewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        buttonSorted
                        Button("Ganhos Por Dia") {
                            typeOfList = .ganhosPorDia
                        }
                        Button("Gastos Por Dia") {
                            typeOfList = .gastosPorDia
                        }
                        Button("Gastos Por Mes") {
                            typeOfList = .gastosPorMes
                        }
                        Button("Ganhos Por Mes") {
                            typeOfList = .ganhosPorMes
                        }
                        Button("Todas as movimentações") {
                            typeOfList = .allMoviments
                        }
                        
                    } label: {
                        Text("Menu")
                    }
                    
                    
                }
            }
            Spacer()
        }
        .navigationTitle("Movimentações")
    }
    
    var buttonSorted: some View {
        Button {
            withAnimation {
                viewModel.sorted.toggle()
            }
        } label: {
            HStack{
                Text("Ordenar por Data")
                if(viewModel.sorted){
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    
    var listPerDayGanho: some View {
        List {
            Section {
                ForEach(viewModel.ganhosPorDia){ moviPerDay in
                    NavigationLink {
                        MovimentsListView(movimentPerDay: moviPerDay, dateMark: moviPerDay.day.formatted(
                            .dateTime
                                .day(.twoDigits)
                                .month(.twoDigits)
                        ))
                    } label: {
                        HStack {
                            Text(moviPerDay.day.formatted(
                                .dateTime
                                    .day(.twoDigits)
                                    .month(.twoDigits)
                            ))
                            Text("Ganho")
                            Text("R$ " + moviPerDay.valor.twoDecimalPlaces)
                                .foregroundStyle(.green)
                        }
                    }
                }
            } header: {
                HStack {
                    Text("Total:")
                    
                    Text("R$ " + viewModel.totalGanhos.twoDecimalPlaces)
                        .foregroundStyle(.green)
                }
                .font(.headline)
            }
        }
    }
    var listPerMonthGanho: some View {
        List {
            Section {
                ForEach(viewModel.ganhosPorMes){ moviPerDay in
                    NavigationLink {
                        MovimentsListView(movimentPerDay: moviPerDay, dateMark: moviPerDay.day.formatted(
                            .dateTime
                                .month(.wide)
                        ))
                    } label: {
                        HStack {
                            Text(moviPerDay.day.formatted(
                                .dateTime
                                    .month(.wide)
                            ))
                            Text("Ganho")
                            Text("R$ " + moviPerDay.valor.twoDecimalPlaces)
                                .foregroundStyle(.green)
                        }
                    }
                }
            } header: {
                HStack {
                    Text("Total:")
                    
                    Text("R$ " + viewModel.totalGanhos.twoDecimalPlaces)
                        .foregroundStyle(.green)
                }
                .font(.headline)
            }
            
            
            
        }
    }
    var listPerDayGasto: some View {
        List {
            Section {
                ForEach(viewModel.gastosPorDia){ moviPerDay in
                    NavigationLink {
                        MovimentsListView(movimentPerDay: moviPerDay, dateMark: moviPerDay.day.formatted(
                            .dateTime
                                .day(.twoDigits)
                                .month(.twoDigits)
                        ))
                    } label: {
                        HStack {
                            Text(moviPerDay.day.formatted(
                                .dateTime
                                    .day(.twoDigits)
                                    .month(.twoDigits)
                            ))
                            Text("Ganho")
                            Text("R$ " + moviPerDay.valor.twoDecimalPlaces)
                                .foregroundStyle(.red)
                        }
                    }
                }
            } header: {
                HStack {
                    Text("Total:")
                    
                    Text("R$ " + viewModel.totalGastos.twoDecimalPlaces)
                        .foregroundStyle(.red)
                }
                .font(.headline)
            }
            
            
            
        }
    }
    var listPerMonthGasto: some View {
        List {
            Section {
                ForEach(viewModel.gastosPorMes){ moviPerDay in
                    NavigationLink {
                        MovimentsListView(movimentPerDay: moviPerDay, dateMark: moviPerDay.day.formatted(
                            .dateTime
                                .month(.wide)
                        ))
                    } label: {
                        ListColabCell(moviPerDay: moviPerDay)
                    }
                }
            } header: {
                HStack {
                    Text("Total:")
                    
                    Text("R$ " + viewModel.totalGastos.twoDecimalPlaces)
                        .foregroundStyle(.red)
                }
                .font(.headline)
            }
            
            
            
        }
    }
    var allMoviments: some View {
        List {
            Section {
                ForEach(viewModel.sorted ? viewModel.movimentsSorted : viewModel.moviments){ moviment in
                    NavigationLink {
                        MovimentView(moviment: moviment)
                    } label: {
                        ListCell(moviment: moviment)
                    }
                    
                }
                .onDelete(perform: viewModel.deleteMoviment)
            } header: {
                
                HStack {
                    Text("Total:")
                    
                    Text("RS$ " + viewModel.total.twoDecimalPlaces)
                        .foregroundStyle(viewModel.total < 0 ? .red : .green)
                }
                .font(.headline)
            }
        }
    }
}

#Preview {
    NavigationStack{
        FinancialMovement(viewModel: FinancialMovimentViewModel(database: .init()))
    }
}

enum TypeOfList {
    case allMoviments
    case ganhosPorDia
    case gastosPorDia
    case ganhosPorMes
    case gastosPorMes
}
