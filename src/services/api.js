import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
});

function getAuthorizedConfig() {
  const token = localStorage.getItem('token');
  if (token) {
    return {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };
  }
  return {};
}

// ----------------- Auth -----------------

export const login = (data) => api.post('/v1/cms/auth/login', data);
export const register = (data) => api.post('/v1/cms/auth/register', data);

// ----------------- Todo -----------------

export const getTodos = (params=null) => api.get('/v1/cms/todo', {...getAuthorizedConfig(), params});
export const getTodo = (id) => api.get(`/v1/cms/todo/${id}`, getAuthorizedConfig());
export const createTodo = (data) => api.post('/v1/cms/todo', data, getAuthorizedConfig());
export const updateTodo = (id, data) => api.put(`/v1/cms/todo/${id}`, data, getAuthorizedConfig());
export const updateStatusTodo = (id, data) => api.put(`/v1/cms/todo/${id}/status`, data, getAuthorizedConfig());
export const deleteTodo = (id) => api.delete(`/v1/cms/todo/${id}`, getAuthorizedConfig());

// ----------------- Quotes -----------------

export const fetchQuote = () => api.get('/v1/cms/dashboard/get-quote', getAuthorizedConfig());

