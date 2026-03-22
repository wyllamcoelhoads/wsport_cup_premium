import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../world_cup/presentation/pages/world_cup_page.dart'; // Sua tela principal

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Aponta para o seu vídeo nos assets
    _controller = VideoPlayerController.asset('assets/videos/splashAnimada.mp4')
      ..initialize().then((_) {
        // Quando carregar, dá o play e atualiza a tela
        setState(() {});
        _controller.play();
      });

    // Fica escutando o vídeo. Quando chegar no fim, navega para a Home
    _controller.addListener(_onVideoProgress);
  }

  void _onVideoProgress() {
    if (_controller.value.position >= _controller.value.duration &&
        _controller.value.duration >= Duration.zero) {
      _controller.removeListener(_onVideoProgress); // agora funciona!
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    // Navega para a WorldCupPage substituindo a tela de splash (para o usuário não conseguir voltar para o vídeo)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WorldCupPage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto enquanto o vídeo carrega
      body: Center(
        child: _controller.value.isInitialized
            ? SizedBox.expand(
                // Faz o vídeo cobrir a tela inteira (opcional)
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : const CircularProgressIndicator(color: Colors.amber),
      ),
    );
  }
}
