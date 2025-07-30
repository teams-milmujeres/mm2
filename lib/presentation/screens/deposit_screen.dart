import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/deposits/deposits_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/refunds/refunds_bloc.dart';
// Entities
import 'package:milmujeres_app/domain/entities/deposit.dart';
import 'package:milmujeres_app/domain/entities/refund.dart';
// Localization
import 'package:milmujeres_app/l10n/app_localizations.dart';
// Other imports
import 'package:intl/intl.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(translation.payments_refunds),
          bottom: TabBar(
            tabs: [
              Tab(text: translation.payments),
              Tab(text: translation.refunds),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildDeposits(context), _buildRefunds(context)],
        ),
      ),
    );
  }

  Widget _buildDeposits(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Scaffold(
          appBar: AppBar(title: Text(translation.payments_refunds)),
          body: Center(child: Text(translation.no_elements)),
        ),
      );
    }

    final String clientId = authState.user.id.toString();

    return BlocProvider(
      create: (_) => DepositsBloc()..add(GetDepositsEvent(clientId)),
      child: BlocBuilder<DepositsBloc, DepositsState>(
        builder: (context, state) {
          if (state is DepositsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DepositsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is DepositsSuccess) {
            if (state.deposits.isEmpty) {
              return Center(child: Text(translation.no_elements));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(8.0),
              separatorBuilder: (_, __) => const SizedBox.shrink(),
              itemCount: state.deposits.length,
              itemBuilder: (context, index) {
                final deposit = state.deposits[index];
                return DepositCard(
                  deposit: deposit,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DepositDetailsScreen(deposit: deposit),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildRefunds(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;

    // Validar que el usuario esté autenticado
    if (authState is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(translation.caases_stage)),
        body: Center(child: Text(translation.no_elements)),
      );
    }

    final String clientId = authState.user.id.toString();

    return BlocProvider(
      create:
          (_) =>
              RefundsBloc()..add(
                GetRefundsEvent(clientId),
              ), // asumimos que existe este evento
      child: BlocBuilder<RefundsBloc, RefundsState>(
        builder: (context, state) {
          if (state is RefundsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RefundsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is RefundsSuccess) {
            if (state.refunds.isEmpty) {
              return Center(child: Text(translation.no_elements));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8.0),
              separatorBuilder: (_, __) => const SizedBox.shrink(),
              itemCount: state.refunds.length,
              itemBuilder: (context, index) {
                final refund = state.refunds[index];
                return RefundCard(
                  refund: refund,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RefundDetailsScreen(refund: refund),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

final f = NumberFormat("#,##0.00", "en_US");

class DepositCard extends StatelessWidget {
  final dynamic deposit;
  final VoidCallback onTap;

  const DepositCard({super.key, required this.deposit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final createdAt =
        DateTime.tryParse(deposit.createdAt ?? '') ?? DateTime.now();
    final formattedDate =
        '${createdAt.month}/${createdAt.day}/${createdAt.year}';
    final f = NumberFormat("###,##0.00", "en_EN");
    final amount = f.format(double.tryParse(deposit.mmFees.toString()) ?? 0);
    //final translation = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información principal (oficina y método)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deposit.office?['name'] ?? 'Sin oficina',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deposit.paymentMethod?['name'] ?? 'Sin método de pago',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$$amount",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    // IconButton(
                    //   icon: const Icon(Icons.search),
                    //   onPressed: onTap,
                    //   tooltip: translation.see_details,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RefundCard extends StatelessWidget {
  final dynamic refund;
  final VoidCallback? onTap;

  const RefundCard({super.key, required this.refund, this.onTap});

  @override
  Widget build(BuildContext context) {
    final createdAt =
        DateTime.tryParse(refund.createdAt ?? '') ?? DateTime.now();
    final formattedDate =
        '${createdAt.month}/${createdAt.day}/${createdAt.year}';
    final f = NumberFormat("###,##0.00", "en_EN");
    final amount = f.format(double.tryParse(refund.amount.toString()) ?? 0);

    final translation = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda: oficina, autorizado por, fecha
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        refund.office?['name'] ?? 'Sin oficina',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${translation.authorized_by}: ',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              refund.authorizedBy ?? 'N/A',
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                // Columna derecha: monto
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "- \$$amount",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DepositDetailsScreen extends StatelessWidget {
  const DepositDetailsScreen({super.key, required this.deposit});

  final Deposit deposit;

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final f = NumberFormat("###,##0.00", "en_EN");
    final amount = f.format(double.parse(deposit.mmFees.toString()));

    return Scaffold(
      appBar: AppBar(title: Text(translation.deposit)),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1024),
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            children: [
              DetailTile(
                title: translation.office,
                value: deposit.office?['name'],
              ),
              DetailTile(
                title: translation.mm_fees,
                value: "\$$amount",
                valueColor: Colors.teal,
              ),
              DetailTile(
                title: translation.payment_method,
                value: deposit.paymentMethod?['name'],
              ),
              DetailTile(
                title: translation.note_or_service_paid,
                value:
                    deposit.notesOrServicesPaid.isNotEmpty
                        ? deposit.notesOrServicesPaid
                        : '—',
              ),
              DetailTile(
                title: translation.deposit_type,
                value: deposit.depositType?['name'],
              ),
              if (deposit.creditCardPersonName.isNotEmpty)
                DetailTile(
                  title: translation.credit_card_person_name,
                  value: deposit.creditCardPersonName,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RefundDetailsScreen extends StatelessWidget {
  const RefundDetailsScreen({super.key, required this.refund});

  final Refund refund;

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final f = NumberFormat("###,##0.00", "en_EN");
    final amount = f.format(double.parse(refund.amount.toString()));

    return Scaffold(
      appBar: AppBar(title: Text(translate.refund)),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1024),
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            children: [
              DetailTile(
                title: translate.office,
                value: refund.office?['name'],
              ),
              if (refund.amount.isNotEmpty)
                DetailTile(
                  title: translate.amount,
                  value: "- \$$amount",
                  valueColor: Colors.red,
                ),
              DetailTile(
                title: translate.date_send,
                value: refund.dateSent.isNotEmpty ? refund.dateSent : '—',
              ),
              DetailTile(
                title: translate.authorized_by,
                value: refund.authorizedBy?['name'],
              ),
              DetailTile(
                title: translate.send_by,
                value: refund.sentBy.isNotEmpty ? refund.sentBy : '—',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  final String title;
  final String? value;
  final Color? valueColor;

  const DetailTile({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      title: Text(title, style: textTheme.bodyLarge),
      subtitle: Text(
        value ?? 'N/A',
        style: textTheme.bodyMedium?.copyWith(
          color: valueColor ?? textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}
