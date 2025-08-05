import 'package:flutter/material.dart';

class Form6ProgressBar extends StatelessWidget {
  final bool isOtherComplete;
  final bool isSampleDetailsComplete;
  final bool isPreservativeInfoComplete;
  final bool isSealInfoComplete;
  final bool isFinalReviewComplete;

  final VoidCallback? onOtherInfoTap;
  final VoidCallback? onSampleDetailsTap;
  final VoidCallback? onPreservativeTap;
  final VoidCallback? onSealTap;
  final VoidCallback? onFinalReviewTap;

  const Form6ProgressBar({
    super.key,
    required this.isOtherComplete,
    required this.isSampleDetailsComplete,
    required this.isPreservativeInfoComplete,
    required this.isSealInfoComplete,
    required this.isFinalReviewComplete,
    this.onOtherInfoTap,
    this.onSampleDetailsTap,
    this.onPreservativeTap,
    this.onSealTap,
    this.onFinalReviewTap,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStep(
          indicator: _AnimatedStepIcon(isComplete: isOtherComplete),
          title: "Other Info",
          completed: isOtherComplete,
          onTap: onOtherInfoTap,
        ),
        _buildConnectorLine(isComplete: isSampleDetailsComplete),
        _buildStep(
          indicator: _AnimatedStepIcon(isComplete: isSampleDetailsComplete),
          title: "Sample Details",
          completed: isSampleDetailsComplete,
          onTap: onSampleDetailsTap,
        ),
        _buildConnectorLine(isComplete: isPreservativeInfoComplete),
        _buildStep(
          indicator: _AnimatedSmallDot(isComplete: isPreservativeInfoComplete),
          title: "Preservative Info",
          completed: isPreservativeInfoComplete,
          isSubStep: true,
          onTap: onPreservativeTap,
        ),
        _buildConnectorLine(isComplete: isSealInfoComplete),
        _buildStep(
          indicator: _AnimatedSmallDot(isComplete: isSealInfoComplete),
          title: "Seal Info",
          completed: isSealInfoComplete,
          isSubStep: true,
          onTap: onSealTap,
        ),
        _buildConnectorLine(isComplete: isFinalReviewComplete),
        _buildStep(
          indicator: _AnimatedStepIcon(isComplete: isFinalReviewComplete),
          title: "Final Review",
          completed: isFinalReviewComplete,
          onTap: onFinalReviewTap,
        ),
      ],
    );
  }

  Widget _buildStep({
    required Widget indicator,
    required String title,
    required bool completed,
    bool isSubStep = false,
    VoidCallback? onTap,
  }) {
    final textWidget = Padding(
      padding: EdgeInsets.only(top: isSubStep ? 2 : 4),
      child: AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 300),
        style: TextStyle(
          fontSize: isSubStep ? 13 : 16,
          fontWeight: isSubStep ? FontWeight.normal : FontWeight.w600,
          color: completed ? Colors.green : Colors.black54,
        ),
        child: Text(title),
      ),
    );

    return InkWell(
      onTap: onTap,
      splashColor: Colors.green.withOpacity(0.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 24, child: Center(child: indicator)),
          const SizedBox(width: 12),
          textWidget,
        ],
      ),
    );
  }


  Widget _buildConnectorLine({required bool isComplete}) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: 2,
              height: 40,
              color: isComplete ? Colors.green : Colors.grey.shade400,
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

class _AnimatedStepIcon extends StatelessWidget {
  final bool isComplete;

  const _AnimatedStepIcon({super.key, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
      child: CircleAvatar(
        key: ValueKey(isComplete),
        radius: 12,
        backgroundColor: isComplete ? Colors.green : Colors.grey.shade300,
        child: Icon(
          isComplete ? Icons.check : Icons.circle_outlined,
          size: 16,
          color: isComplete ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}

class _AnimatedSmallDot extends StatelessWidget {
  final bool isComplete;

  const _AnimatedSmallDot({super.key, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isComplete ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
