const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
    content: [
        './public/*.html',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/views/**/*.{erb,haml,html,slim}',
    ],
    theme: {
        fontSize: {
            sm: ['0.8rem'],
            base: ['16px', '24px'],
            lg: ['1.25rem'],
            xl: ['1.5625rem'],
            '2xl': ['2rem'],
            '3xl': ['2.4415rem'],
            '5xl': ['3rem'],
            '6xl': ['5rem'],
        },
        extend: {
            fontFamily: {
                sans: ['Inter var', ...defaultTheme.fontFamily.sans],
            },
            colors: {
                projectPurple: '#9448bc',
                projectPurpleLighter: '#ae54de',
                projectGreen: '#3ddd78',
                projectWhite: '#f5f5fa',
                projectPaperWhite: '#e4e4e8',
                projectBlack: '#343434',
                projectRed: '#cc2936',
            },
        },
    },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        require('@tailwindcss/container-queries'),
    ],
};
