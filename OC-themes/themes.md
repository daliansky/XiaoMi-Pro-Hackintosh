## Guide to Download and Apply Chris1111 Themes on OpenCore

### 1. **Download a Theme**
   - Visit the [Chris1111 Themes Repository](https://github.com/chris1111/My-Simple-OC-Themes/blob/master/My-Simple-Theme-OpenCore.md).
   - Scroll down to find the list of available themes.
   - Right-click on the theme you want to download and click **"Save As"** or **"Download Linked File"**.
   - Save the `.zip` file for the theme you selected to your computer.

### 2. **Extract the Theme**
   - Once downloaded, extract the `.zip` file.
   - Inside the folder, you’ll find a theme folder (e.g., `Minimal`, `Ocean`, etc.), which contains the necessary files.

### 3. **Prepare OpenCore EFI Folder**
   - Navigate to your **EFI** partition of your OpenCore installation. This is typically mounted as `EFI` on your system drive.
   - Inside the EFI partition, go to **EFI > OC**.

### 4. **Apply the Theme**
   - Inside the extracted theme folder, you will see the following files:
     - **resources** folder
     - **config.plist**
   
   - Copy the **resources** folder into the `OC` directory of your EFI partition (if it's not already there).
   - **Important**: Do not overwrite your existing `config.plist` unless you want to replace it with the new one. If you are unsure, back up your current `config.plist` first.

### 5. **Edit `config.plist` for the Theme**

#### For OpenCore 0.8.7 and Higher:
   - Open the `config.plist` using a plist editor like ProperTree or Clover Configurator.
   - Navigate to `Misc > Boot`.
   - Set the following values:

     - **PickerVariant**: Set to the theme folder name (e.g., `chris1111\Flavours-Wonderfull` or `chris1111\OnLight`).
     - **PickerAttributes**: Set to `145` for themes like `Flavours-Wonderfull`, or `17` for themes like `OnLight`.
     - **PickerMode**: Set to **External**.
     - **Timeout**: Set to `5` (adjustable depending on your preference).
     - **ShowPicker**: Set to `true`.

   - For `OnLight` theme (as an example):
     - `Misc > Boot > PickerVariant: chris1111\OnLight`
     - `Misc > Boot > PickerAttributes: 17`

   - For `Flavours-Wonderfull` theme (as an example):
     - `Misc > Boot > HideAuxiliary: false`
     - `Misc > Boot > PickerVariant: chris1111\Flavours-Wonderfull`
     - `Misc > Boot > PickerAttributes: 145`
     - `Misc > Boot > PickerMode: External`
     - `Misc > Boot > Timeout: 5`
     - `Misc > Boot > ShowPicker: true`

#### For OpenCore 0.8.8 and Higher:
   - The steps are similar to the ones for 0.8.7 and higher:
     - `Misc > Boot > HideAuxiliary: false`
     - `Misc > Boot > PickerVariant: chris1111\Flavours-Wonderfull`
     - `Misc > Boot > PickerAttributes: 145`
     - `Misc > Boot > PickerMode: External`
     - `Misc > Boot > Timeout: 5`
     - `Misc > Boot > ShowPicker: true`

### 6. **Reboot and Test**
   - Once you've updated the `config.plist`, save the changes.
   - Reboot your system to test if the new theme is applied correctly.

### 7. **Troubleshooting**
   - If the theme doesn’t apply correctly, double-check that the **resources** folder is placed in the right directory (`EFI > OC`).
   - Ensure that the `config.plist` is pointing to the correct theme folder and the appropriate settings are applied.
   - Review the theme-specific instructions on the GitHub page for any extra steps or modifications.

---

### Optional: Customizing the Theme
If you want to further customize the theme:
   - Go to the **resources > image** folder inside the theme folder.
   - Replace images (like logos, background, etc.) with your own, ensuring they follow the same format and size.
