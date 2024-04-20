
import { http, createConfig, WagmiProvider } from 'wagmi'
import { mainnet, sepolia, goerli } from 'wagmi/chains'
import { walletConnect, injected, coinbaseWallet } from 'wagmi/connectors'

import { cookieStorage, createStorage } from 'wagmi'
import { QueryClient } from '@tanstack/react-query'
import { defaultWagmiConfig } from '@web3modal/wagmi/react/config'

// doc https://docs.walletconnect.com/web3modal/react/about

// 0. Setup queryClient
const queryClient = new QueryClient()

// 1. Get projectId at https://cloud.walletconnect.com
export const projectId = 'efc3c7fc3d9dab0817cdead6a77b09f8'

// 2. Create wagmiConfig
const metadata = {
  name: 'Webshop eWeb3Coupons',
  description: 'Webshop eWeb3Coupons',
  url: "http://localhost:3000/",//'https://my-quote-app-react.vercel.app/',//'http://localhost:3000',//'https://web3modal.com', // origin must match your domain & subdomain
  icons: ['https://avatars.githubusercontent.com/u/37784886']
}

export const config = createConfig({
  chains: [mainnet, sepolia],
  transports: {
    [mainnet.id]: http(),
    [sepolia.id]: http()
  },
  connectors: [
    walletConnect({ projectId, metadata, showQrModal: false }),
   injected({ shimDisconnect: true }),
    coinbaseWallet({
      appName: metadata.name,
      appLogoUrl: metadata.icons[0]
    })
  ],
  ssr: true,
  storage: createStorage({
    storage: cookieStorage
  })
})


export const configWagmiDefault = defaultWagmiConfig({
  projectId,
  chains: [mainnet, sepolia],
  metadata: {
    name: 'My App',
    description: 'My app description',
    url: 'https://myapp.com',
    icons: ['https://myapp.com/favicon.ico']
  },
  storage: createStorage({
    storage: cookieStorage
  }),
  ssr: true
})