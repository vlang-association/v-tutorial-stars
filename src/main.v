module main

import net.http
import json
import mewzax.chalk

const (
	github_repositories_url = 'https://api.github.com/search/repositories?sort=stars&order=desc&q=language:v'
)

struct GitHubRepositoriesItem {
pub:
	full_name        string
	description      string
	stargazers_count int
	html_url         string
}

struct GitHubRepositoriesSearchAPI {
pub:
	total_count int
	items       []GitHubRepositoriesItem
}

fn main() {
	// TODO: Add comments
	response := http.get(github_repositories_url)!

	repositories_result := json.decode(GitHubRepositoriesSearchAPI, response.body) or {
		panic('An error occurred during JSON parsing: ${err}')
	}

	println('The total star count is ${repositories_result.total_count}')

	for index, repository in repositories_result.items {
		colored_description := chalk.fg(repository.description, 'cyan')
		colored_star_count := chalk.fg(repository.stargazers_count.str(), 'green')

		println('#${index + 1} ${repository.full_name}')
		println('  URL: ${repository.html_url}')

		if repository.description != '' {
			println('  Description: ${colored_description}')
		}

		println('  Star count: ${colored_star_count}')
	}
}
