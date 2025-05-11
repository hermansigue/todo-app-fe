import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '../pages/Dashboard.vue'
import Login from '../pages/Login.vue'
import Register from '../pages/Register.vue'
import Todo from '../pages/Todo.vue'

const routes = [
  { path: '/', redirect: '/login', },
  { path: '/login', component: Login, name: 'login' },
  { path: '/register', component: Register, name: 'register' },
  { path: '/dashboard', component: Dashboard, name: 'dashboard' },
  { path: '/todo', component: Todo, name: 'todo' },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('token');
  if ((to.name === 'login' || to.name === 'register') && isAuthenticated) {
    next({ name: 'dashboard' });
  }else if (!isAuthenticated && to.name !== 'login' && to.name !== 'register') {
    next({ name: 'login' });
  }else {
    next();
  }
});



export default router
