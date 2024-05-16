"use client";

import { usePageQuery, type TinaGraphql_PageQuery } from "@w3yz/cms/api";

import { FeaturesBlock } from "#ui/furniture/blocks/features/features";
import { HeroSliderBlock } from "#ui/furniture/blocks/hero-slider/hero-slider";
import { ProductListBlock } from "#ui/furniture/blocks/product-list/product-list";
import { ImageTextHero } from "#ui/furniture/blocks/image-text-hero/image-text-hero";
import { BlogCard } from "#ui/furniture/blocks/blog-card/blog-card";
import { CommentSliderBlock } from "#ui/furniture/blocks/comment-slider/comment-slider";
import { BlogCardSlider } from "#ui/furniture/blocks/blog-card-slider/blog-card-slider";
import { TrioPhotoText } from "#ui/furniture/blocks/trio-photo-text/trio-photo-text";
import { DiscountsBlock } from "#ui/furniture/blocks/discount/discount";
// eslint-disable-next-line import/namespace
import { PolicyBlock } from "#ui/furniture/blocks/policy/policy";
// eslint-disable-next-line import/namespace, import/order
import { ProductBlock } from "#ui/furniture/blocks/product/product";

// eslint-disable-next-line import/no-unresolved
//import { ProfileAddressBlock } from "#ui/furniture/blocks/profile-address/profile-address";
// eslint-disable-next-line import/no-unresolved
// import { ProfileNavigationBlock } from "#ui/furniture/blocks/profile-navigation/profile-navigation";
// import { ProfileResetPasswordBlock } from "#ui/furniture/blocks/profile-reset-password/profile-reset-password";
// import { ProfilePersonalInformationBlock } from "#ui/furniture/blocks/profile-personal-information/profile-personal-information";
// import { ProfileOrdersBlock } from "#ui/furniture/blocks/profile-orders/profile-orders";

import { useTinaQuery } from "../../hooks";
import { ContactInfo } from "../../../furniture/blocks/contact-info/contact-info";

export const PageClient = (props: { relativePath: string }) => {
  const { page } = useTinaQuery<TinaGraphql_PageQuery>(usePageQuery, {
    relativePath: props.relativePath,
  });

  return (
    <div>
      {page?.blocks?.map((block, index) => {
        if (!block) return null;

        switch (block.__typename) {
          case "PageBlocksFeatures": {
            return <FeaturesBlock key={index} block={block} />;
          }
          case "PageBlocksHeroSlider": {
            return <HeroSliderBlock key={index} block={block} />;
          }
          case "PageBlocksProductList": {
            return <ProductListBlock key={index} block={block} />;
          }
          case "PageBlocksImageTextHero": {
            return <ImageTextHero key={index} block={block} />;
          }
          case "PageBlocksBlogCardHome": {
            return <BlogCard key={index} block={block} />;
          }
          case "PageBlocksCommentSlider": {
            return <CommentSliderBlock key={index} block={block} />;
          }
          case "PageBlocksBlogCardSlider": {
            return <BlogCardSlider key={index} block={block} />;
          }
          case "PageBlocksTrioPhotoText": {
            return <TrioPhotoText key={index} block={block} />;
          }
          case "PageBlocksDiscounts": {
            return <DiscountsBlock key={index} block={block} />;
          }
          case "PageBlocksPolicy": {
            return <PolicyBlock key={index} block={block} />;
          }
          case "PageBlocksProduct": {
            return <ProductBlock key={index} block={block} />;
          }
          // case "PageBlocksProfileAddress": {
          //   return <ProfileAddressBlock key={index} block={block} />;
          // }
          // case "PageBlocksProfileNavigation": {
          //   return <ProfileNavigationBlock key={index} block={block} />;
          // }
          // case "PageBlocksProfileResetPassword": {
          //   return <ProfileResetPasswordBlock key={index} block={block} />;
          // }
          // case "PageBlocksProfilePersonalInformation": {
          //   return (
          //     <ProfilePersonalInformationBlock key={index} block={block} />
          //   );
          // }
          // case "PageBlocksProfileOrders": {
          //   return <ProfileOrdersBlock key={index} block={block} />;
          // }
          case "PageBlocksContactInfo": {
            return <ContactInfo key={index} block={block} />;
          }
          default: {
            return (
              <div>
                <pre>{JSON.stringify(block, null, 2)}</pre>
              </div>
            );
          }
        }
      })}
    </div>
  );
};
