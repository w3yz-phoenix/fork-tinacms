"use client";

import { useEffect } from "react";
import gsap from "gsap";

import { CardSectionLeft, CardSectionRight } from "#landing/icons/card-section";

import { Card, CardProperties } from "./card";

interface LandingCardProperties {
  cardListTop: CardProperties[];
  cardListMiddle: CardProperties[];
  cardListBottom: CardProperties[];
}

export const LandingCards = ({
  cardListTop,
  cardListMiddle,
  cardListBottom,
}: LandingCardProperties) => {
  useEffect(() => {
    const animateLetters = () => {
      gsap.to("#firstIcon", {
        duration: 1,
        y: 15,
        delay: 0,
        transform: "translate(0px, 0px) scale(1)",
        visibility: "inherit",
        scale: 1,
        repeat: -1,
        rotationZ: 500,
        yoyo: true,
      });
      gsap.to("#secondtIcon", {
        duration: 1,
        y: 15,
        x: 10,
        delay: 0,
        transform: "translate(0px, 0px) scale(1)",
        visibility: "inherit",
        scale: 1,
        repeat: -1,
        rotation: 5000,
        yoyo: true,
      });
    };

    animateLetters();
  }, []);

  return (
    <div className="relative flex flex-col gap-4">
      <CardSectionRight
        id="firstIcon"
        className="absolute right-[-156px] top-[74px] max-4xl:hidden"
      />
      <CardSectionLeft
        id="secondtIcon"
        className="absolute bottom-[164px] left-[-167px] max-4xl:hidden"
      />
      <div className="flex gap-4 max-sm:flex-col ">
        <Card
          size={cardListTop[0].size}
          title={cardListTop[0].title}
          description={cardListTop[0].description}
          image={cardListTop[0].image}
        />
        <div className="flex flex-col gap-4">
          <div className="flex gap-4">
            <Card
              size={cardListTop[1].size}
              title={cardListTop[1].title}
              description={cardListTop[1].description}
              image={cardListTop[1].image}
            />
            <Card
              size={cardListTop[2].size}
              title={cardListTop[2].title}
              description={cardListTop[2].description}
              image={cardListTop[2].image}
            />
          </div>
          <Card
            size={cardListTop[3].size}
            title={cardListTop[3].title}
            description={cardListTop[3].description}
            image={cardListTop[3].image}
          />
        </div>
      </div>
      <div className="grid grid-cols-3 justify-items-center gap-2 max-sm:grid-cols-2 md:gap-4 ">
        {cardListMiddle.map((card, index) => (
          <Card
            key={index}
            size={card.size}
            title={card.title}
            description={card.description}
            image={card.image}
          />
        ))}
      </div>
      <div className="flex gap-4 max-sm:flex-col ">
        <Card
          size={cardListBottom[0].size}
          title={cardListBottom[0].title}
          description={cardListBottom[0].description}
          image={cardListBottom[0].image}
        />
        <div className="flex flex-col gap-4">
          <div className="flex gap-4">
            <Card
              size={cardListBottom[1].size}
              title={cardListBottom[1].title}
              description={cardListBottom[1].description}
              image={cardListBottom[1].image}
            />
            <Card
              size={cardListBottom[2].size}
              title={cardListBottom[2].title}
              description={cardListBottom[2].description}
              image={cardListBottom[2].image}
            />
          </div>
          <Card
            size={cardListBottom[3].size}
            title={cardListBottom[3].title}
            description={cardListBottom[3].description}
            image={cardListBottom[3].image}
          />
        </div>
      </div>
    </div>
  );
};
