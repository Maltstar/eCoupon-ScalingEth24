import { useEffect, useState } from "react";
import Link from "next/link";
import ListCouponsCollection from "./ListCouponCollection";
import MintCoupon from "./MintCoupon";
import CouponImage from "~~/components/CouponImage";
import { useCouponContext } from "~~/components/CouponsProvider";

export type couponDataField = [
  "Name",
  "Discount %",
  "Max amount",
  "Expire date",
  "Vendor Name",
  "Vendor shop link",
  "ID_coupon",
];

export const couponData: couponDataField = [
  "Name",
  "Discount %",
  "Max amount",
  "Expire date",
  "Vendor Name",
  "Vendor shop link",
  "ID_coupon",
];

export const couponPlaceholders = [
  "Get -10% on Adidas",
  "10",
  "1024",
  "10/12/2024",
  "Amazon",
  "https://www.amazon.com/s?k=Adidas",
];

/**
 *
 * @returns list all datacoupons in a form element shape
 */
function InputForm() {
  return (
    <div className="inputwithlabel">
      {couponData.map((datafield, i) => {
        return (
          datafield != "ID_coupon" && (
            <div key={`datacoupon_${datafield}`} className="input_label">
              <label>{datafield}</label>
              <input id={datafield} name={datafield} placeholder={"e.g: " + couponPlaceholders[i]}></input>
            </div>
          )
        );
      })}
    </div>
  );
}

interface CouponTemplateProps {
  userinputs: Array<string>;
  preview: boolean;
  setDisplayOutputForm?: (flag: boolean) => void;
  // setID: (id:number) => void,
  alertColletion?: (flag: boolean) => void;
  //alertMint?:(flag: boolean) =>void,
  setID?: (id: number) => void;
  // handleConfirmation?: () => void;
}

export function CouponTemplate({
  userinputs,
  preview,
  setDisplayOutputForm,
  alertColletion,
  setID,
}: CouponTemplateProps) {
  console.log("CouponTemplate");
  const { couponsData, SetCouponsData } = useCouponContext();
  const [couponID, setCouponID] = useState(Number(0));
  const [isAlertVisibleMintCoupon, setIsAlertVisibleMintCoupon] = useState(false);

  const handleConfirmationCreateCollection = () => {
    if (alertColletion != undefined) {
      alertColletion(true);

      setTimeout(() => {
        alertColletion(false);
      }, 3000);
    }
  };

  const handleConfirmationMintCoupon = () => {
    if (setIsAlertVisibleMintCoupon != undefined) {
      setIsAlertVisibleMintCoupon(true);

      setTimeout(() => {
        setIsAlertVisibleMintCoupon(false);
      }, 3000);
    }
  };

  // redirect to webshop
  const handleVisitShop = (url: URL) => {
    window.open(url, "_blank");
  };

  useEffect(() => {
    if (couponID != 0) {
      handleOnConfirm();
      if (setID != undefined) {
        setID(couponID);
      }
    }
  }, [couponID]);
  /* update Coupon Provider by adding coupon created in the current conpons listing*/
  const handleOnConfirm = () => {
    if (SetCouponsData != undefined && couponID != 0) {
      const couponsDataLocal = couponsData;
      const newCouponData = userinputs;
      // add coupon ID to identify the coupon collection
      newCouponData.push(couponID.toString());
      couponsDataLocal.unshift(newCouponData);
      SetCouponsData(couponsDataLocal);

      handleConfirmationCreateCollection();
    }
  };

  /* close coupon preview*/
  const handleClose = () => {
    if (setDisplayOutputForm != null) {
      setDisplayOutputForm(false);
    }
  };

  // const mintCoupon = (coupon_id:number) => {
  //   //const { address: connectedAddress } = useAccount();

  //   const { writeContractAsync, isPending } = useScaffoldWriteContract("ERC1155eCoupon");

  //   const mint = async () => {

  //     const amount_single_coupon = BigInt(1)
  //     const id = BigInt(coupon_id)

  //     try {
  //       await writeContractAsync(
  //         {
  //           functionName: "mintCoupon",
  //           args: [id,amount_single_coupon],
  //          // value: parseEther("0.01"),
  //         },
  //         {
  //           onBlockConfirmation: txnReceipt => {
  //             console.log("📦 Transaction blockHash", txnReceipt.blockHash);
  //           },
  //         },
  //       );
  //     } catch (e) {
  //       console.error("Error setting greeting", e);
  //     }
  //   };

  //   mint();
  // };

  //     /* close coupon preview*/
  //   const handleMint = async (couponID:string) => {
  //     const id = Number(couponID)
  //     console.log("handleMint");
  //     console.log(couponID)

  //     // if(id != 0)
  //     //   {
  //         mintCoupon(id)
  //         handleConfirmationMintCoupon()
  //      // }

  // }

  return (
    <>
      <div className="coupon_preview">
        <div className="image_coupon">
          {preview ? ( // render image formatted for preview
            <div id="preview_image">
              <CouponImage size="small" />
            </div>
          ) : (
            // render image formatted for landing page coupons
            <CouponImage size="small" />
          )}
        </div>

        <div className="outputwithlabel">
          {couponData.map((datafield, index) => {
            console.log("datafield", datafield);

            switch (datafield) {
              case "Name":
                return (
                  <h2 key={`data_${datafield}`} className="title">
                    {userinputs[index]}
                  </h2>
                );

              case "Vendor shop link":
                return (
                  <div key={`data_${datafield}`} className="output_label">
                    <label>{datafield} : </label>
                    <button
                      className="link_shop"
                      onClick={() => {
                        handleVisitShop(userinputs[index] as unknown as URL);
                      }}
                    >
                      visit shop
                    </button>
                  </div>
                );

              case "ID_coupon":
                return (
                  !preview && (
                    <>
                      {isAlertVisibleMintCoupon && (
                        <div>
                          <div className="notification_success">{`1 Coupon successfully minted with id${userinputs[index]} `}</div>
                        </div>
                      )}
                      <MintCoupon coupon_id={userinputs[index]} confirmation={handleConfirmationMintCoupon} />
                    </>
                  )
                );

              default:
                return (
                  <div key={`data_${datafield}`} className="output_label">
                    <label>{datafield} : </label>
                    <span className="outputvalues" id={`of_${datafield}`}>
                      {" "}
                      {userinputs[index]}
                    </span>
                  </div>
                );
            }
          })}
        </div>
      </div>
      {
        // list 3 buttons on coupons only for the coupon preview
        preview && (
          <div className="buttons_preview">
            <button className="btn button_outform" onClick={handleClose}>
              Close
            </button>
            <Link className="btn button_outform" href="/">
              Go to Home
            </Link>
            <ListCouponsCollection coupon_data={userinputs} setCouponID={setCouponID} />
          </div>
        )
      }
    </>
  );
}

