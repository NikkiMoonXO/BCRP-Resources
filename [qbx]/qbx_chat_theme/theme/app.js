(function () {
    const chatConfig = {
        logo: 'https://r2.fivemanage.com/AW5LdVxdoruQsCYgIZNym/logo2.png',
        position: 'left', // left,right,top,bottom
    }

    // Prefix Logo Side //
    const prefixSelect = document.querySelector('.prefix')
    prefixSelect.innerHTML = ""; // reset
    prefixSelect.style.backgroundImage = `url(${chatConfig.logo})`;

    // Chat Position //
    const chat = document.querySelector('.chat-input')
    chat.style.top = 'inherit';
    chat.style.right = 'inherit';
    chat.style.bottom = 'inherit';
    chat.style.left = 'inherit';

    switch (chatConfig.position) {
        case 'left':
            chat.style.top = '30%';
            chat.style.left = '0.8%';
            break;
        case 'right':
            chat.style.top = '30%';
            chat.style.right = '0.8%';
            break;
        case 'top':
            chat.style.top = '5%';
            chat.style.left = '40%';
            break;
        case 'bottom':
            chat.style.bottom = '5%';
            chat.style.left = '40%';
            break;
        default:
            console.log('Invalid position');
    }


})();