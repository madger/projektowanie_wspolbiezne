-- phpMyAdmin SQL Dump
-- version 4.0.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Czas wygenerowania: 30 Kwi 2014, 01:47
-- Wersja serwera: 5.6.12-log
-- Wersja PHP: 5.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Baza danych: `projektowanie_wspolbiezne`
--
CREATE DATABASE IF NOT EXISTS `projektowanie_wspolbiezne` DEFAULT CHARACTER SET utf8 COLLATE utf8_polish_ci;
USE `projektowanie_wspolbiezne`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `departaments`
--

CREATE TABLE IF NOT EXISTS `departaments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf16 COLLATE utf16_polish_ci NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=5 ;

--
-- Zrzut danych tabeli `departaments`
--

INSERT INTO `departaments` (`id`, `name`, `created`) VALUES
(1, 'Dział projektów', '2014-04-29 21:47:23'),
(2, 'Dział wdrożeń', '2014-04-29 21:47:37'),
(3, 'Dział produkcji', '2014-04-29 21:47:54'),
(4, 'Dział testów', '2014-04-29 21:48:03');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tasks`
--

CREATE TABLE IF NOT EXISTS `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `departament_id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_polish_ci NOT NULL,
  `description` varchar(200) COLLATE utf8_polish_ci NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=12 ;

--
-- Zrzut danych tabeli `tasks`
--

INSERT INTO `tasks` (`id`, `user_id`, `departament_id`, `name`, `description`, `status`, `created`) VALUES
(1, 1, 1, 'Zadanie 1', 'Zaprojektowanie kubka', 5, '2014-04-29 22:25:31'),
(2, 1, 1, 'Podzadanie 1.1', 'Zaprojektowanie obudowy', 5, '2014-04-29 23:00:55'),
(3, 1, 1, 'Podzadanie 1.2', 'Zaprojektowanie uchwytu', 5, '2014-04-29 23:01:10'),
(5, 1, 1, 'Zadanie 2', 'Zaprojektowanie linii produkcyjnej', 4, '2014-04-29 23:33:41'),
(6, 1, 2, 'Zadanie 3', 'Wdrożenie linii produkcyjnej', 3, '2014-04-29 23:39:32'),
(7, 1, 3, 'Zadanie 4', 'Produkcja kubka', 2, '2014-04-29 23:49:29'),
(8, 1, 3, 'Podzadanie 4.1', 'Produkcja obudowy', 2, '2014-04-29 23:49:59'),
(9, 1, 3, 'Podzadanie 4.2', 'Produkcja i przytwierdzenie dna', 2, '2014-04-29 23:50:27'),
(10, 1, 3, 'Podzadanie 4.3', 'Produkcja i przytwierdzenie uchytu', 2, '2014-04-29 23:50:46'),
(11, 1, 4, 'Zadanie 5', 'Przetestowanie produktu', 1, '2014-04-29 23:55:16');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tasks_dependent_tasks`
--

CREATE TABLE IF NOT EXISTS `tasks_dependent_tasks` (
  `task_id` int(11) NOT NULL,
  `dependent_task_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `tasks_dependent_tasks`
--

INSERT INTO `tasks_dependent_tasks` (`task_id`, `dependent_task_id`) VALUES
(1, 5),
(5, 6),
(6, 7),
(8, 9),
(8, 10),
(7, 11);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tasks_subtasks`
--

CREATE TABLE IF NOT EXISTS `tasks_subtasks` (
  `task_id` int(11) NOT NULL,
  `subtask_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `tasks_subtasks`
--

INSERT INTO `tasks_subtasks` (`task_id`, `subtask_id`) VALUES
(1, 2),
(1, 3),
(1, 4),
(7, 8),
(7, 9),
(7, 10);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) CHARACTER SET utf16 COLLATE utf16_polish_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf16 COLLATE utf16_polish_ci NOT NULL,
  `first_name` varchar(100) CHARACTER SET utf16 COLLATE utf16_polish_ci NOT NULL,
  `last_name` varchar(100) CHARACTER SET utf16 COLLATE utf16_polish_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf16 COLLATE utf16_polish_ci NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=2 ;

--
-- Zrzut danych tabeli `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `first_name`, `last_name`, `email`, `created`) VALUES
(1, 'corvus', 'pass', 'Maciej', 'Świątek', 'corvus.coelestis@gmail.com', '2014-04-29 21:14:15');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
