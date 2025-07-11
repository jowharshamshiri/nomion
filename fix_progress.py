#!/usr/bin/env python3

# Fix progress tracker methods to remove &mut self and use RefCell

import re

# Read the file
with open('src/progress.rs', 'r') as f:
    content = f.read()

# Fix method signatures - remove &mut self and replace with &self
content = re.sub(r'pub fn (\w+)\(&mut self', r'pub fn \1(&self', content)

# Fix direct access to fields - wrap with borrow/borrow_mut
content = re.sub(r'self\.main_bar = Some\((.*?)\)', r'*self.main_bar.borrow_mut() = Some(\1)', content)
content = re.sub(r'self\.content_bar = Some\((.*?)\)', r'*self.content_bar.borrow_mut() = Some(\1)', content)
content = re.sub(r'self\.rename_bar = Some\((.*?)\)', r'*self.rename_bar.borrow_mut() = Some(\1)', content)

# Fix if let Some(pb) = &self.field patterns
content = re.sub(r'if let Some\(pb\) = &self\.main_bar', r'if let Some(pb) = self.main_bar.borrow().as_ref()', content)
content = re.sub(r'if let Some\(pb\) = &self\.content_bar', r'if let Some(pb) = self.content_bar.borrow().as_ref()', content)
content = re.sub(r'if let Some\(pb\) = &self\.rename_bar', r'if let Some(pb) = self.rename_bar.borrow().as_ref()', content)

# Write back
with open('src/progress.rs', 'w') as f:
    f.write(content)

print("Fixed progress.rs methods")