function InnerForm() {
  const [displayOutputForm, setDisplayOutputForm] = useState(false);
  const [userInputs, setUserInputs] = useState([] as Array<string>);
  const [isAlertVisibleCreateCollection, setIsAlertVisibleCreateCollection] = useState(false);
  const [Id, setID] = useState(0);

  // const [setIsAlertVisisAlertVisibleCreateCollectionibleCreateCollection, setIsAlertVisibleCreateCollection] = useState(false);

  // const handleConfirmation = () => {
  //   setIsAlertVisibleCreateCollection(true);

  //   setTimeout(() => {
  //     setIsAlertVisibleCreateCollection(false);
  //   }, 3000);
  // };

  const handleOnClick = () => {
    const inputs: Array<string> = [];
    couponData.map(datafield => {
      const input = document.getElementById(datafield) as HTMLInputElement | null;
      if (input != null) {
        // the user typed something
        if (input.value.length != 0) {
          console.log(input.value);

          inputs.push(input.value);
        }
      }
    });
    setUserInputs(inputs);
    setDisplayOutputForm(true);
  };

  return (
    <>
      <div id="couponform">
        {/* input form */}
        <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
          <span className="title">Edit your Coupon</span>
          <InputForm />
          <button className="btn" onClick={handleOnClick}>
            {!displayOutputForm ? "Create Coupon" : "Refresh Coupon"}
          </button>
        </div>

        {/* output form */}

        {displayOutputForm && (
          <div id="coupon_preview">
            {/* {setIsAlertVisisAlertVisibleCreateCollectionibleCreateCollection && <div className="notification_success">Coupon successfully created</div>} */}
            <div className="card">
              <span className="title_preview">Coupon Preview</span>
              <CouponTemplate
                userinputs={userInputs}
                preview={true}
                setDisplayOutputForm={setDisplayOutputForm}
                alertColletion={setIsAlertVisibleCreateCollection}
                setID={setID}
                //  handleConfirmation={handleConfirmation}
              />
            </div>
          </div>
        )}

        {displayOutputForm && isAlertVisibleCreateCollection && (
          <div className="notification_success">{`Coupon successfully created with id ${Id}`}</div>
        )}
      </div>
    </>
  );
}

function FormCreateCoupon() {
  return (
    <div>
      <InnerForm />
    </div>
  );
  {
    /* <form> justify-center items-center space-x-2
<label>fff</label>
<input name="fff"></input>
<button type="submit">Create Coupon</button>
</form> */
  }

  // )
}

export default function CreateCoupon() {
  return <FormCreateCoupon />;
}
