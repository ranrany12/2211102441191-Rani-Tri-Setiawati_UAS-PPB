import 'package:scoped_model/scoped_model.dart';

import './services.dart';
import './user_service.dart';

class MainModel extends Model with Services, UserService {}
