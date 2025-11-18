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
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "password123",
    role: ["Developer", "Designer", "Manager"].sample,
    experience: "#{rand(1..10)} ans",
    techstack: ["Ruby", "JavaScript", "Python"].sample
  )
end
puts "✅ #{users.count} users created"

puts "Creation of interviews..."
interviews_data = [
  {
    body: "Technical interview for a Ruby on Rails developer position",
    target_role: "Backend Developer",
    seniority: "Mid-level",
    language: "Ruby"
  },
  {
    body: "Interview for a React developer position",
    target_role: "Frontend Developer",
    seniority: "Senior",
    language: "React"
  },
  {
    body: "Technical interview for a Python developer position",
    target_role: "Backend Developer",
    seniority: "Mid-level",
    language: "Python"
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
    content: "Analysis report #{conversation.id}",
    score: rand(60..100)
  )
end
puts "Reports created"

puts "Seeds created !"
