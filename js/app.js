$(function () {
    $(".single-item").slick({
        infinite: true,
        dots: true,
        arrows: false,
        autoplay: true,
        autoplaySpeed: 3000,
        fade: true,
        fadeSpeed: 1000,
    });
});

const animItems = document.querySelectorAll("._anim-items");

if (animItems.length > 0) {
    window.addEventListener("scroll", animOnScroll);
    function animOnScroll(params) {
        for (let index = 0; index < animItems.length; index++) {
            const animItem = animItems[index];
            const animItemHeight = animItem.offsetHeight;
            const animItemOffset = offset(animItem).top;
            const animStart = 4;

            let animItemPoint = window.innerHeight - animItemHeight / animStart;
            if (animItemHeight > window.innerHeight) {
                animItemPoint = window.innerHeight - window.innerHeight / animStart;
            }

            if (
                scrollY > animItemOffset - animItemPoint &&
                scrollY < animItemOffset + animItemHeight
            ) {
                animItem.classList.add("_active");
            } else {
                if (!animItem.classList.contains("_anim-no-hide")) {
                    animItem.classList.remove("_active");
                }
            }
        }
    }

    function offset(el) {
        const rect = el.getBoundingClientRect(),
            scrollLeft = scrollX || document.documentElement.scrollLeft,
            scrollTop = scrollY || document.documentElement.scrollTop;
        return { top: rect.top + scrollTop, left: rect.left + scrollLeft };
    }

    setTimeout(() => {
        animOnScroll();
    }, 300);
}

$(document).ready(function () {
    const slider = $(".slider");

    slider.slick({
        arrows: false,
        dots: true,
        adaptiveHeight: false,
        slidesToShow: 1,
        slidesToScroll: 1,
        responsive: [
            {
                breakpoint: 1640,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1,
                    infinite: true,
                    dots: true,
                },
            },
            {
                breakpoint: 575,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1,
                    dots: false,
                    draggable: true,
                },
            },
        ],
        speed: 1000,
        easing: "linear",
        infinite: true,
        initialSlide: 0,
        autoplay: true,
        autoplaySpeed: 5000,
        pauseOnFocus: true,
        pauseOnHover: true,
        pauseOnDotsHover: true,
        draggable: false,
        swipe: true,
        touchThreshold: 5,
    });
});
