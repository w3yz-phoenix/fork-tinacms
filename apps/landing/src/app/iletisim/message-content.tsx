/* eslint-disable @next/next/no-img-element */
interface MessageContentProperties {
  name: string;
  lastName: string;
  email: string;
  phone: string;
  message: string;
}

export const MessageContent: React.FC<Readonly<MessageContentProperties>> = ({
  name,
  lastName,
  email,
  phone,
  message,
}) => (
  <div className="flex flex-col items-center justify-center">
    <div className="mx-auto max-w-[80%]">
      <div className="overflow-hidden rounded border border-solid border-gray-950">
        <div className="px-5">
          <img
            src="https://img.freepik.com/free-photo/chat-message-blue-speech-bubble-icon-with-bell-notification-alert-notice-reminder-symbol-conversation-button-icon-symbol-background-3d-illustration_56104-2067.jpg?w=1380&t=st=1711975730~exp=1711976330~hmac=952bc31fcc322abf9c9af1c61ee95f96170c28ff9427bf80859bce5dce070d69"
            alt="Yelp Header"
            className="block w-full border-none outline-none"
            width={300}
          />
        </div>
        <div className="px-5 py-3">
          <div className="text-center">
            <h1 className="text-2xl font-bold">Merhaba W3yz,</h1>
            <h2 className="text-xl font-bold">
              Müşterinizden bir mesajınız var
            </h2>
            <p className="mt-4 text-base leading-6">
              <b>Ad Soyad: </b>
              {name} {lastName}
            </p>
            <p className="text-base leading-6">
              <b>E-mail: </b> {email}
            </p>
            <p className="text-base leading-6">
              <b>Telefon: </b> {phone}
            </p>
            <p className="mb-10 pb-10 text-base leading-6">
              <b>Mesaj: </b> {message}
            </p>
          </div>
        </div>
        <div className="w-full px-5 pt-3">
          <img
            src="https://react-email-demo-jsqyb0z9w-resend.vercel.app/static/yelp-footer.png"
            alt="W3yz Footer"
            className="block w-full border-none outline-none"
            width={620}
          />
        </div>
        <p className="mt-3 text-center text-xs leading-6 text-gray-700">
          &copy; 2022 W3yz| Çifte Havuzlar Mah. Eski Londra Asfaltı Cad. Kuluçka
          Mrk. A1 Blok No: 151 /1C İç Kapı No: B34 ESENLER/ İSTANBUL |
          https://w3yz.com
        </p>
      </div>
    </div>
  </div>
);
