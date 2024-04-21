import { useScaffoldReadContract, useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

interface ListCouponsCollectionProps {
  coupon_data: Array<string>;
  setCouponID: (id: number) => void;
}

export default function ListCouponsCollection({ coupon_data, setCouponID }: ListCouponsCollectionProps) {
  //const { address: connectedAddress } = useAccount();

  const { writeContractAsync, isPending } = useScaffoldWriteContract("ERC1155eCoupon");
  const { data } = useScaffoldReadContract({
    contractName: "ERC1155eCoupon",
    functionName: "couponCollectionIDCounter",
  });

  const handleListCouponsCollection = async () => {
    try {
      await writeContractAsync(
        {
          functionName: "listCouponCollection",
          args: [
            coupon_data[4], //vendorName
            coupon_data[5], //storeLink,
            coupon_data[0], //couponName
            BigInt(coupon_data[1]), //discountPercent
            BigInt(coupon_data[2]), //maxCouponSupply
            BigInt(1), //expirationDate
          ],
          // value: parseEther("0.01"),
        },
        {
          onBlockConfirmation: txnReceipt => {
            console.log("📦 Transaction blockHash", txnReceipt.blockHash);
          },
        },
      );

      if (data != undefined) {
        const dataString = data.toString();
        console.log("dataString before slice", dataString);
        // removing the last character of the BigInt string "e.g: 1n"
        setCouponID(Number(dataString));
        console.log("dataString", dataString);
      }
    } catch (e) {
      console.error("Error setting greeting", e);
    }
  };

  return (
    <>
      <button className="btn button_outform" onClick={handleListCouponsCollection} disabled={isPending}>
        {isPending ? <span className="loading loading-spinner loading-sm"></span> : "Confirm"}
      </button>
    </>
  );
}
