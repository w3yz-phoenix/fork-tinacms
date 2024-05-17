import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "#shadcn/components/accordion";

export enum CheckoutStep {
  CONTACT = "contact",
  ADDRESS = "address",
  AWAITING_PAYMENT = "awaiting-payment",
  CONFIRMATION = "confirmation",
}

export function CheckoutFormAccordion(props: {
  children: React.ReactNode;
  currentStep: `${CheckoutStep}`;
}) {
  return (
    <div className="mt-10 w-full">
      <Accordion type="single" disabled value={props.currentStep}>
        <AccordionItem key={CheckoutStep.CONTACT} value={CheckoutStep.CONTACT}>
          <AccordionTrigger>Iletisim Bilgileri</AccordionTrigger>
          <AccordionContent>
            {CheckoutStep.CONTACT === props.currentStep ? props.children : ""}
          </AccordionContent>
        </AccordionItem>

        <AccordionItem key={CheckoutStep.ADDRESS} value={CheckoutStep.ADDRESS}>
          <AccordionTrigger>Adres Bilgileri</AccordionTrigger>
          <AccordionContent>
            {CheckoutStep.ADDRESS === props.currentStep ? props.children : ""}
          </AccordionContent>
        </AccordionItem>

        <AccordionItem
          key={CheckoutStep.AWAITING_PAYMENT}
          value={CheckoutStep.AWAITING_PAYMENT}
        >
          <AccordionTrigger>Odeme Adimi</AccordionTrigger>
          <AccordionContent>
            {CheckoutStep.AWAITING_PAYMENT === props.currentStep
              ? props.children
              : ""}
          </AccordionContent>
        </AccordionItem>
      </Accordion>
    </div>
  );
}
