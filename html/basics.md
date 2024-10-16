# HTML Basics

## Introduction

A CSS rule consists of a selector and a declaration box.

![selector](files/img_selector.gif)

## Selectors

There are several types of selectors:

- The **element selector** is the most basic and selects elements based on the tag name, such as \<p\>. This is useful for changing the style of the page in one go.

- If you want to use the same HTML tag but style them differently, you can use the **id selector**.

- The **class selector** ignores the tag and lets you style elements by a class name.

## Tables

By default, a table has no borders. 

If you specify a table border style it only applies to the outside of the table.

If you want a border on everything in the table, add the style to th, tr and td.

This is usually aesthetically pleasing. Modern day webapps such as AWS console put a light-gray border on the bottom of each row only.

If you see multiple borders in a table, add the `border-collapse` property. This is most certainly what most people want.

Table cell have no spacing between text and borders by default. To override this behavior, add the `padding` property. A value of 4px is a decent value to start with.

By default, a table will only be as big as the number of columns. This can make small tables look a bit too small. You can change this by adding a `width` property. A value of 70% to 80% will make small tables look better.

Tables with no fill color in the header can look too basic. Add some style to the table header. 

You should set the default font of a table to use sans-serif. Otherwise the serif fonts just don't look good.

It is usually a good idea to make the table cells interactive such as adding hyperlinks. When add hyperlinks, it is best to override the default style to make the colors less gaudy.

