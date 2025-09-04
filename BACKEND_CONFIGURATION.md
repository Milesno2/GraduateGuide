# Backend Configuration Guide

## 🚀 Supabase Setup

### 1. Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up/Login to your account
3. Click "New Project"
4. Fill in the project details:
   - **Name**: `graduate-assistant-hub`
   - **Database Password**: Create a strong password
   - **Region**: Choose closest to your users (e.g., `West Europe` for Nigeria)
5. Click "Create new project"
6. Wait for the project to be set up (usually takes 2-3 minutes)

### 2. Get Project Credentials

1. Go to **Settings** → **API**
2. Copy the following credentials:
   - **Project URL**: `https://your-project-id.supabase.co`
   - **Anon Public Key**: `your-anon-key`
   - **Service Role Key**: `your-service-role-key` (keep this secret)

### 3. Update App Configuration

Replace the placeholder values in `lib/services/supabase_service.dart`:

```dart
// Replace these with your actual Supabase credentials
static const String supabaseUrl = 'https://your-project-id.supabase.co';
static const String supabaseAnonKey = 'your-anon-key';
```

## 🗄️ Database Schema Setup

### 1. Create Tables

Run these SQL commands in your Supabase SQL Editor:

#### Users Table
```sql
-- Create users table
CREATE TABLE users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  first_name TEXT,
  last_name TEXT,
  profession TEXT,
  graduation_year TEXT,
  school TEXT,
  profile_image TEXT,
  last_login TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);
```

#### Messages Table
```sql
-- Create messages table
CREATE TABLE messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  conversation_id UUID NOT NULL,
  sender_id UUID REFERENCES users(id) NOT NULL,
  receiver_id UUID REFERENCES users(id) NOT NULL,
  content TEXT NOT NULL,
  message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text', 'voice', 'image')),
  voice_url TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view messages they sent or received" ON messages
  FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

CREATE POLICY "Users can insert messages" ON messages
  FOR INSERT WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Users can update messages they sent" ON messages
  FOR UPDATE USING (auth.uid() = sender_id);
```

#### Conversations Table
```sql
-- Create conversations table
CREATE TABLE conversations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  participant1_id UUID REFERENCES users(id) NOT NULL,
  participant2_id UUID REFERENCES users(id) NOT NULL,
  last_message_id UUID REFERENCES messages(id),
  last_message_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(participant1_id, participant2_id)
);

-- Enable Row Level Security
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view conversations they're part of" ON conversations
  FOR SELECT USING (auth.uid() = participant1_id OR auth.uid() = participant2_id);

CREATE POLICY "Users can insert conversations" ON conversations
  FOR INSERT WITH CHECK (auth.uid() = participant1_id OR auth.uid() = participant2_id);

CREATE POLICY "Users can update conversations they're part of" ON conversations
  FOR UPDATE USING (auth.uid() = participant1_id OR auth.uid() = participant2_id);
```

#### Notifications Table
```sql
-- Create notifications table
CREATE TABLE notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT DEFAULT 'general' CHECK (type IN ('general', 'message', 'job', 'skill', 'career')),
  priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMP WITH TIME ZONE,
  action_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own notifications" ON notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications" ON notifications
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "System can insert notifications" ON notifications
  FOR INSERT WITH CHECK (true);
```

#### Skills Table
```sql
-- Create skills table
CREATE TABLE skills (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  description TEXT,
  duration TEXT,
  price DECIMAL(10,2),
  instructor TEXT,
  rating DECIMAL(3,2),
  students_count INTEGER DEFAULT 0,
  certificate_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Anyone can view skills" ON skills
  FOR SELECT USING (true);
```

#### User Skills Table
```sql
-- Create user_skills table
CREATE TABLE user_skills (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) NOT NULL,
  skill_id UUID REFERENCES skills(id) NOT NULL,
  progress DECIMAL(5,2) DEFAULT 0.0,
  certificate_earned BOOLEAN DEFAULT FALSE,
  next_milestone TEXT,
  completed_lessons INTEGER DEFAULT 0,
  total_lessons INTEGER DEFAULT 0,
  last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, skill_id)
);

-- Enable Row Level Security
ALTER TABLE user_skills ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own skills" ON user_skills
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own skills" ON user_skills
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own skills" ON user_skills
  FOR INSERT WITH CHECK (auth.uid() = user_id);
```

#### Jobs Table
```sql
-- Create jobs table
CREATE TABLE jobs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  company TEXT NOT NULL,
  location TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('Full-time', 'Part-time', 'Contract', 'Internship')),
  salary_min DECIMAL(10,2),
  salary_max DECIMAL(10,2),
  experience_level TEXT,
  category TEXT NOT NULL,
  description TEXT NOT NULL,
  requirements TEXT[],
  benefits TEXT[],
  logo_url TEXT,
  applications_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  posted_by UUID REFERENCES users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Anyone can view active jobs" ON jobs
  FOR SELECT USING (is_active = true);

CREATE POLICY "Employers can manage their jobs" ON jobs
  FOR ALL USING (auth.uid() = posted_by);
```

