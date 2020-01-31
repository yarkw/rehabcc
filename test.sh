#!/bin/bash
try() {
    expected="$1"
    input="$2"

    ./rehabcc "$input" > tmp.s
    gcc -o tmp tmp.s
    ./tmp

    actual="$?"
    if [ "$actual" = "$expected" ]; then
        echo "$input => $actual"
    else
        echo "$input => $expected expected, but got $actual"
        exit 1
    fi
}

try 0 'main() { return 0; }'
try 42 'main() { return 42; }'
try 21 'main() { return 5+20-4; }'
try 21 'main() { return 5 + 20 - 4; }'

# ステップ5
try 47 'main() { return 5 + 6 * 7; }'
try 15 'main() { return 5 * (9 - 6); }'
try 4  'main() { return (3 + 5) / 2; }'

# ステップ6
try 10 'main() { return -10 + 20; }'

# ステップ7
try 1 'main() { return 42 == 42; }'
try 0 'main() { return 42 == 24; }'
try 0 'main() { return 42 != 42; }'
try 1 'main() { return 42 != 24; }'
try 0 'main() { return 42 < 41; }'
try 0 'main() { return 42 < 42; }'
try 1 'main() { return 42 < 43; }'
try 0 'main() { return 42 <= 41; }'
try 1 'main() { return 42 <= 42; }'
try 1 'main() { return 42 <= 43; }'
try 1 'main() { return 42 > 41; }'
try 0 'main() { return 42 > 42; }'
try 0 'main() { return 42 > 43; }'
try 1 'main() { return 42 >= 41; }'
try 1 'main() { return 42 >= 42; }'
try 0 'main() { return 42 >= 43; }'

# ステップ8
try 3 'main() { int a; int b; a = 1; b = 2; return a + b; }'

# ステップ10
try 3 'main() { int foo; int bar; foo = 1; bar = 2; return foo + bar; }'

# ステップ11
try 3 'main() { int foo; int bar; foo = 1; bar = 2; return foo + bar; }'
try 3 'main() { int foo; int bar; foo = 1; bar = 2; return foo + bar; return 42; }'

# ステップ12
try 1 'main() { if (1) return 1; return 2; }'
try 2 'main() { if (0) return 1; return 2; }'
try 1 'main() { if (1) return 1; else return 2; return 3; }'
try 2 'main() { if (0) return 1; else return 2; return 3; }'
try 2 'main() { if (0) return 1; else if (1) return 2; else return 3; return 4; }'
try 3 'main() { if (0) return 1; else if (0) return 2; else return 3; return 4; }'

try 5 'main() { int x; x = 0; while (x < 5) x = x + 1; return x; }'
try 5 'main() { int x; for (x = 0; x < 5; x = x + 1) 0; return x; }'
try 5 'main() { int x; x = 0; for (; x < 5; x = x + 1) 0; return x; }'
try 5 'main() { int x; for (x = 0; ; x = x + 1) if (x == 5) return x; }'
try 5 'main() { int x; for (x = 0; x < 5;) x = x + 1; return x; }'

# ステップ13
try 5 'main() { int x; if (1) { x = 5; return x; } return 0; }'

# ステップ15
try 42 'identity(n) { return n; } main() { return identity(42); }'
try 3 'identity(n) { return n; } main() { return identity(1) + identity(2); }'
try 5 'fib(n) { if (n <= 1) { return 1; } return fib(n-2) + fib(n-1); } main() { return fib(4); }'

# ステップ16
try 42 'main() { int x; int y; x = 42; y = &x; return *y; }'
try 42 'main() { int x; int y; int z; x = 3; y = 42; z = &x - 8; return *z; }'

echo OK
rm -f tmp tmp.s
