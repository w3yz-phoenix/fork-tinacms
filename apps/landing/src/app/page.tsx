import { LandingCardSection } from "@/components/card/landing-card-section";
import { CommunityComponent } from "@/components/community/community";
import { Eticaret } from "@/components/eticaret/eticaret";
import { Integrations } from "@/components/integrations/integrations";
import { PriceCardSection } from "@/components/price/price-card-section";
import { Templates } from "@/components/templates/templates";
import { WorkTogether } from "@/components/work-together/work-together";

const Home = () => {
  return (
    <>
      <div className="bg-white">
        <Eticaret />
        <LandingCardSection />
        <Integrations />
        <Templates />
        <CommunityComponent />
        <PriceCardSection />
        <WorkTogether />
      </div>
    </>
  );
};

export default Home;