#### Job Applications Table
```sql
-- Create job_applications table
CREATE TABLE job_applications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  job_id UUID REFERENCES jobs(id) NOT NULL,
  user_id UUID REFERENCES users(id) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'shortlisted', 'rejected', 'accepted')),
  cover_letter TEXT,
  resume_url TEXT,
  applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  reviewed_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(job_id, user_id)
);

-- Enable Row Level Security
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own applications" ON job_applications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own applications" ON job_applications
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Employers can view applications for their jobs" ON job_applications
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM jobs WHERE jobs.id = job_applications.job_id AND jobs.posted_by = auth.uid()
    )
  );
```

#### Voice Calls Table
```sql
-- Create voice_calls table
CREATE TABLE voice_calls (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  caller_id UUID REFERENCES users(id) NOT NULL,
  receiver_id UUID REFERENCES users(id) NOT NULL,
  status TEXT DEFAULT 'initiated' CHECK (status IN ('initiated', 'ringing', 'answered', 'ended', 'missed')),
  started_at TIMESTAMP WITH TIME ZONE,
  ended_at TIMESTAMP WITH TIME ZONE,
  duration_seconds INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE voice_calls ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view calls they participated in" ON voice_calls
  FOR SELECT USING (auth.uid() = caller_id OR auth.uid() = receiver_id);

CREATE POLICY "Users can insert calls they initiate" ON voice_calls
  FOR INSERT WITH CHECK (auth.uid() = caller_id);

CREATE POLICY "Users can update calls they participated in" ON voice_calls
  FOR UPDATE USING (auth.uid() = caller_id OR auth.uid() = receiver_id);
```

### 2. Create Functions

#### Update Last Login Function
```sql
-- Function to update user's last login
CREATE OR REPLACE FUNCTION update_last_login()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users SET last_login = NOW() WHERE id = NEW.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update last_login
CREATE TRIGGER update_user_last_login
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION update_last_login();
```

#### Notification Count Function
```sql
-- Function to get unread notification count
CREATE OR REPLACE FUNCTION get_unread_notification_count(user_uuid UUID)
RETURNS INTEGER AS $$
BEGIN
  RETURN (
    SELECT COUNT(*) 
    FROM notifications 
    WHERE user_id = user_uuid AND is_read = FALSE
  );
END;
$$ LANGUAGE plpgsql;
```

### 3. Insert Sample Data

#### Sample Skills
```sql
INSERT INTO skills (name, category, description, duration, price, instructor, rating, students_count) VALUES
('Front End Development', 'Technology', 'Master HTML, CSS, JavaScript, React, and modern web development frameworks', '8 Weeks', 150000, 'Tech Academy Nigeria', 4.8, 1250),
('Graphic Design', 'Design', 'Learn Adobe Creative Suite, UI/UX design principles, and digital art creation', '6 Weeks', 120000, 'Creative Design Institute', 4.7, 890),
('Interior Decoration', 'Design', 'Master interior design principles, space planning, and decorative techniques', '10 Weeks', 180000, 'Interior Design Academy', 4.6, 650),
('Digital Marketing', 'Marketing', 'Learn SEO, social media marketing, content creation, and analytics', '6 Weeks', 100000, 'Digital Marketing Pro', 4.5, 1100),
('Project Management', 'Business', 'Master Agile, Scrum, and traditional project management methodologies', '8 Weeks', 200000, 'Business Management Institute', 4.9, 750),
('Data Analysis', 'Technology', 'Learn Excel, SQL, Python, and data visualization tools', '10 Weeks', 160000, 'Data Science Academy', 4.8, 920);
```

#### Sample Jobs
```sql
INSERT INTO jobs (title, company, location, type, salary_min, salary_max, experience_level, category, description, requirements, benefits) VALUES
('Software Developer', 'Flutterwave', 'Lagos, Nigeria', 'Full-time', 300000, 500000, '2-4 years', 'Technology', 'We are looking for a skilled Software Developer to join our team. You will be responsible for developing and maintaining web applications using modern technologies.', ARRAY['Bachelor''s degree in Computer Science or related field', 'Proficiency in JavaScript, Python, or Java', 'Experience with React, Node.js, or Django', 'Strong problem-solving skills', 'Good communication skills'], ARRAY['Health insurance', 'Flexible working hours', 'Remote work options', 'Professional development', 'Performance bonuses']),
('Financial Analyst', 'GTBank', 'Lagos, Nigeria', 'Full-time', 250000, 400000, '1-3 years', 'Finance', 'Join our finance team to analyze financial data, prepare reports, and provide insights to support business decisions.', ARRAY['Bachelor''s degree in Finance, Accounting, or Economics', 'Strong analytical and Excel skills', 'Knowledge of financial modeling', 'Attention to detail', 'Professional certification (ACCA, CFA) preferred'], ARRAY['Competitive salary', 'Health insurance', 'Pension scheme', 'Annual leave', 'Training opportunities']);
```

