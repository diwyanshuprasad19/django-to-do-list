# todos/views.py
from django.shortcuts import render, get_object_or_404, redirect
from django.views import generic
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from .models import Todo


class IndexView(generic.ListView):
    template_name = 'todos/index.html'
    context_object_name = 'todo_list'

    @method_decorator(login_required)
    def dispatch(self, *args, **kwargs):
        return super().dispatch(*args, **kwargs)

    def get_queryset(self):
        """Return all the latest todos for the logged-in user."""
        return Todo.objects.filter(user=self.request.user).order_by('-created_at')


@login_required
def add(request):
    title = request.POST.get('title')
    if title:
        Todo.objects.create(title=title, user=request.user)
    return redirect('index')  # Use named URL pattern


@login_required
def delete(request, todo_id):
    todo = get_object_or_404(Todo, pk=todo_id, user=request.user)
    todo.delete()
    return redirect('index')  # Use named URL pattern


@login_required
def update(request, todo_id):
    todo = get_object_or_404(Todo, pk=todo_id, user=request.user)
    isCompleted = request.POST.get('isCompleted', False) == 'on'
    todo.isCompleted = isCompleted
    todo.save()
    return redirect('index')  # Use named URL pattern
