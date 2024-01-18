-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mer. 22 nov. 2023 à 20:20
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `templatev2`
--

-- --------------------------------------------------------

--
-- Structure de la table `playlist_boombox`
--

CREATE TABLE `playlist_boombox` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `url` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `playlist_boombox`
--

INSERT INTO `playlist_boombox` (`id`, `identifier`, `nom`, `url`) VALUES
(7, 'a023603b196b40b4a683b77429127786974fefc1', 'Lewis Capaldi - Someone You Loved', 'https://www.youtube.com/watch?v=zABLecsR5UE&list=RD0hBYyKf17FE&index=5');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `playlist_boombox`
--
ALTER TABLE `playlist_boombox`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `playlist_boombox`
--
ALTER TABLE `playlist_boombox`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
