# 1. Go to your UI dir
cd ../plugins/my_first_plugin/ui-extension

# 2. Delete the old environment completely
rm -rf node_modules package-lock.json

# 3. Run the updated scaffold script from the scaffolding folder
cd ../../../scaffolding
./_4_scaffold_ui.sh

# 4. Re-install with the new synced versions
cd ../plugins/my_first_plugin/ui-extension
npm install
npm run dev