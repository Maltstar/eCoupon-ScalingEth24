import { useState } from "react";
import { useCouponContext } from "./CouponsProvider";
import { CouponTemplate } from "~~/app/createcoupon/_components/CreateCoupon";

/**
 *
 * @returns list the demo_inputs in coupon template form
 */
export default function CouponsDemo() {
  const [Id, setID] = useState(0);
  const [isAlertVisibleMintCoupon, setIsAlertVisibleMintCoupon] = useState(false);

  console.log("CouponsDemo Id", Id);

  /*
 {/* {isAlertVisibleMintCoupon && 
        <div className="notification_success">{`1 Coupon successfully minted `}</div>} */

  return isAlertVisibleMintCoupon ? (
    <div>
      <div className="notification_success">{`1 Coupon successfully minted with id${Id} `}</div>
      <div className="couponlisting">
        <CouponsDemoWithoutConfirmation setIsAlertVisibleMintCoupon={setIsAlertVisibleMintCoupon} setID={setID} />
      </div>
    </div>
  ) : (
    <CouponsDemoWithoutConfirmation setIsAlertVisibleMintCoupon={setIsAlertVisibleMintCoupon} />
  );
}
interface CouponsDemoWithoutConfirmationProps {
  setIsAlertVisibleMintCoupon?: (flag: boolean) => void;
  setID?: (id: number) => void;
}
function CouponsDemoWithoutConfirmation({ setID }: CouponsDemoWithoutConfirmationProps) {
  const { couponsData } = useCouponContext();

  return couponsData.map((demo_inputs, index) => {
    if (setID != undefined) {
      setID(Number(demo_inputs[6]));
    }

    console.log("demo_inputs", demo_inputs);

    return (
      <div key={`coupon${index}`} className="small_card">
        <CouponTemplate
          userinputs={demo_inputs}
          preview={false}
          //alertMint={setIsAlertVisibleMintCoupon}
          //setID={()=> {}}
        />
      </div>
    );
  });
}
