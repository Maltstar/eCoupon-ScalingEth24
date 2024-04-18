import { useCouponContext } from "./CouponsProvider";
import { CouponTemplate } from "~~/app/createcoupon/_components/CreateCoupon";

/**
 *
 * @returns list the demo_inputs in coupon template form
 */
export default function CouponsDemo() {
  const { couponsData } = useCouponContext();

  return couponsData.map((demo_inputs, index) => {
    return (
      <div key={`coupon${index}`} className="small_card">
        <CouponTemplate userinputs={demo_inputs} preview={false} />
      </div>
    );
  });
}
