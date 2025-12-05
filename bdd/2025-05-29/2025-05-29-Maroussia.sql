ALTER TABLE ReservationPlanning
    ADD idResadetails VARCHAR2(100);

ALTER TABLE ReservationPlanning
    ADD CONSTRAINT fk_idResadetails
        FOREIGN KEY (idResadetails)
            REFERENCES ReservationDetails (id);