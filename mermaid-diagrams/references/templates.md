# Mermaid Templates for Tangem

All templates are validated. Replace `%%` comments with actual values.

---

## 1. NFC Card ↔ Phone Handshake (sequenceDiagram)

Use for: NFC session establishment, card command exchange, session teardown.

```mermaid
sequenceDiagram
    actor User
    participant App as "Mobile App"
    participant SDK as "TangemSdk"
    participant Card as "NFC Card"

    User->>App: tap card / initiate action
    App->>SDK: runTask(task)
    SDK->>Card: SELECT AID
    Card-->>SDK: OK + card info
    SDK->>Card: READ command
    Card-->>SDK: encrypted response
    SDK->>App: TaskResponse
    App->>User: show result

    note over SDK,Card: All commands are APDU over ISO 7816
```

---

## 2. Transaction Signing Flow (sequenceDiagram with alt)

Use for: sign transaction, sign hash, any operation requiring PIN or biometrics.

```mermaid
sequenceDiagram
    participant App as "Mobile App"
    participant SDK as "TangemSdk"
    participant Card as "NFC Card"
    participant Backend as "Backend API"

    App->>Backend: "POST /transactions/prepare"
    Backend-->>App: unsignedTx + hashToSign

    App->>SDK: "sign(hash, cardId)"
    SDK->>Card: "VERIFY PIN"

    alt PIN correct
        Card-->>SDK: PIN OK
        SDK->>Card: "SIGN hash"
        Card-->>SDK: signature
        SDK-->>App: SignResponse
        App->>Backend: "POST /transactions/submit"
        Backend-->>App: txId
    else PIN wrong
        Card-->>SDK: "SW 6982 (security status)"
        SDK-->>App: error WrongPin
        App->>App: show retry dialog
    else Card locked
        Card-->>SDK: "SW 6983 (auth blocked)"
        SDK-->>App: error CardLocked
        App->>App: show locked screen
    end
```

---

## 3. Wallet Lifecycle (stateDiagram-v2)

Use for: card/wallet state machine, lifecycle documentation.

```mermaid
stateDiagram-v2
    [*] --> Empty : card issued

    state Personalized {
        [*] --> Locked
        Locked --> Unlocked : PIN verified
        Unlocked --> Locked : session timeout
    }

    Empty --> Personalized : createWallet
    Personalized --> BackedUp : backup completed
    BackedUp --> Personalized : backup invalidated

    state Restored {
        [*] --> Locked
        Locked --> Unlocked : PIN verified
    }

    BackedUp --> Restored : restore from backup
    Personalized --> [*] : purgeWallet
    BackedUp --> [*] : purgeWallet
```

---

## 4. Card-Phone-Backend Architecture (flowchart replacing C4)

Use for: system/container-level architecture overview. Replaces C4Context / C4Container.

```mermaid
flowchart LR
    classDef external fill:#f5f5f5,stroke:#aaa,color:#333
    classDef mobile fill:#dae8fc,stroke:#6c8ebf
    classDef backend fill:#d5e8d4,stroke:#82b366
    classDef card fill:#fff2cc,stroke:#d6b656

    User(["User"])

    subgraph Phone["Mobile Device"]
        App["Tangem App (iOS / Android)"]
        SDK["TangemSdk"]
    end

    subgraph Cloud["Tangem Cloud"]
        API["Backend API"]
        DB[("Database")]
        Blockchain["Blockchain Nodes"]
    end

    HWCard["NFC Card"]

    User -->|"tap / interact"| App
    App --> SDK
    SDK -->|"NFC / ISO 7816"| HWCard
    App -->|"HTTPS"| API
    API --> DB
    API -->|"RPC"| Blockchain

    class App,SDK mobile
    class API,DB,Blockchain backend
    class HWCard card
    class User external
```

---

## 5. Domain Model: Accounts, Wallets, Tokens (erDiagram)

Use for: domain model documentation, data structure overview.

```mermaid
erDiagram
    CARD {
        string cardId PK
        string batchId
        string firmwareVersion
        int signingMethodMask
    }

    WALLET {
        string walletPublicKey PK
        string cardId FK
        string curve
        bool isBackedUp
        int totalSignedHashes
    }

    ACCOUNT {
        string id PK
        string walletPublicKey FK
        string blockchain
        string derivationPath
    }

    TOKEN {
        string contractAddress PK
        string accountId FK
        string symbol
        int decimals
    }

    CARD ||--o{ WALLET : "contains"
    WALLET ||--o{ ACCOUNT : "derives"
    ACCOUNT ||--o{ TOKEN : "holds"
```
