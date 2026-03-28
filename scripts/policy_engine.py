import subprocess

BLOCKED_IP = "10.0.1.2"
DEST_IP = "10.0.2.2"

def run(cmd):
    print(f"[+] Running: {cmd}")
    subprocess.run(cmd, shell=True, check=True)

def block_icmp():
    cmd = (
        "sudo ip netns exec router iptables -A FORWARD "
        f"-s {BLOCKED_IP} -d {DEST_IP} -p icmp -j DROP"
    )
    run(cmd)

def allow_icmp():
    cmd = (
        "sudo ip netns exec router iptables -D FORWARD "
        f"-s {BLOCKED_IP} -d {DEST_IP} -p icmp -j DROP"
    )
    run(cmd)

if __name__ == '__main__':
    print('1. Block ICMP from client to server')
    print('2. Remove ICMP block')
    choice = input('Choose option: ').strip()

    if choice == '1':
        block_icmp()
    elif choice == '2':
        allow_icmp()
    else:
        print('Invalid option')
