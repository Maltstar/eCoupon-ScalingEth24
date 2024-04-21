import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

interface mintCouponProps {
  coupon_id: string;
  confirmation: () => void;
}
export default function MintCoupon({ coupon_id, confirmation }: mintCouponProps) {
  //const { address: connectedAddress } = useAccount();

  const { writeContractAsync } = useScaffoldWriteContract("ERC1155eCoupon");

  const mint = async (cp_id: string) => {
    const amount_single_coupon = BigInt(1);
    const id = BigInt(cp_id);

    try {
      await writeContractAsync(
        {
          functionName: "mintCoupon",
          args: [id, amount_single_coupon],
          // value: parseEther("0.01"),
        },
        {
          onBlockConfirmation: txnReceipt => {
            console.log("📦 Transaction blockHash", txnReceipt.blockHash);
            confirmation(); //display confirmation
          },
        },
      );
    } catch (e) {
      console.error("Error setting greeting", e);
    }
  };

  return (
    <button
      id="btn_mint"
      className="btn button_outform"
      onClick={() => {
        mint(coupon_id);
      }}
    >
      Mint
    </button>
  );
}
