import { Layout } from "@@ui/furniture/layout/layout";
import { Page } from "@@ui/core/components/page/page";

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
