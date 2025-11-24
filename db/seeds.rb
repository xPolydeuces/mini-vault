# Clean up existing data
PaintingBatchModelSet.destroy_all
PaintingBatch.destroy_all
TodoItem.destroy_all
ModelSet.destroy_all
Faction.destroy_all
Series.destroy_all

puts "Creating series..."

wh40k = Series.create!(name: "Warhammer 40,000")
aos = Series.create!(name: "Age of Sigmar")
malifaux = Series.create!(name: "Malifaux")

puts "Creating factions..."

# 40K Factions
space_marines = Faction.create!(series: wh40k, name: "Space Marines")
orks = Faction.create!(series: wh40k, name: "Orks")
tyranids = Faction.create!(series: wh40k, name: "Tyranids")

# AoS Factions
skaven = Faction.create!(series: aos, name: "Skaven")
stormcast = Faction.create!(series: aos, name: "Stormcast Eternals")

puts "Creating model sets..."

# Space Marines
intercessors = ModelSet.create!(
  series: wh40k,
  faction: space_marines,
  name: "Intercessor Squad",
  total_models: 10,
  on_sprue: 10,
  status: :on_sprue,
  priority: :high,
  storage_location: "Shelf A, Box 1",
  purchase_date: 3.months.ago
)

terminators = ModelSet.create!(
  series: wh40k,
  faction: space_marines,
  name: "Terminator Squad",
  total_models: 5,
  assembled: 5,
  status: :assembled,
  priority: :medium,
  storage_location: "Shelf A, Box 2",
  paint_scheme_notes: "Ultramarines blue, gold trim, Agrax wash",
  purchase_date: 6.months.ago
)

# Orks
boyz = ModelSet.create!(
  series: wh40k,
  faction: orks,
  name: "Ork Boyz",
  total_models: 20,
  assembled: 10,
  painted: 5,
  on_sprue: 5,
  status: :in_progress,
  priority: :low,
  storage_location: "Shelf B, Box 1",
  paint_scheme_notes: "Green skin, brown leather, metal drybrush",
  purchase_date: 1.year.ago
)

# Mark one model for sale
puts "Marking a model for sale..."
boyz.archive!('for_sale')

# Skaven with split example
clanrats = ModelSet.create!(
  series: aos,
  faction: skaven,
  name: "Clanrats",
  total_models: 20,
  on_sprue: 20,
  status: :on_sprue,
  priority: :medium,
  storage_location: "Shelf C, Box 1",
  purchase_date: 2.months.ago
)

# Split clanrats into 4 groups of 5
4.times do |i|
  ModelSet.create!(
    parent: clanrats,
    series: aos,
    faction: skaven,
    name: "Clanrats Group #{i + 1}",
    total_models: 5,
    on_sprue: 5,
    status: :on_sprue,
    priority: :medium,
    storage_location: "Shelf C, Box 1"
  )
end

puts "Creating todo items..."

TodoItem.create!(
  model_set: intercessors,
  title: "Assemble Intercessor Squad",
  description: "Clean mold lines, assemble, and base",
  due_date: 1.week.from_now,
  estimated_hours: 3,
  priority: :high
)

TodoItem.create!(
  model_set: terminators,
  title: "Paint Terminators",
  description: "Base coat, wash, highlights",
  due_date: 2.weeks.from_now,
  estimated_hours: 8,
  priority: :medium
)

TodoItem.create!(
  title: "Finish 1000pt Space Marine Army",
  description: "Complete army for upcoming tournament",
  due_date: 1.month.from_now,
  estimated_hours: 40,
  priority: :high
)

puts "Creating painting batch..."

batch = PaintingBatch.create!(
  name: "Space Marine Infantry Batch",
  notes: "Painting all SM infantry together for consistency",
  started_at: Date.current
)

batch.model_sets << [intercessors, terminators]

puts "\nSeed data created successfully!"
puts "=" * 50
puts "Series: #{Series.count}"
puts "Factions: #{Faction.count}"
puts "Model Sets: #{ModelSet.count}"
puts "Todo Items: #{TodoItem.count}"
puts "Painting Batches: #{PaintingBatch.count}"
puts "=" * 50