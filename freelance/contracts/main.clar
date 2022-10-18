
;; main
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

;; private functions
;;

;; public functions
;;

;; main
;; ;; Freelance smart contract

;; Jobs {job_id: uint} {amount: uint, freelancer_wallet: (optional principal), vibes: bool} 

;; Add job in stx( job id, amount, optional freelancer address)

;; Add job in vibes( job id, amount, optional freelancer address)

;; Close job( job id) 
;; -> freelancer wallet must be present 
;;       - > otherwise, error

;; add freelancer wallet 

;; Approve job (hirevibes) (job id) 
;; -> must be approved by client first 
;; -> escrow is released to freelancer

;; constants


;; data maps and vars

(define-map jobs {job-id : uint } {amount: uint, freelancer-wallet: (optional principal), vibes: bool})

(define-data-var stx-percentage uint u5)
(define-data-var vibes-percentage uint u3)
(define-data-var owner principal 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6)

(define-constant contract-address (as-contract tx-sender))

;; private functions
;;
(define-private (transfer-stx-to-escrow (amount uint)) 

    (stx-transfer? amount tx-sender contract-address)

)

(define-private (transfer-vibes-to-escrow (amount uint)) 

    (contract-call? .vibes-token transfer amount tx-sender contract-address none)

)

;; public functions

(define-public (add-job-in-stx (job-id uint) (amount uint) (freelancer-wallet (optional principal)) ) 

(let 
    (
        (percentage (var-get stx-percentage))
        (hv-fee (/ (* amount percentage) u100))
        (total-amount (+ hv-fee amount))
    )
    (asserts! (is-none (map-get? jobs {job-id: job-id})) (err u100)) ;; execution only continues if data doesn't already exists

    (try! (transfer-stx-to-escrow amount))
    (map-set jobs {job-id: job-id} {amount: total-amount, freelancer-wallet: freelancer-wallet, vibes: false})
    (ok true)
)
)

(define-public (add-job-in-vibes (job-id uint) (amount uint) (freelancer-wallet (optional principal)) ) 

(let 
    (
        (percentage (var-get vibes-percentage))
        (hv-fee (/ (* amount percentage) u100))
        (total-amount (+ hv-fee amount))
    )

    (try! (transfer-vibes-to-escrow total-amount))
    (map-set jobs {job-id: job-id} {amount: total-amount, freelancer-wallet: freelancer-wallet, vibes: true})
    (ok true)
)
)


(define-public (add-freelancer-wallet (job-id uint) (freelancer-wallet (optional principal)) ) 

(let 
    (
        (amount (get amount (unwrap! (map-get? jobs {job-id: job-id}) (err u1) )) )
        (vibes (get vibes (unwrap! (map-get? jobs {job-id: job-id}) (err u1) )) )

    ) 
    ;; check if wallet already exists
    (asserts! (is-none (get freelancer-wallet (unwrap! (map-get? jobs {job-id: job-id}) (err u1) ))) (err u0))

    (map-set jobs {job-id: job-id} {amount: amount, freelancer-wallet: freelancer-wallet, vibes: vibes})
    (ok true)
)
)

(define-public (change-stx-percentage (val uint)) 

    (ok (var-set stx-percentage val))

)

(define-public (change-vibes-percentage (val uint)) 

    (ok (var-set vibes-percentage val))

)