import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_23/service/auth/auth_exceptions.dart';
import 'package:project_23/service/auth/bloc/auth_bloc.dart';
import 'package:project_23/service/auth/bloc/auth_event.dart';
import 'package:project_23/service/auth/bloc/auth_state.dart';
import '../utilities/dialog/error_dialog.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException ||
              state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context, 'Thông Tin Đăng Nhập Không Chính Xác');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Lỗi Xác Thực');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Xin vui lòng nhập thông tin đăng nhập để tạo và lưu trữ ghi chú!'),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Nhập Email'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'Nhập Password'),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthEventForgotPassword(),
                  );
                },
                child: const Text('Quên Mật Khẩu?'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthEventShouldRegister(),
                  );
                },
                child: const Text('Chưa Đăng Kí? Đăng Kí Ngay'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
