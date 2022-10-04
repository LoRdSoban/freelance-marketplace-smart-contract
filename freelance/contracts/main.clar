
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
()
;; private functions
;;


;; public functions

(define-public (add-job-in-stx (job-id uint) (amount uint) (freelancer-wallet (optional principal)) ) 

(let 
    (
        (percentage u5)
        (hv-fee (/ (* amount percentage) u100))
        (total-amount (+ hv-fee amount))
    ) 
    (map-set jobs {job-id: job-id} {amount: total-amount, freelancer-wallet: freelancer-wallet, vibes: false})
    (ok true)
)
)
