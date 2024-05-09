import { cn } from "#shadcn/lib/utils";

interface SpinnerProperties {
  label: string;
  className?: string;
}
export const Spinner = ({ label, className }: SpinnerProperties) => {
  return (
    <div
      aria-label="Loading..."
      role="status"
      className="absolute left-0 top-0 z-50 flex size-full items-center justify-center space-x-2 bg-[#2D2D2D]/40"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke="#2D2D2D"
        className={cn("h-16 w-16", className)}
      >
        {Array.from({ length: 8 }).map((_, index) => (
          <line
            key={index}
            x1="12"
            y1="2"
            x2="12"
            y2="6"
            stroke="#D9D9D9"
            transform={`rotate(${45 * index} 12 12)`}
          >
            <animate
              attributeName="stroke"
              values="##2D2D2D; #D9D9D9;"
              dur="1.5s"
              repeatCount="indefinite"
              begin={`${0.125 * index}s`}
            />
          </line>
        ))}
      </svg>
      <span className="text-4xl font-medium text-[#D9D9D9]">{label}</span>
    </div>
  );
};
