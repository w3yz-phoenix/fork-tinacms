import edjsHTML from "editorjs-html";
import xss from "xss";

const parser = edjsHTML();

export const DangerousSaleorRichText = ({ json }: { json?: string | null }) => {
  const blocks = json ? parser.parse(JSON.parse(json)) : undefined;

  if (!blocks) return;

  return (
    <div className="mt-8 space-y-6">
      {blocks.map((content) => (
        <div key={content} dangerouslySetInnerHTML={{ __html: xss(content) }} />
      ))}
    </div>
  );
};
