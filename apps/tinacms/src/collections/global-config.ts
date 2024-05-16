import type { Collection } from "tinacms";

import { defineTinaTemplate } from "../lib/tina.utils";

import { PageCollection } from "./page";

const linkTemplate = defineTinaTemplate({
  name: "link",
  label: "Link",
  ui: {
    itemProps: (item: any) => {
      return {
        label: item?.label,
      };
    },
  },
  fields: [
    {
      name: "label",
      label: "Label",
      type: "string",
    },
    {
      name: "page",
      label: "Page",
      type: "reference",
      collections: [PageCollection.name],
    },
  ],
});

const shoppingCartTemplate = defineTinaTemplate({
  name: "shoppingCart",
  label: "Shopping Cart",
  ui: {
    itemProps: () => {
      return {
        label: "Shopping Cart",
      };
    },
    defaultItem: {
      badgeColor: "#EC4815",
    },
  },
  fields: [
    {
      name: "badgeColor",
      label: "Badge Color",
      type: "string",
      ui: {
        component: "color",
        colorFormat: "hex",
        colors: ["#EC4815", "#241748", "#B4F4E0", "#E6FAF8"],
        widget: "sketch",
      },
    },
  ],
});

const profilePageTemplate = defineTinaTemplate({
  name: "profile",
  label: "Profile",
  ui: {
    itemProps: () => {
      return {
        label: "Profile",
      };
    },
    defaultItem: {
      badgeColor: "#EC4815",
    },
  },
  fields: [
    {
      name: "name",
      label: "Name",
      type: "string",
    },
  ],
});

export const GlobalConfigCollection: Collection = {
  label: "Global Configurations",
  name: "globalConfig",
  path: "content/global-config",
  format: "yml",
  ui: {
    allowedActions: {
      create: false,
      delete: false,
    },
    global: false,
    router: (...params) => {
      console.log("params", params);
      return "/";
    },
  },
  fields: [
    {
      name: "header",
      label: "Header",
      type: "object",
      fields: [
        {
          name: "logo",
          label: "Logo",
          type: "object",
          fields: [
            {
              name: "src",
              label: "Image",
              type: "image",
              required: true,
            },
            {
              name: "alt",
              label: "Alt",
              type: "string",
            },
            {
              name: "link",
              label: "Link",
              type: "reference",
              collections: [PageCollection.name],
            },
          ],
        },
        {
          type: "object",
          list: true,
          name: "links",
          label: "Links",
          templates: [linkTemplate, shoppingCartTemplate, profilePageTemplate],
        },
      ],
    },
    {
      name: "footer",
      label: "Footer",
      type: "object",
      fields: [
        {
          name: "logo",
          label: "Logo",
          type: "object",
          fields: [
            {
              name: "src",
              label: "Image",
              type: "image",
              required: true,
            },
            {
              name: "alt",
              label: "Alt",
              type: "string",
            },
            {
              name: "link",
              label: "Link",
              type: "reference",
              collections: [PageCollection.name],
            },
          ],
        },
        {
          type: "object",
          list: true,
          name: "linksName",
          label: "Links Name",
          ui: {
            max: 4,
          },
          fields: [
            { type: "string", name: "title", label: "title" },
            {
              type: "object",
              list: true,
              name: "links",
              label: "Links",
              ui: { max: 5 },
              templates: [linkTemplate],
            },
          ],
        },
        {
          name: "odemelogo",
          label: "odemeLogo",
          type: "object",
          fields: [
            {
              name: "src",
              label: "Image",
              type: "image",
              required: true,
            },
            {
              name: "alt",
              label: "Alt",
              type: "string",
            },
          ],
        },
      ],
    },
  ],
};
