run "deploy" {
  command = apply
}

run "validate" {
  command = apply

  module {
    source = "../../modules/test-endpoint"
  }

  variables {
    # Attention : vérifiez que le nom de l'output correspond bien à celui défini dans votre main.tf
    # Si vous avez utilisé mon code Azure précédent, c'était "function_url" et pas "api_endpoint"
    endpoint = run.deploy.api_endpoint
  }

  assert {
    condition     = data.http.test_endpoint.status_code == 200
    error_message = "Unexpected status code: ${data.http.test_endpoint.status_code}"
  }

  assert {
    condition     = data.http.test_endpoint.response_body == "Hello, World!"
    error_message = "Unexpected response body: ${data.http.test_endpoint.response_body}"
  }
}
