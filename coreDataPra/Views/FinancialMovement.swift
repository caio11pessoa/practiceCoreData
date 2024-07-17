//
//  FinancialMovement.swift
//  coreDataPra
//
//  Created by Caio de Almeida Pessoa on 11/07/24.
//

import SwiftUI

struct FinancialMovement: View {
    
    @ObservedObject var viewModel: FinancialMovimentViewModel = FinancialMovimentViewModel()
    
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
            
            HStack {
                Button("Receita") {
                    viewModel.receita = true
                    viewModel.isShowingSheet.toggle()
                }
                .padding()
                
                Button("Gasto"){
                    viewModel.receita = false
                    viewModel.isShowingSheet.toggle()
                }
                .tint(.red)
                .padding()
            }
            .padding()
            .sheet(isPresented: $viewModel.isShowingSheet){
                AddMovimentSheet(viewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        NavigationLink {
                            Graficos(viewModel: viewModel)
                        } label: {
                            Text("Graficos")
                        }
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
        }
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
                    HStack {
                        Text(moviPerDay.day.formatted(
                            .dateTime
                                .day()
                                .month(.twoDigits)
                                .hour()
                                .minute()
                        ))
                        Text("Ganho")
                        Text("R$ " + moviPerDay.valor.twoDecimalPlaces)
                            .foregroundStyle(.green)
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
                    HStack {
                        Text(moviPerDay.day.formatted(
                            .dateTime
                                .day()
                                .month(.twoDigits)
                                .hour()
                                .minute()
                        ))
                        Text("Ganho")
                        Text("R$ " + moviPerDay.valor.twoDecimalPlaces)
                            .foregroundStyle(.green)
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
                    HStack {
                        Text(moviPerDay.day.formatted(
                            .dateTime
                                .day()
                                .month(.twoDigits)
                                .hour()
                                .minute()
                        ))
                        Text("Ganho")
                        Text("R$ " + moviPerDay.valor.twoDecimalPlaces)
                            .foregroundStyle(.red)
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
                    HStack {
                        Text(moviPerDay.day.formatted(
                            .dateTime
                                .day()
                                .month(.twoDigits)
                                .hour()
                                .minute()
                        ))
                        Text("Ganho")
                        Text("R$ " + moviPerDay.valor.twoDecimalPlaces)
                            .foregroundStyle(.red)
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
        FinancialMovement()
    }
}

enum TypeOfList {
    case allMoviments
    case ganhosPorDia
    case gastosPorDia
    case ganhosPorMes
    case gastosPorMes
}
