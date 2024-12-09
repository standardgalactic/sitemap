#!/bin/bash

# Iterate through all directories in the current folder
for dir in */; do
	  # Check if it's a Git repository
	    if [ -d "$dir/.git" ]; then
		        echo "Directory: $dir"
			    cd "$dir" || { echo "Failed to enter $dir"; continue; }

			        # Check if it's a GitHub repository by checking remote URL
				    remote_url=$(git remote get-url origin 2>/dev/null)
				        if [[ $remote_url == *github.com* ]]; then
						      echo "Remote URL: $remote_url"

						            # Get fork information using GitHub API (requires `jq` for parsing JSON)
							          if command -v jq &>/dev/null; then
									          repo_name=$(echo "$remote_url" | sed -E 's/.*github.com[:\/]([^\/]+\/[^\/]+)\.git/\1/')
										          fork_info=$(curl -s "https://api.github.com/repos/$repo_name" | jq '.fork, .parent.full_name?' 2>/dev/null)
											          echo "Fork Info: $fork_info"
												        else
														        echo "Install jq to get fork info via GitHub API."
															      fi

															            # Get default branch name (fallback if symbolic ref doesn't work)
																          default_branch=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')
																	        echo "Default Branch: $default_branch"
																		    else
																			          echo "Not a GitHub repository."
																				      fi

																				          # Return to the parent directory
																					      cd .. || continue
																					        else
																							    echo "$dir is not a Git repository."
																							      fi
																							        echo "--------------------"
																							done

