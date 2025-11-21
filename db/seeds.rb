puts "🧹 Cleaning the database..."
Message.destroy_all
Report.destroy_all
Conversation.destroy_all
Interview.destroy_all
User.destroy_all

puts "👤 Creation of users..."
users = []
10.times do
  users << User.create!(
    email: Faker::Internet.email,
    password: "password123",
    role: ["Developer", "Designer", "Manager"].sample,
    experience: "#{rand(1..10)} ans",
    techstack: ["Ruby", "JavaScript", "Python"].sample
  )
end
puts "✅ #{users.count} users created"

puts "Creation of interviews..."
interviews_data = interviews_data = [
  {
    target_role: "Backend Developer",
    seniority: "Senior",
    language: "Ruby on Rails",
    category: "Technical",
    body: "A comprehensive backend interview focusing on Ruby on Rails, system design, and API architecture.",
    questions: "1. Can you explain how Rails' MVC architecture works and why it's beneficial?\n2. How would you optimize a slow database query in a Rails application?\n3. Describe how you would design a RESTful API for a booking system."
  },

  {
    target_role: "Frontend Developer",
    seniority: "Mid-level",
    language: "React",
    category: "Technical",
    body: "Technical interview covering React, state management, and modern frontend practices.",
    questions: "1. Explain the difference between state and props in React.\n2. How would you optimize performance in a React application?\n3. Describe your approach to state management in a complex React app.\n4. How do you handle API calls and async operations in React?\n5. What is your testing strategy for React components?\n6. Explain the React component lifecycle and hooks.\n7. How do you handle forms and validation in React?\n8. Describe your approach to CSS and styling in React applications.\n9. How would you implement code splitting and lazy loading?\n10. What are your strategies for accessibility in React applications?"
  },

  {
    target_role: "Backend Developer",
    seniority: "Senior",
    language: "General",
    category: "Behavioral",
    body: "Behavioral interview assessing leadership, problem-solving, and communication skills for senior backend developers.",
    questions: "1. Tell me about a time when you had to make a critical architectural decision under pressure.\n2. Describe a situation where you had to debug a complex production issue.\n3. Tell me about a time when you disagreed with a technical approach proposed by your team.\n4. Give an example of when you mentored a junior developer. What was the outcome?\n5. Describe a situation where you had to balance technical debt with feature delivery.\n6. Tell me about a time when you had to learn a new technology quickly for a project.\n7. Describe a challenging code review you conducted. How did you provide feedback?\n8. Tell me about a time when you improved system performance or scalability.\n9. Give an example of how you have handled conflicting priorities from different stakeholders.\n10. Describe a project where you had to work with cross-functional teams."
  },

  {
    target_role: "Frontend Developer",
    seniority: "Mid-level",
    language: "General",
    category: "Behavioral",
    body: "Behavioral interview assessing collaboration, user focus, and problem-solving for frontend developers.",
    questions: "1. Tell me about a time when you had to work with a difficult team member.\n2. Describe a situation where you had to balance user experience with technical constraints.\n3. Tell me about a time when you received critical feedback on your UI implementation.\n4. Give an example of when you advocated for better user experience or accessibility.\n5. Describe a situation where you had to optimize a slow-loading web application.\n6. Tell me about a time when you had to explain technical trade-offs to a designer.\n7. Describe a project where you had to learn a new framework or library quickly.\n8. Tell me about a time when you disagreed with a design decision.\n9. Give an example of how you have handled browser compatibility issues.\n10. Describe a situation where you improved the frontend development workflow."
  },

  {
    target_role: "DevOps Engineer",
    seniority: "Senior",
    language: "Python",
    category: "Technical",
    body: "Technical interview focusing on CI/CD, containerization, and infrastructure as code.",
    questions: "1. Explain your approach to setting up a CI/CD pipeline from scratch.\n2. How would you troubleshoot a production outage?\n3. Describe your experience with container orchestration using Kubernetes.\n4. What is your strategy for infrastructure monitoring and alerting?\n5. How do you handle secrets management in a production environment?\n6. Explain your approach to disaster recovery and backup strategies.\n7. How would you implement blue-green deployments?\n8. Describe your experience with infrastructure as code (Terraform/CloudFormation).\n9. How do you ensure security in your CI/CD pipeline?\n10. What is your approach to cost optimization in cloud infrastructure?"
  },

  {
    target_role: "Junior Developer",
    seniority: "Junior",
    language: "General",
    category: "Behavioral",
    body: "Behavioral interview assessing learning ability, collaboration, and growth mindset for entry-level developers.",
    questions: "1. Tell me about a challenging project you worked on during your studies or bootcamp.\n2. How do you approach learning a new programming concept or technology?\n3. Describe a time when you received constructive feedback. How did you respond?\n4. Tell me about a time when you got stuck on a problem. How did you solve it?\n5. Why are you interested in becoming a software developer?\n6. Describe a time when you had to work in a team on a coding project.\n7. Tell me about a mistake you made while coding. What did you learn?\n8. How do you stay updated with new technologies and programming trends?\n9. Describe a time when you had to explain your code to someone else.\n10. What motivates you to keep learning and improving as a developer?"
  },

  {
    target_role: "Full Stack Developer",
    seniority: "Mid-level",
    language: "JavaScript",
    category: "Technical",
    body: "Technical interview covering both frontend and backend development with JavaScript/Node.js.",
    questions: "1. Explain the difference between authentication and authorization.\n2. How would you structure a REST API for a social media application?\n3. Describe your approach to handling asynchronous operations in JavaScript.\n4. What is your strategy for ensuring web application security?\n5. How do you optimize both frontend and backend performance?\n6. Explain how you would implement real-time features in a web application.\n7. Describe your database design approach for a scalable application.\n8. How do you handle error handling across the full stack?\n9. What is your testing strategy for full stack applications?\n10. How would you deploy and monitor a full stack application in production?"
  },

  {
    target_role: "Data Engineer",
    seniority: "Senior",
    language: "Python",
    category: "Technical",
    body: "Technical interview focusing on data pipelines, ETL processes, and big data technologies.",
    questions: "1. Describe your approach to designing a data pipeline for processing millions of records.\n2. How would you handle data quality and validation in an ETL process?\n3. Explain your experience with distributed computing frameworks like Spark.\n4. How do you optimize query performance in data warehouses?\n5. Describe your approach to real-time data processing.\n6. How would you design a data model for analytics purposes?\n7. Explain your strategy for data versioning and lineage tracking.\n8. How do you handle schema changes in production data pipelines?\n9. Describe your experience with cloud data platforms (AWS/GCP/Azure).\n10. What is your approach to monitoring and debugging data pipelines?"
  },

  {
    target_role: "Product Manager",
    seniority: "Senior",
    language: "General",
    category: "Behavioral",
    body: "Behavioral interview assessing product strategy, stakeholder management, and decision-making.",
    questions: "1. Tell me about a time when you had to prioritize features with limited resources.\n2. Describe a situation where you had to make a decision with incomplete data.\n3. Tell me about a product launch that did not go as planned. What did you learn?\n4. Give an example of how you have handled conflicting feedback from stakeholders.\n5. Describe a time when you had to say no to a feature request. How did you communicate it?\n6. Tell me about a time when you championed a controversial product decision.\n7. Describe how you have used data to drive product decisions.\n8. Tell me about a time when you had to work with a difficult engineering team.\n9. Give an example of how you have balanced user needs with business goals.\n10. Describe a situation where you had to pivot a product strategy."
  },

  {
    target_role: "Mobile Developer",
    seniority: "Mid-level",
    language: "React Native",
    category: "Technical",
    body: "Technical interview covering mobile development, React Native, and mobile best practices.",
    questions: "1. Explain the difference between React and React Native.\n2. How do you handle navigation in React Native applications?\n3. Describe your approach to optimizing mobile app performance.\n4. How do you handle offline functionality in mobile apps?\n5. Explain your strategy for managing app state in React Native.\n6. How do you handle push notifications in mobile applications?\n7. Describe your approach to testing mobile applications.\n8. How do you handle different screen sizes and orientations?\n9. Explain your experience with native modules and bridging.\n10. What is your strategy for app deployment and updates?"
  }
]

interviews = interviews_data.map { |interview_data| Interview.create!(interview_data) }

puts "#{interviews.count} interviews created"

puts " creation of conversations..."

conversations = []
users.each_with_index do |user, index|
  conversations << Conversation.create!(
    user: user,
    interview: interviews.sample
  )
end

puts "#{conversations.count} conversations created"

puts "Creation of messages..."
conversations.each do |conversation|
  3.times do |i|
    Message.create!(
      conversation: conversation,
      content: "Message #{i + 1} of the conversation",
      role: i.even? ? "user" : "assistant"
    )
  end
end
puts "Messages created"

puts "rapport creation..."
conversations.each do |conversation|
  Report.create!(
    conversation: conversation,
  )
end
puts "Reports created"

puts "Seeds created !"
