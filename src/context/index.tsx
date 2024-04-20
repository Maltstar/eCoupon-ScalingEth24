// context/config.tsx

'use client'

import React, { ReactNode } from 'react'
import { config, projectId } from '@/config/index'

import { createWeb3Modal, useWeb3ModalEvents, useWeb3ModalState } from '@web3modal/wagmi/react'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

import { State, WagmiProvider } from 'wagmi'
import { watchAccount } from '@wagmi/core'

// Setup queryClient
const queryClient = new QueryClient()



if (!projectId) throw new Error('Project ID is not defined')

// Create modal
createWeb3Modal({
  wagmiConfig: config,
  projectId,
  enableAnalytics: true, // Optional - defaults to your Cloud configuration
  themeMode: 'dark',
  themeVariables: {
    '--w3m-accent': '#965b02ef',
    
  }
})

export function ContextProvider({
  children,
  initialState
}: {
  children: ReactNode
  initialState?: State
}) {
  //  const state = useWeb3ModalState()
  //  const events = useWeb3ModalEvents()
  //  const unwatch = watchAccount(config, {
  //   onChange(data) {
  //     console.log('Account changed!', data)
  //   },
  // })
  // unwatch()
  return (
    <WagmiProvider config={config} initialState={initialState}>
      <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
      {/* <pre>{JSON.stringify(state, null, 2)}</pre> */}
      {/* <pre>{JSON.stringify(events, null, 2)}</pre> */}
    </WagmiProvider>
  )
}
