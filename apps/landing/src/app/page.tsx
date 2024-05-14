import { LandingCardSection } from "#landing/components/card/landing-card-section";
import { CommunityComponent } from "#landing/components/community/community";
import { Eticaret } from "#landing/components/eticaret/eticaret";
import { Integrations } from "#landing/components/integrations/integrations";
import { PriceCardSection } from "#landing/components/price/price-card-section";
import { Templates } from "#landing/components/templates/templates";
import { WorkTogether } from "#landing/components/work-together/work-together";

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
