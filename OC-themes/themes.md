# Setting Up a Custom Theme on OpenCore Bootloader

This guide provides step-by-step instructions for setting up a custom theme on the OpenCore Bootloader using the "Crisis 1111" theme. The required theme files can be downloaded directly from the GitHub repository without cloning.

---

## Prerequisites

Before proceeding, ensure you have:

1. OpenCore Bootloader installed and properly configured.
2. Access to the GitHub repository containing the "Crisis 1111" theme.
3. A tool for editing the OpenCore `config.plist` file.

---

## Installation Steps

### 1. Download the Theme Files

1. Open the GitHub repository.
2. Navigate to the `OC-themes` folder.
3. Select the theme folder you want to use, e.g., `Coloryst/Resources`.
4. Download the entire `Resources` subfolder as a ZIP file:
   - Click the "Code" button.
   - Select "Download ZIP."
5. Extract the ZIP file to a location on your computer.

### 2. Mount the OpenCore EFI Partition

1. Identify and mount the EFI partition:
   - On macOS, use **Disk Utility** or run the following command in **Terminal**:
     ```bash
     diskutil list
     diskutil mount diskXsY
     ```
     Replace `diskXsY` with your EFI partition identifier.
   - On Windows, use **MiniTool Partition Wizard** or **Explorer++**.

2. Open the EFI directory and go to `EFI/OC/Resources`.

### 3. Replace the Existing Theme Files

1. Backup the current `Resources` folder by copying it to a safe location.
2. Copy the extracted `Resources` folder from the downloaded theme (e.g., `Coloryst/Resources`) and paste it into `EFI/OC/`, replacing the existing one.

### 4. Configure OpenCore to Apply the Theme

1. Open the `config.plist` file using a plist editor:
   - macOS: Use **ProperTree** or **Xcode**.
   - Windows: Use **PlistEdit Pro** or **OpenCore Configurator**.

2. Modify the following settings in the `UEFI` section:
   - Set `TextRenderer` to `BuiltinGraphics`.
   - Navigate to `Misc` -> `Boot` and set:
     ```
     PickerMode: External
     ```

3. Save and close the `config.plist` file.

### 5. Verify the Theme Installation

1. Restart your system.
2. Enter the OpenCore Bootloader.
3. Confirm that the selected theme appears as expected.

### 6. Troubleshooting

If the theme does not load properly:
  - Ensure the `Resources` folder is correctly placed in `EFI/OC/`.
  - Verify that the `config.plist` settings are correctly applied.
  - Rebuild your OpenCore EFI configuration if needed.

---

## Additional Tips

- Always create a backup of your EFI folder before making changes.
- Customize elements in the `Resources` folder (icons, fonts, etc.) for a unique appearance.
- Refer to the [OpenCore Documentation](https://dortania.github.io/OpenCore-Install-Guide/) for advanced configurations.

With these steps, your OpenCore Bootloader should now have a custom theme applied successfully.


more themes [HERE](https://github.com/chris1111/My-Simple-OC-Themes/blob/master/My-Simple-Theme-OpenCore.md)
