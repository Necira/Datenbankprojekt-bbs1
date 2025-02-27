<template>
    <footer>
        <div class="centered-container">
            <div class="footer-left-side">
                <b>
                    <a href="https://github.com/Necira/Datenbankprojekt-bbs1" target="_blank">
                        Checkout the Github-Repository</a
                    >
                </b>
            </div>
            <div class="footer-right-side">
                <h1>Meet our team</h1>
                <div class="teammember-links">
                    <a href="https://github.com/LouisLohmer" target="_blank">Louis</a>
                    <a href="https://github.com/Necira" target="_blank">Maria</a>
                    <a href="https://github.com/Krauseberger" target="_blank">Dominik</a>
                    <a href="https://github.com/Skroli0702" target="_blank">Oliver</a>
                </div>
            </div>
        </div>
    </footer>
</template>

<style scoped>
footer {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    width: 100%;
    height: fit-content;
    background-color: var(--black);
    color: var(--white);
    text-align: center;
}

.centered-container {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: row;
    padding-top: 5px;
    padding-bottom: 5px;
}

h1 {
    margin: 0 0 10px 0;
    font-size: 23px;
}

a,
li a {
    color: var(--white);
    text-decoration: none;
}

a:hover,
li a:hover {
    color: var(--green);
    text-decoration: underline;
    text-decoration-color: var(--green);
    font-weight: 900;
}

li {
    text-align: left;
}

ul {
    margin: 0;
}

.teammember-links {
    display: flex;
    gap: 15px;
}

.footer-left-side {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding-right: 30px;
}

.footer-right-side {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    border-left: solid 3px var(--white);
    padding-left: 30px;
}
</style>
