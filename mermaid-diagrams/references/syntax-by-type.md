# Mermaid Syntax Reference by Diagram Type

## flowchart

Use for: architecture (systems, containers, components), data flows, business processes, decision trees.

```
flowchart <direction>
```

Directions: `TD` (top-down), `LR` (left-right), `BT`, `RL`.

### Node shapes

```
A[Rectangle]
B(Rounded)
C{Diamond / decision}
D([Stadium])
E[[Subroutine]]
F[(Database / cylinder)]
G((Circle))
H>Asymmetric]
I[/Parallelogram/]
J[\Parallelogram alt\]
```

### Edge types

```
A --> B          %% arrow
A --- B          %% line, no arrow
A -->|label| B   %% arrow with label
A -.-> B         %% dotted arrow
A ==> B          %% thick arrow
A --o B          %% circle end
A --x B          %% cross end
```

### Subgraph

```
subgraph SG1["System Boundary"]
    A[Service A]
    B[Service B]
end
```

Subgraph labels with spaces or special chars must be in double quotes.

### Styling

```
classDef external fill:#f5f5f5,stroke:#999,color:#333
classDef system fill:#dae8fc,stroke:#6c8ebf
class A,B system
class C external
```

### C4 mapping via flowchart

| C4 concept | flowchart equivalent |
|---|---|
| System_Ext | node with `external` classDef, outside subgraph |
| System | node with `system` classDef, inside top-level subgraph |
| Container_Boundary | `subgraph` with label |
| Container | node inside subgraph |
| Rel | labeled edge `-->|"label"| ` |

---

## sequenceDiagram

Use for: time-ordered interactions between actors/components (API calls, NFC handshake, async flows).

```
sequenceDiagram
    participant App as "Mobile App"
    actor User
```

`participant` = box; `actor` = stick figure.

### Message types

```
App->>Card: send command       %% solid arrow, no reply
App-->>Card: async reply       %% dashed arrow
App-xCard: failed              %% cross (error)
App-)Card: async (open arrow)
```

### Grouping

```
alt Success
    App->>Backend: request
else Error
    App->>App: show error
end

opt Optional step
    App->>Analytics: log event
end

loop Retry up to 3 times
    App->>Card: read
end

par Parallel
    App->>Service1: call
and
    App->>Service2: call
end
```

### Notes

```
Note right of App: NFC session active
Note over App,Card: Encrypted channel
```

### Activation bars

```
activate App
App->>Card: command
deactivate App
```

### Line breaks in messages

Use `<br/>` — it works in sequenceDiagram:
```
App->>Card: "Step 1<br/>Step 2"
```

---

## stateDiagram-v2

Use for: state machines, lifecycle diagrams (wallet states, card states, session states).

```
stateDiagram-v2
    [*] --> Idle
    Idle --> Active: activate
    Active --> [*]: deactivate
```

`[*]` = initial/final state.

### Composite states

```
stateDiagram-v2
    state Personalized {
        [*] --> Locked
        Locked --> Unlocked: PIN OK
        Unlocked --> Locked: timeout
    }
    [*] --> Personalized
```

### Fork / join

```
stateDiagram-v2
    state fork_state <<fork>>
    state join_state <<join>>
    [*] --> fork_state
    fork_state --> A
    fork_state --> B
    A --> join_state
    B --> join_state
    join_state --> [*]
```

### Notes

```
note right of Active
    Card is ready for signing
end note
```

---

## erDiagram

Use for: domain models, database schemas, entity relationships.

```
erDiagram
    WALLET ||--o{ ACCOUNT : "contains"
    ACCOUNT ||--|{ TOKEN : "holds"
```

### Cardinality notation

| Symbol | Meaning |
|---|---|
| `\|\|` | exactly one |
| `o\|` | zero or one |
| `\|\{` | one or more |
| `o{` | zero or more |

### Entity with attributes

```
erDiagram
    WALLET {
        string id PK
        string publicKey
        string curve
        bool isBackedUp
    }
```

Attribute types: `string`, `int`, `boolean`, `date`, `enum`.

---

## classDiagram

Use for: OO models, type hierarchies, interface definitions.

```
classDiagram
    class WalletManager {
        +String walletId
        -PrivateKey key
        +sign(data) Signature
        #validate() bool
    }
```

Visibility: `+` public, `-` private, `#` protected, `~` package.

### Relationships

```
ClassA --|> ClassB      %% inheritance
ClassA --* ClassB       %% composition
ClassA --o ClassB       %% aggregation
ClassA --> ClassB       %% association
ClassA ..> ClassB       %% dependency
ClassA ..|> InterfaceB  %% realization
```

### With labels and cardinality

```
WalletManager "1" --> "many" Wallet : manages
```

### Namespace (grouping)

```
namespace Core {
    class WalletManager
    class Wallet
}
```
