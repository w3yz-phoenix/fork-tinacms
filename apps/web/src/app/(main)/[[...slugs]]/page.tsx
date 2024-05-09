import { Page } from "#ui/core/components/page/page";

export default function CatchAllPage({
  params,
}: {
  params: { slugs?: string[] };
}) {
  return <Page relativePath={`${params.slugs?.join("/")}.mdx`} />;
}
