"use client";

import type { NextPage } from "next";
import { useAccount } from "wagmi";
import { Address } from "~~/components/scaffold-eth";
import CouponsDemo from "~~/components/CouponsDemo";
import { platformName } from "~~/utils/platfom/name";

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();

  return (
    <>
      <div className="flex items-center  pt-10">
        <div className="px-5">
          <div className="main_title_wrapper">
              <h1 className=" text-2xl mb-2">Welcome to</h1>
              <h1 className=" text-4xl font-bold">{`${platformName} a web3 eCoupon marketplace`}</h1>
            <div className="flex justify-center items-center space-x-2">
              <p className="my-2 font-medium">Connected Wallet:</p>
              <Address address={connectedAddress} />
            </div>
          </div>
          <div className="couponlisting">
            <CouponsDemo/>
          </div>
          
        </div>
      </div>
    </>
  );
};

export default Home;