## 🔧 Environment Variables

### 1. Create Environment File

Create a `.env` file in your project root:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# App Configuration
APP_NAME=Graduate Assistant Hub
APP_VERSION=1.0.0
DEBUG_MODE=true

# File Upload Configuration
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/gif,audio/mpeg,audio/wav

# Notification Configuration
PUSH_NOTIFICATIONS_ENABLED=true
EMAIL_NOTIFICATIONS_ENABLED=true
```

### 2. Update pubspec.yaml

Add environment variables support:

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^1.10.25
  flutter_dotenv: ^5.1.0
  # ... other dependencies
```

## 🔐 Authentication Setup

### 1. Configure Auth Settings

In your Supabase dashboard:

1. Go to **Authentication** → **Settings**
2. Configure the following:

#### Site URL
```
http://localhost:3000
```

#### Redirect URLs
```
http://localhost:3000/auth/callback
http://localhost:3000/auth/signup
http://localhost:3000/auth/signin
```

#### Email Templates
Customize the email templates for:
- Email confirmation
- Password reset
- Magic link

### 2. Enable Providers

Enable the authentication providers you want to use:

1. **Email**: Enable email/password authentication
2. **Google**: Configure OAuth (optional)
3. **Phone**: Enable phone authentication (optional)

## 📱 Real-time Configuration

### 1. Enable Realtime

In your Supabase dashboard:

1. Go to **Database** → **Replication**
2. Enable realtime for the following tables:
   - `messages`
   - `notifications`
   - `conversations`
   - `voice_calls`

### 2. Configure Webhooks (Optional)

For advanced features, set up webhooks:

1. Go to **Database** → **Webhooks**
2. Create webhooks for:
   - New user registration
   - New message notifications
   - Job application updates

## 🗄️ Storage Configuration

### 1. Create Storage Buckets

In your Supabase dashboard:

1. Go to **Storage** → **Buckets**
2. Create the following buckets:

#### Profile Images
```
Bucket Name: profile-images
Public: true
File Size Limit: 5MB
Allowed MIME Types: image/jpeg,image/png,image/gif
```

#### Voice Messages
```
Bucket Name: voice-messages
Public: false
File Size Limit: 10MB
Allowed MIME Types: audio/mpeg,audio/wav,audio/ogg
```

#### Documents
```
Bucket Name: documents
Public: false
File Size Limit: 10MB
Allowed MIME Types: application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document
```

### 2. Storage Policies

Create storage policies for each bucket:

#### Profile Images Policy
```sql
-- Allow users to upload their own profile image
CREATE POLICY "Users can upload their own profile image" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'profile-images' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Allow public read access to profile images
CREATE POLICY "Anyone can view profile images" ON storage.objects
  FOR SELECT USING (bucket_id = 'profile-images');
```

#### Voice Messages Policy
```sql
-- Allow users to upload voice messages
CREATE POLICY "Users can upload voice messages" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'voice-messages');

-- Allow users to view voice messages they sent or received
CREATE POLICY "Users can view voice messages" ON storage.objects
  FOR SELECT USING (bucket_id = 'voice-messages');
```

## 🚀 Deployment Configuration

### 1. Production Environment

For production deployment:

1. Update the environment variables with production values
2. Configure production URLs in authentication settings
3. Set up proper CORS policies
4. Enable SSL/TLS

### 2. Monitoring Setup

1. Enable Supabase Analytics
2. Set up error tracking (e.g., Sentry)
3. Configure performance monitoring

## 🔍 Testing Configuration

### 1. Test Database

Create a separate test database:

1. Create a new Supabase project for testing
2. Use the same schema but with test data
3. Configure test environment variables

### 2. API Testing

Use tools like Postman or Insomnia to test your API endpoints:

- Authentication endpoints
- CRUD operations
- Real-time subscriptions
- File uploads

## 📋 Checklist

Before going live, ensure you have:

- [ ] Supabase project created and configured
- [ ] All database tables created with proper RLS policies
- [ ] Authentication providers configured
- [ ] Storage buckets created with proper policies
- [ ] Real-time enabled for required tables
- [ ] Environment variables configured
- [ ] App credentials updated in the code
- [ ] Email templates customized
- [ ] CORS policies configured
- [ ] SSL/TLS enabled for production
- [ ] Monitoring and analytics set up
- [ ] Backup strategy in place

## 🆘 Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Check if Supabase URL and keys are correct
   - Verify authentication settings in dashboard
   - Check CORS configuration

2. **Database Permission Errors**
   - Verify RLS policies are correctly set up
   - Check if user is authenticated
   - Review table permissions

3. **Real-time Issues**
   - Ensure realtime is enabled for tables
   - Check subscription setup in code
   - Verify network connectivity

4. **File Upload Issues**
   - Check storage bucket configuration
   - Verify file size and type restrictions
   - Review storage policies

### Support Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Supabase Community](https://github.com/supabase/supabase/discussions)

## 📞 Contact

For additional support or questions about the backend configuration, please refer to the Supabase documentation or create an issue in the project repository.