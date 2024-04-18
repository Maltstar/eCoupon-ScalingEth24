import Image from "next/image";
import {
  urlCouponImageIpfs_mid,
  urlCouponImageIpfs_mid_small,
  urlCouponImageIpfs_mini_icon,
} from "~~/utils/platfom/general";

type image_size = "mid" | "small" | "icon";

interface CouponImageProps {
  size: image_size;
}
export default function CouponImage({ size }: CouponImageProps) {
  switch (size) {
    case "mid":
      return (
        <div>
          <Image
            alt="eCouponWeb3 logo"
            className="cursor-pointer"
            src={urlCouponImageIpfs_mid}
            height="200"
            width="200"
          />
        </div>
      );
    case "small":
      return (
        <Image
          alt="eCouponWeb3 logo"
          className="cursor-pointer"
          src={urlCouponImageIpfs_mid_small}
          height="146"
          width="146"
        />
      );
    case "icon":
      return (
        <div>
          <Image
            alt="eCouponWeb3 logo"
            className="cursor-pointer"
            src={urlCouponImageIpfs_mini_icon}
            height="40"
            width="40"
          />
        </div>
      );
  }
}
