import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/meditation/domain/models/reminder_settings.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  // Time selection
  int selectedHour = 11;
  String selectedAmPm = "AM";
  int selectedMinute = 30;

  // Day selection
  final Set<String> selectedDays = {"SU", "M", "T", "W", "S"};
  final List<String> weekdays = ["SU", "M", "T", "W", "TH", "F", "S"];

  // Get current settings as a ReminderSettings object
  ReminderSettings get currentSettings => ReminderSettings(
        hour: selectedHour,
        minute: selectedMinute,
        amPm: selectedAmPm,
        days: selectedDays.toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'What time would you like to meditate?',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F414E),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Any time you can choose but We recommend first thing in the morning.',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFFA1A4B2),
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 30),
              _buildTimeSelector(),
              const SizedBox(height: 40),
              const Text(
                'Which day would you like to meditate?',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F414E),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Everyday is best, but we recommend picking at least five.',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFFA1A4B2),
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 30),
              _buildDaySelector(),
              const Spacer(),
              _buildBottomButtons(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Hour selector
          _buildTimeWheel(
            items: List.generate(12, (i) => (i + 1).toString()),
            selectedIndex: selectedHour - 1,
            onChanged: (index) {
              setState(() {
                selectedHour = index + 1;
              });
            },
          ),
          
          // Divider
          Container(
            width: 1,
            height: 60,
            color: const Color(0xFFE1E1E5),
          ),
          
          // Minute selector
          _buildTimeWheel(
            items: ["00", "15", "30", "45"],
            selectedIndex: [0, 15, 30, 45].indexOf(selectedMinute),
            onChanged: (index) {
              setState(() {
                selectedMinute = [0, 15, 30, 45][index];
              });
            },
          ),
          
          // Divider
          Container(
            width: 1,
            height: 60,
            color: const Color(0xFFE1E1E5),
          ),
          
          // AM/PM selector
          _buildTimeWheel(
            items: ["AM", "PM"],
            selectedIndex: selectedAmPm == "AM" ? 0 : 1,
            onChanged: (index) {
              setState(() {
                selectedAmPm = index == 0 ? "AM" : "PM";
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeWheel({
    required List<String> items,
    required int selectedIndex,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      width: 70,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        diameterRatio: 1.5,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            return Center(
              child: Text(
                items[index],
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: index == selectedIndex
                      ? const Color(0xFF263238)
                      : const Color(0xFFA1A4B2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekdays.map((day) {
        final isSelected = selectedDays.contains(day);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedDays.remove(day);
              } else {
                selectedDays.add(day);
              }
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF3F414E) : Colors.transparent,
              border: isSelected
                  ? null
                  : Border.all(
                      color: const Color(0xFFA1A4B2),
                      width: 1,
                    ),
            ),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFFA1A4B2),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 63,
                child: ElevatedButton(
                  onPressed: () {
                    // Save the reminder settings and navigate
                    Navigator.pop(context, currentSettings);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E97FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: 0.7,
                      color: Color(0xFFF6F1FB),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 63,
                child: ElevatedButton(
                  onPressed: () {
                    // Skip to home screen with current settings
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDB9D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                  child: const Text(
                    'SAVE & CONTINUE',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: 0.7,
                      color: Color(0xFF3F414E),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'NO THANKS',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 0.7,
              color: Color(0xFF3F414E),
            ),
          ),
        ),
      ],
    );
  }
} 