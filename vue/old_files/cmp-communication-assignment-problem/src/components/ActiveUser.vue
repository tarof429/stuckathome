<template>
    <ul>
        <li>
            <strong>User name:</strong>
            {{ userName }}
        </li>
        <li>
            <strong>Age:</strong>
            {{ userAge }}
        </li>
    </ul>
</template>


<script>
export default {
    props: {
        userName: { type: String, required: true},
        userAge: { type: String, required: true},
  },
}
</script>
