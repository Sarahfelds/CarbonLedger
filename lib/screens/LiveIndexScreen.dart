import 'package:flutter/material.dart';

class LiveIndexScreen extends StatefulWidget {
  @override
  _LiveIndexScreenState createState() => _LiveIndexScreenState();
}

class _LiveIndexScreenState extends State<LiveIndexScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Bottom navigation item tapped: $index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Greenhouse Gas Emissions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildLiveBanner(context),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 3 : 1) - 24,
                    child: _buildScenarioCard(
                      context,
                      'Hydro-only Scenario',
                      '3.93',
                      'MtCO₂e',
                      'assets/hydro_icon.png',
                      'Best case: Greenhouse gas emissions assuming Bitcoin miners rely exclusively on hydroelectric power.',
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 3 : 1) - 24,
                    child: _buildEstimatedCard(
                      context,
                      'Estimated',
                      '94.85',
                      'MtCO₂e',
                      'Annualised emissions',
                      'assets/power_icon.png',
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 3 : 1) - 24,
                    child: _buildScenarioCard(
                      context,
                      'Coal-only Scenario',
                      '187.38',
                      'MtCO₂e',
                      'assets/coal_icon.png',
                      'Worst case: Greenhouse gas emissions assuming Bitcoin miners rely exclusively on coal power.',
                    ),
                  ),
                ],
              ),

              _buildLiveBanner2(context),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 3 : 1) - 24,
                    child: _buildScenarioCard(
                      context,
                      'Hydro-only Scenario',
                      '3.93',
                      'MtCO₂e',
                      'assets/hydro_icon.png',
                      'Best case: Greenhouse gas emissions assuming Bitcoin miners rely exclusively on hydroelectric power.',
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 3 : 1) - 24,
                    child: _buildEstimatedCard(
                      context,
                      'Estimated',
                      '94.85',
                      'MtCO₂e',
                      'Annualised emissions',
                      'assets/power_icon.png',
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 3 : 1) - 24,
                    child: _buildScenarioCard(
                      context,
                      'Coal-only Scenario',
                      '187.38',
                      'MtCO₂e',
                      'assets/coal_icon.png',
                      'Worst case: Greenhouse gas emissions assuming Bitcoin miners rely exclusively on coal power.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Color(0xFFFDCB00),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0)),
          ),
          SizedBox(height: 8.0),
          Text('Bitcoin greenhouse gas emissions', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh, size: 14, color: Colors.grey[600]),
              SizedBox(width: 4.0),
              Text('updated every 24 hours', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildLiveBanner2(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Color(0xFFFDCB00),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0)),
          ),
          SizedBox(height: 8.0),
          Text('Ethereum greenhouse gas emissions', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh, size: 14, color: Colors.grey[600]),
              SizedBox(width: 4.0),
              Text('updated every 24 hours', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, String title, String value, String unit, String iconPath, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            SizedBox(height: 16),
            Text(value, style: Theme.of(context).textTheme.headlineLarge),
            Text(unit, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            Image.asset(iconPath, height: 48, width: 48),
            SizedBox(height: 16),
            Text(description, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimatedCard(BuildContext context, String title, String value, String unit, String subUnit, String iconPath) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(width: 4),
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
              ],
            ),
            SizedBox(height: 16),
            Text(value, style: Theme.of(context).textTheme.headlineLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(unit, style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(width: 4),
                Icon(Icons.help_outline, size: 16, color: Colors.grey),
              ],
            ),
            if (subUnit.isNotEmpty)
              Text(subUnit, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 16),
            Image.asset(iconPath, height: 48, width: 48),
            SizedBox(height: 16),
            Text(
              'Best guess: Greenhouse gas emissions assuming Bitcoin miners rely on a variety of different energy sources.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
