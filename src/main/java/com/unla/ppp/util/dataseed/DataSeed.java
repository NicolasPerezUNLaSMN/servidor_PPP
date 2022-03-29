package com.unla.ppp.util.dataseed;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;


import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@AllArgsConstructor
public class DataSeed implements CommandLineRunner{

	private final DataSeedUsuarios dataSeedUsuarios;
	private final DataSeedIntervenciones dataSeedIntervenciones;
	@Override
	public void run(String... args) throws Exception {
		log.info("Data seed start");
		dataSeedUsuarios.loadData();
		dataSeedIntervenciones.loadData();
		log.info("Data seed finish");
	}
}
