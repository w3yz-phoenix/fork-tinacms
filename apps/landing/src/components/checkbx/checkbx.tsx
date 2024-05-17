import { useState } from "react";

export default function Checkbx({ label = "Beni Hatırla" }) {
  const [isChecked, setIsChecked] = useState<boolean>(false);

  const toggleCheckbox = () => {
    setIsChecked(!isChecked);
  };

  return (
    <label className="flex items-center cursor-pointer text-[#464C5E] font-medium">
      <input
        type="checkbox"
        className="w-0 h-0 opacity-0 form-checkbox"
        checked={isChecked}
        onChange={toggleCheckbox}
      />
      {isChecked ? (
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="18"
          height="18"
          viewBox="0 0 18 18"
          fill="none"
          className="mr-1"
        >
          <path
            d="M13.7498 1.58997C15.2198 1.58997 16.4198 2.74272 16.4963 4.19397L16.5 4.34022V13.8397C16.5 15.3097 15.3472 16.5097 13.896 16.5862L13.7498 16.59H4.25025C3.54613 16.59 2.86882 16.32 2.35785 15.8355C1.84689 15.3511 1.54119 14.6891 1.50375 13.986L1.5 13.8397V4.34022C1.5 2.87022 2.65275 1.67022 4.104 1.59372L4.25025 1.58997H13.7498ZM11.7802 7.05972C11.6396 6.91911 11.4489 6.84013 11.25 6.84013C11.0511 6.84013 10.8604 6.91911 10.7198 7.05972L8.25 9.52872L7.28025 8.55972L7.20975 8.49747C7.05901 8.38091 6.86955 8.3261 6.67986 8.34417C6.49016 8.36224 6.31446 8.45183 6.18844 8.59476C6.06241 8.73768 5.99551 8.92322 6.00133 9.11368C6.00714 9.30414 6.08524 9.48525 6.21975 9.62022L7.71975 11.1202L7.79025 11.1825C7.93455 11.2944 8.11474 11.3498 8.29701 11.3384C8.47928 11.3269 8.65111 11.2493 8.78025 11.1202L11.7802 8.12022L11.8425 8.04972C11.9544 7.90541 12.0099 7.72522 11.9984 7.54295C11.987 7.36069 11.9094 7.18886 11.7802 7.05972Z"
            fill="#183ADD"
          />
        </svg>
      ) : (
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="18"
          height="18"
          viewBox="0 0 18 18"
          fill="none"
          className="mr-1"
        >
          <g clipPath="url(#clip0_749_128)">
            <path
              d="M4.25025 15.84H4.25021C3.73811 15.84 3.2455 15.6436 2.87388 15.2913C2.50456 14.9411 2.28268 14.4634 2.25322 13.9556L2.25 13.8301V4.34022C2.25 3.27458 3.08327 2.40345 4.13416 2.34319L4.25986 2.33997H13.7498C14.8154 2.33997 15.6865 3.17323 15.7468 4.22412L15.75 4.34984V13.8397C15.75 14.9053 14.9167 15.7765 13.8658 15.8367L13.7401 15.84H4.25025Z"
              stroke="#8A94A6"
              stroke-width="1.5"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </g>
          <defs>
            <clipPath id="clip0_749_128">
              <rect
                width="18"
                height="18"
                fill="white"
                transform="translate(0 0.0899658)"
              />
            </clipPath>
          </defs>
        </svg>
      )}
      {label}
    </label>
  );
}
