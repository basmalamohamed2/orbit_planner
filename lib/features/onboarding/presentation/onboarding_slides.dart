enum OnboardingArtKind { sun, orbits, stars }

class OnboardingSlide {
  const OnboardingSlide({
    required this.title,
    required this.body,
    required this.art,
  });

  final String title;
  final String body;
  final OnboardingArtKind art;
}

const onboardingSlides = <OnboardingSlide>[
  OnboardingSlide(
    title: 'You are the sun',
    body:
        'Every task is a planet that orbits around you. '
        'The bigger the planet, the more it matters.',
    art: OnboardingArtKind.sun,
  ),
  OnboardingSlide(
    title: 'Time is gravity',
    body:
        'As a deadline gets closer, its planet drifts closer to you. '
        'Distant tasks wait quietly in the outer orbit.',
    art: OnboardingArtKind.orbits,
  ),
  OnboardingSlide(
    title: 'Finish and shine',
    body:
        'Complete a task and its planet becomes a star in your sky. '
        'Your notes stay close as tiny moons.',
    art: OnboardingArtKind.stars,
  ),
];
