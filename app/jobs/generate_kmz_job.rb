class GenerateKmzJob < ApplicationJob
  queue_as :default

  def perform(project_id)
    project = Project.find(project_id)
    project.generate_kml
    project.download_project
    project.generate_kmz
    project.cleanup
  end
end
