import "@rainbow-me/rainbowkit/styles.css";
import { Metadata } from "next";
import { ScaffoldEthAppWithProviders } from "~~/components/ScaffoldEthAppWithProviders";
import { ThemeProvider } from "~~/components/ThemeProvider";
import "~~/styles/globals.css";
import CouponsProvider from "~~/components/CouponsProvider";
import { platformName } from "~~/utils/platfom/name";

const baseUrl = process.env.VERCEL_URL
  ? `https://${process.env.VERCEL_URL}`
  : `http://localhost:${process.env.PORT || 3000}`;
const imageUrl = `${baseUrl}/thumbnail.jpg`;

const title = `${platformName} App`;
const titleTemplate = `%s | ${platformName}`;

const description = "Built with 🏗 Scaffold-ETH 2";

export const metadata: Metadata = {
  metadataBase: new URL(baseUrl),
  title: {
    default: title,
    template: titleTemplate,
  },
  description,
  openGraph: {
    title: {
      default: title,
      template: titleTemplate,
    },
    description,
    images: [
      {
        url: imageUrl,
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    images: [imageUrl],
    title: {
      default: title,
      template: titleTemplate,
    },
    description,
  },
  icons: {
    icon: [{ url: "/favicon.png", sizes: "32x32", type: "image/png" }],
  },
};



const ScaffoldEthApp = ({ children }: { children: React.ReactNode }) => {

  

  return (
    <html suppressHydrationWarning>
      <body>
      

        <ThemeProvider enableSystem>
        <CouponsProvider>
          <ScaffoldEthAppWithProviders>{children}</ScaffoldEthAppWithProviders>
        </CouponsProvider>
          
        </ThemeProvider>
      </body>
    </html>
  );
};

export default ScaffoldEthApp;
