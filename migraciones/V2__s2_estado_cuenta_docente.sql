ALTER TABLE public.docente
	ADD COLUMN estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE'
	CHECK (estado IN('PENDIENTE','APROBADO', 'RECHAZADO'));

CREATE TABLE estado_cuenta(
	id_estado BIGSERIAL PRIMARY KEY,
	id_admin_fk BIGINT,
	id_docente_fk BIGINT NOT NULL,
	estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE' 
		CHECK(estado IN('PENDIENTE','APROBADO','RECHAZADO')),
	comentario TEXT,
	fecha TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_estado_docente FOREIGN KEY (id_docente_fk) REFERENCES docente(id_usuario),
	CONSTRAINT fk_estado_admin FOREIGN KEY (id_admin_fk) REFERENCES usuario(id_usuario)
);
