import { type ReactNode } from "react";
import { cookieToInitialState } from 'wagmi'
import { config } from '@/config'
import { ContextProvider } from '@/context'
import { headers } from "next/headers";

export const metadata = {
	title: "Saleor Storefront example",
	description: "Starter pack for building performant e-commerce experiences with Saleor.",
};
const initialState = cookieToInitialState(config, headers().get('cookie'))

export default function RootLayout(props: { children: ReactNode }) {
	return 
	<ContextProvider initialState={initialState}>
		<w3m-button/>
			<main>{props.children}</main>
	</ContextProvider>

	
}
