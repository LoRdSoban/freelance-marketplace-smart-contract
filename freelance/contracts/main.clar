
;; main
;; ;; Freelance smart contrac
;; Jobs {job_id: uint} {amount: uint, freelancer_wallet: (optional principal), vibes: bool} 

;; Add job in stx( job id, amount, optional freelancer address)

;; Add job in vibes( job id, amount, optional freelancer address)

;; Close job( job id) 
;; -> freelancer wallet must be present 
;;       - > otherwise, error

;; Approve job (hirevibes) (job id) 
;; -> must be approved by client first 
;; -> escrow is released to freelancer

;; constants
;;

;; data maps and vars

(define-map jobs {job-id : uint } {amount: uint, freelancer-wallet: (optional principal), vibes: bool})

(define-data-var stx-percentage uint u5)
(define-data-var vibes-percentage uint u3)

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
    (map-set jobs {job-id: job-id} {amount: total-amount, freelancer-wallet: freelancer-wallet, vibes: false})
    (ok true)
)
)
