import { Layout, Page } from "@w3yz/core";

export default async function TinaPage({
  params,
}: {
  params: { slugs?: string[] };
}) {
  return (
    <Layout globalConfigPath="main.yml">
      <Page relativePath={`${params.slugs?.join("/")}.mdx`} />
    </Layout>
  );
}
