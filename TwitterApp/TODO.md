
1. Отделить лайки и ретвиты от сущности Tweet
   1. Сделать под каждый тип отдельное in-memory хранилище
2. Notification обработать ситуацию если NotificationType не найден
3. User followers вынести в отдельное хранилище
4. Рефакторинг ProfileHeader
5. ViewControllerFactory / Coordinators / Router
   1. makeProfileViewController(with: User) -> UIViewController
6. Di