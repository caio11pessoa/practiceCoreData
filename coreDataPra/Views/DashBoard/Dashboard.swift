//
//  Dashboard.swift
//  coreDataPra
//
//  Created by Caio de Almeida Pessoa on 18/07/24.
//

import SwiftUI

struct Dashboard: View {
    @StateObject var viewModel: FinancialMovimentViewModel = FinancialMovimentViewModel(database: .init())
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Saldo atual")
                    .font(.title3)
                    .padding(.bottom, 8)
                Text("R$ \(viewModel.total.twoDecimalPlaces)")
                    .font(.title)
                    .bold()
                Divider()
                    .background(.black)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Receita:")
                        Text("R$ \(viewModel.totalGanhos.twoDecimalPlaces)")
                            .foregroundStyle(.green)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Custos:")
                        Text("R$ \(viewModel.totalGastos.twoDecimalPlaces)")
                            .foregroundStyle(.red)
                    }
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 24)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [
                    GridItem(.flexible()),
                ], spacing: 20) {
                    NavigationLink {
                        DiaryView()
                    } label: {
                        DashBoardCard(text: "Diário",
                                      image: "list.clipboard")
                    }
                    NavigationLink {
                        Graficos(viewModel: FinancialMovimentViewModel(database: .init()))
                    } label: {
                        DashBoardCard(text: "Gráfico", image: "chart.bar.fill")
                    }
                    NavigationLink {
                        FinancialMovement(viewModel: viewModel)
                    } label: {
                        DashBoardCard(text: "Extrato", image: "dollarsign.circle")
                    }
                    NavigationLink {
                        
                    } label: {
                        DashBoardCard(text: "Críticos", image: "hazardsign.fill")
                    }
                    NavigationLink {
                        PerfilView()
                    } label: {
                        DashBoardCard(text: "Perfil",
                                      image: "person.crop.circle")
                    }
                    NavigationLink {
                        
                    } label: {
                        DashBoardCard(text: "Gráfico", image: "swift")
                    }
                }
                .padding(24)
            }
            .frame(height: 120)
            Text("Gráfico de montante por dia no mês")
            Spacer()
        }
        .navigationTitle("Dashboard")
        .onAppear(perform: {
            viewModel.fetch()
        })
    }
}

#Preview {
    NavigationStack{
        Dashboard()
    }
}
