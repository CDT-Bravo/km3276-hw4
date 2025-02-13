# Hash Harvester - Red Team Tool
Author: Kaitlyn Moy

HW4: Contribution

# NTLM Hash Capture via SMB  

This tool is designed to enumerate users, identify hosts without SMB signing enabled, and capture NTLM hashes using SMB relaying. It automates the process with **CrackMapExec**, **Responder**, and **impacket-ntlmrelayx**.

## Features  
- **Enumerate Users** – Uses CrackMapExec to extract usernames from a target system.  
- **Discover SMB Vulnerabilities** – Identifies hosts without SMB signing enabled, allowing for NTLM relay attacks.  
- **Capture NTLM Hashes** – Uses Responder and impacket-ntlmrelayx to capture and relay NTLM authentication attempts.  

---

## Prerequisites  

### OS Compatibility  
- Tested on **Kali Linux** (recommended).  

### Required Tools  
Ensure the following tools are installed:  
- **CrackMapExec**  
- **Responder**  
- **Impacket**  

If you're using Kali Linux, these tools should already be installed. Otherwise, install them with:  

```bash
sudo apt update
sudo apt install crackmapexec responder impacket-scripts -y
```

---

## Usage  

### Running the Script  
Execute the following command:  

```bash
python capturing_hashes.py
```

### Interactive Inputs  
The script will prompt you to enter:  
1. **Target IP or IP Range** (e.g., `192.168.1.100` or `192.168.1.0/24`)  
2. **Target Name** (Hostname of the target machine)  
3. **Network Interface** (e.g., `eth0`, `wlan0`)  

---

## How It Works  

### 1. Enumerate Users  
- Runs **CrackMapExec** to extract usernames.  
- Saves results to `usernames.txt`.  

### 2. Identify Hosts Without SMB Signing  
- Uses **CrackMapExec** to find SMB servers vulnerable to NTLM relaying.  
- Outputs results to `smb_relay.txt`.  

### 3. Start NTLM Relay Attack  
- Launches **impacket-ntlmrelayx** to relay credentials from vulnerable hosts.  

### 4. Capture NTLM Hashes  
- Starts **Responder** to intercept and capture NTLM authentication attempts.  
- Saves NTLM hashes to `netntlm`.  

---

## Output Files  

After running the script, check these files:  
- `usernames.txt` – List of extracted usernames.  
- `smb_relay.txt` – Hosts without SMB signing enabled.  
- `netntlm` – Captured NTLM hashes for further analysis.  

---

