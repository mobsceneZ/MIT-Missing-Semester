import sys
def fizz_buzz(limit):
	for i in range(1, limit+1):
		if i % 3 == 0:
			if i % 5:
				print('fizz')
			else:
				print('fizz', end="")

		if i % 5 == 0:
			print('buzz')
		if i % 3 and i % 5:
			print(i)

def main():
	fizz_buzz(int(sys.argv[1]))

if __name__ == "__main__":
	main()
