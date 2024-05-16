import { imageField } from "../../fields/image";
import { linkField } from "../../fields/link";
import { defineTinaTemplate } from "../../lib/tina.utils";

export const ContactInfoBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const ContactInfoBlockSchema = defineTinaTemplate({
  name: "ContactInfo",
  label: "Contact Informations",
  ui: {
    previewSrc: "/blocks/image-text-hero/preview.png",
    defaultItem: {
      supportTitle: "Destek",
      supportSubtitle: "Size yardım etmek için buradayız",
      supportEmail: "support@example.com",
      salesTitle: "Satış",
      salesSubtitle: "Sorularınız mı var? iletşime geçelim",
      salesEmail: "sales@example.com",
      phoneTitle: "Telefon",
      phoneSubtitle: "Pazartesi - Cuma saat 08.00- 17.00",
      phoneNumber: "05xx xxx xx xx",
      items: [ContactInfoBlockDefaultItem],
    },
  },
  fields: [
    {
      type: "string",
      label: "Support Title",
      name: "supportTitle",
    },
    {
      type: "string",
      label: "Support subtitle",
      name: "supportSubtitle",
    },
    {
      type: "string",
      label: "Support Email",
      name: "supportEmail",
    },
    {
      type: "string",
      label: "Sales Title",
      name: "salesTitle",
    },
    {
      type: "string",
      label: "Sales subtitle",
      name: "salesSubtitle",
    },
    {
      type: "string",
      label: "Sales Email",
      name: "salesEmail",
    },
    {
      type: "string",
      label: "Phone Title",
      name: "phoneTitle",
    },
    {
      type: "string",
      label: "Phone subtitle",
      name: "phoneSubtitle",
    },
    {
      type: "string",
      label: "Phone Number",
      name: "phoneNumber",
    },
  ],
});
