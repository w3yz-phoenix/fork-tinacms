import { type Collection } from "tinacms";

import { heroSliderBlockSchema } from "../blocks/hero-slider/hero-slider";
import { featuresBlockSchema } from "../blocks/features/features";
import { productListBlockSchema } from "../blocks/product-list/product-list";
import { imageTextHeroBlockSchema } from "../blocks/image-text-hero/image-text-hero";
import { blogCardHomeBlockSchema } from "../blocks/blog-card-home/blog-card-home";
import { commentSliderBlockSchema } from "../blocks/comment-slider/comment-slider";
import { blogCardSliderBlockSchema } from "../blocks/blog-card-slider/blog-card-slider";
import { TrioPhotoTextBlockSchema } from "../blocks/trio-photo-text/trio-photo-text";
import { discountBlockSchema } from "../blocks/discount/discount";
import { policyBlockSchema } from "../blocks/policy/policy";
import { productBlockSchema } from "../blocks/product/product";
import { profileAddressBlockSchema } from "../blocks/profile-address/profile-address";
import { profileNavigationBlockSchema } from "../blocks/profile-navigation/profile-navigation";
import { profileResetPasswordBlockSchema } from "../blocks/profile-reset-password/profile-reset-password";
import { profilePersonalInformationBlockSchema } from "../blocks/profile-personal-information/profile-personal-information";
import { profileOrdersBlockSchema } from "../blocks/profile-orders/profile-orders";
import { ContactInfoBlockSchema } from "../blocks/contact-info/contact-info";

export const PageCollection: Collection = {
  name: "page",
  label: "Page",
  path: "content/pages",
  format: "mdx",
  ui: {
    router: ({ document }) => `/${document._sys.breadcrumbs.join("/")}`,
  },
  fields: [
    {
      type: "string",
      label: "Title",
      name: "title",
      description:
        "The title of the page. This is used to display the title in the CMS",
      isTitle: true,
      required: true,
    },
    {
      type: "object",
      list: true,
      name: "blocks",
      label: "Sections",
      ui: {
        visualSelector: true,
      },
      templates: [
        featuresBlockSchema,
        heroSliderBlockSchema,
        productListBlockSchema,
        imageTextHeroBlockSchema,
        blogCardHomeBlockSchema,
        commentSliderBlockSchema,
        blogCardSliderBlockSchema,
        TrioPhotoTextBlockSchema,
        discountBlockSchema,
        policyBlockSchema,
        productBlockSchema,
        profileAddressBlockSchema,
        profileNavigationBlockSchema,
        profileResetPasswordBlockSchema,
        profilePersonalInformationBlockSchema,
        profileOrdersBlockSchema,
        ContactInfoBlockSchema,
      ],
    },
  ],
};
