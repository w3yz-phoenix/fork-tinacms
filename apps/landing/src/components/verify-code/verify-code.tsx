import { useState, useRef, useEffect } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";

const VerificationCodeInput = () => {
  const router = useRouter();

  const [verificationCode, setVerificationCode] = useState<string[]>([
    "",
    "",
    "",
    "",
    "",
    "",
  ]);
  const [focusedIndex, setFocusedIndex] = useState<number>(0);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [isCodeCorrect, setIsCodeCorrect] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string>("");

  const inputReferences = useRef<any[]>([]);

  const emptyBoxCount = verificationCode.filter((value) => value === "").length;
  const isButtonDisabled: any =
    emptyBoxCount > 0 ||
    !verificationCode.every((value) => /^\d+$/.test(value)) ||
    isLoading ||
    errorMessage;

  const handleInputChange = (index: number, event: any) => {
    const value = event.target.value;

    if (value.length === 1 && index < inputReferences.current.length - 1) {
      inputReferences.current[index + 1].focus();
    }

    const updatedVerificationCode = [...verificationCode];
    updatedVerificationCode[index] = value;
    setVerificationCode(updatedVerificationCode);
    if (errorMessage) {
      setErrorMessage("");
    }
  };

  const handleInputKeyDown = (index: number, event: any) => {
    if (event.key === "Backspace") {
      event.preventDefault();
      const updatedVerificationCode = [...verificationCode];
      updatedVerificationCode[index] = "";
      setVerificationCode(updatedVerificationCode);

      if (index > 0) {
        inputReferences.current[index - 1].focus();
      }
    }
  };

  const handleInputFocus = (index: number) => {
    setFocusedIndex(index);
  };

  const handleInputBlur = () => {
    setFocusedIndex(-1);
  };

  useEffect(() => {
    inputReferences.current[0].focus();
  }, []);

  const handleCodeSubmit = async (event: any) => {
    event.preventDefault();

    if (verificationCode.length === 6) {
      const code = verificationCode.join("");
      setIsLoading(true);

      // Simüle API
      setTimeout(() => {
        if (code === "000000") {
          setIsCodeCorrect(true);
          setErrorMessage("");
          setTimeout(() => {
            router.push("/login/new-password");
          }, 500);
        } else {
          setIsCodeCorrect(false);
          setErrorMessage("Lütfen kodu kontrol edin ve tekrar deneyin.");
        }
        setIsLoading(false);
      }, 1500);
    }
  };

  return (
    <div>
      <div className="flex">
        {verificationCode.map((value, index) => (
          <input
            key={index}
            ref={(element: any) => (inputReferences.current[index] = element)}
            type="text"
            maxLength={1}
            value={value}
            onChange={(event) => handleInputChange(index, event)}
            onKeyDown={(event) => handleInputKeyDown(index, event)}
            onFocus={() => handleInputFocus(index)}
            onBlur={handleInputBlur}
            className={`text-w3yz-verify-code mr-3 h-16 w-16 rounded-md border text-center text-4xl focus:outline-none ${
              focusedIndex === index
                ? "border-2 border-[#90BCFF]"
                : "border-[#B3B9C6]"
            } ${value ? "border-[#3670FB]" : ""} ${
              errorMessage && !isCodeCorrect
                ? "cursor-not-allowed border-[#EF5244] text-[#B9291C]"
                : ""
            }`}
          />
        ))}
      </div>
      {errorMessage && (
        <p className="mt-1 text-start text-[14px] font-medium text-[#DC3526]">
          {errorMessage}
        </p>
      )}
      <button
        type="submit"
        className={`mb-[20px] mt-[32px] w-full rounded-lg border bg-[#3670FB] px-4 py-2 font-medium text-white ${
          isButtonDisabled
            ? "cursor-not-allowed bg-[#DFEAFF] text-[#BDD5FF]"
            : ""
        }`}
        onClick={handleCodeSubmit}
        disabled={isButtonDisabled}
      >
        {isLoading ? (
          <div className="flex items-center justify-center">
            <div className="animate-spin">
              <Image
                src="/assets/spinner.svg"
                alt="W3yz Logo"
                width={22}
                height={22}
                style={{
                  maxWidth: "100%",
                  height: "auto",
                }}
              />
            </div>
          </div>
        ) : isCodeCorrect ? (
          <div className="flex items-center justify-center">
            <Image
              src="/assets/check-white.svg"
              alt="check"
              width={22}
              height={22}
              className="mr-2"
              style={{
                maxWidth: "100%",
                height: "auto",
              }}
            />
            Devam Et
          </div>
        ) : (
          "Devam Et"
        )}
      </button>
    </div>
  );
};

export default VerificationCodeInput;
