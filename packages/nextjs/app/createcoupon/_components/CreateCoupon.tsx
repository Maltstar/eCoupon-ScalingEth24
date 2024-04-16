import Link from "next/link"
import { useState } from "react"
import { useCouponContext } from "~~/components/CouponsProvider"

export type couponDataField = [
    "Name",
    "Discount %",
    "Max amount",
    "Expire date",
    "Vendor Name",
    "Vendor shop link"
]

export const couponData:couponDataField = [
    "Name",
    "Discount %",
    "Max amount",
    "Expire date",
    "Vendor Name",
    "Vendor shop link"
]



export const couponPlaceholders = [
    "Get -10% on Adidas",
    "10",
    "1024",
    "10/12/2024",
    "Amazon",
    "https://www.amazon.com/s?k=Adidas"
]

function InputForm()
{
        return (
            <div className="inputwithlabel">

            
                    {
                    couponData.map((datafield,i) => {
                    return(
                    <div key={`datacoupon_${datafield}`} className="input_label">
                        <label>{datafield}</label>
                        <input  id={datafield} name={datafield} placeholder={"e.g: " + couponPlaceholders[i]}></input>
                    </div>
                    )
                })
            }
        </div>
    )
}




interface CouponTemplateProps
{
    userinputs:Array<string>,
    preview:boolean,
    setDisplayOutputForm?:(flag:boolean) => void,
    handleConfirmation?:() => void

}

export function CouponTemplate({userinputs,preview,setDisplayOutputForm,handleConfirmation}:CouponTemplateProps )
{
    console.log("CouponTemplate");
    const {couponsData,SetCouponsData} = useCouponContext()

    const handleVisitShop = (url:URL) =>
        {
            window.open(url, '_blank');
        }
    const handleOnConfirm = () =>
    {
        if(SetCouponsData != undefined && handleConfirmation != undefined)
        {
            const couponsDataLocal = couponsData
            couponsDataLocal.unshift(userinputs)
            SetCouponsData(couponsDataLocal)
            handleConfirmation()
        }
       
    }

        const handleClose = () =>
        {
            if(setDisplayOutputForm != null)
            {
                setDisplayOutputForm(false)
            }
        }

    return (
        <>
        <div>

            <div className="outputwithlabel">

                { 
                
                couponData.map((datafield,index) => {
                    console.log("datafield",datafield);
                    
                    switch(datafield)
                    {
                        case "Name":
                            return(<h2 key={`data_${datafield}`} className="title">{userinputs[index]}</h2>)
  
                        case "Vendor shop link":
                            
                            return(
                            <div key={`data_${datafield}`} className="output_label">
                                <label>{datafield} : </label>
                                <button className="link_shop" onClick={() => {handleVisitShop(userinputs[index] as unknown as URL) }}>visit shop</button>
                            </div>)

                        default:
                            return(
                        
                                <div key={`data_${datafield}`}  className="output_label">
                                <label>{datafield} : </label>
                                <span className="outputvalues" id={`of_${datafield}`}> {userinputs[index]}</span>
                            </div>
                            )
                        

                    }               
                })
            }
        </div>
        
    </div>
    {   
        preview ?
        <div className="buttons_preview">
            <button className="btn button_outform" onClick={handleClose}>Close</button>
            <Link className="btn button_outform" href="/">Go to Home</Link>
            <button className="btn button_outform" onClick={handleOnConfirm}>Confirm</button>
            
        </div>
        :
        <button id="btn_mint"className="btn button_outform" >Mint</button>

    }
        
    </>
)
}



function InnerForm()
{
     const [displayOutputForm, setDisplayOutputForm] = useState(false)
     const [userInputs,setUserInputs] = useState([] as Array<string>)
     const [ isAlertVisible, setIsAlertVisible ] = useState(false);

     const handleConfirmation = () => {
         setIsAlertVisible(true);
 
         setTimeout(() => {
             setIsAlertVisible(false);
         }, 3000);
     }
    
    const handleOnClick = () =>
        {
            const inputs: Array<string> = []
            couponData.map((datafield) => {
                const input = document.getElementById(datafield) as HTMLInputElement | null;
                if(input != null)
                {
        
                        // the user typed something
                        if(input.value.length != 0)
                        {
                            console.log(input.value);
                            
                            inputs.push(input.value)
                        }
                }
            })
            setUserInputs(inputs)
            setDisplayOutputForm(true)
            
            



        }
     
    return(
        <>
        <div id="couponform">

        
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
                {/* <div className="p-5 divide-y divide-base-600"> */}
                    <span className="title">Edit your Coupon</span>
                    <InputForm/>
                    <button className="btn" onClick={handleOnClick}>{!displayOutputForm ? "Create Coupon":"Refresh Coupon"}</button>
                {/* </div> */}
            </div>
                
                

                {displayOutputForm && 
                <div id="coupon_preview">
                    { isAlertVisible && <div className="notification_success" >Coupon successfully created</div>}
                  {/* <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl"> */}
                   <div className="card">

                        <span className="title_preview">Coupon Preview</span>
                        <CouponTemplate userinputs={userInputs} preview={true} setDisplayOutputForm={setDisplayOutputForm} handleConfirmation={handleConfirmation}/>
                    </div>
                
                </div>

                }
            
         </div>
        </>
        


    )
}


function FormCreateCoupon()
{
     
    return(
        <div >
            {/* <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">

                <div className="p-5 divide-y divide-base-300"> */}
                    {/* <form>
                        {
                            couponData.map((datafield) =>
                            {

                                return(<div className="input_label">
                            <label>{datafield}</label>
                            <input name={datafield}></input>
                        </div>)
                            })
                        }
 
                        <button type="submit">Create Coupon</button>
                    </form> */}
                    <InnerForm/>

                {/* </div>

                </div> */}
        </div>

)
{/* <form> justify-center items-center space-x-2
<label>fff</label>
<input name="fff"></input>
<button type="submit">Create Coupon</button>
</form> */}

   // )
}

export default function CreateCoupon()
{

    return <FormCreateCoupon/>

}