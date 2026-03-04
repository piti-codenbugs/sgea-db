INSERT INTO public.usuario(
    id_usuario, id_rol, email, password_hash, nombres, apellidos, fecha_registro, activo)
VALUES (
    -1,
    1,
    'admin1@test.com',
    '$2a$10$9SsBzH2jnAP6q8C1vMpB3u0.cKoBjPMSD5QkvmN1Pl/90hZoNj4P.',
    'admin1',
    'admin1',
    '2026-03-02 08:37:05.610083',
    true
),
(
    -2,
    2,  
    'estudiante1@test.com',
    '$2a$10$9SsBzH2jnAP6q8C1vMpB3u0.cKoBjPMSD5QkvmN1Pl/90hZoNj4P.',
    'Estudiante',
    'Prueba',
    '2026-03-04 08:00:00.000000',
    true
),
(
    -3,
    3, 
    'docente1@test.com',
    '$2a$10$9SsBzH2jnAP6q8C1vMpB3u0.cKoBjPMSD5QkvmN1Pl/90hZoNj4P.',
    'Docente',
    'Prueba',
    '2026-03-04 08:00:00.000000',
    true
);

INSERT INTO public.docente(
	id_usuario)
	VALUES (-3);

INSERT INTO public.estudiante(
	id_usuario, carnet)
	VALUES (-2, 200000002);
