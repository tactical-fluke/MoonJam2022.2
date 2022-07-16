extends StaticBody2D

func handle_projectile(projectile, _damage):
	projectile.queue_free()
