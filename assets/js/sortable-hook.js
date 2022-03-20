import { Sortable, AutoScroll, OnSpill } from "../vendor/sortablejs/modular/sortable.core.esm"

Sortable.mount(OnSpill);
Sortable.mount(new AutoScroll());

export const SortableHook = {
  mounted() {
    const hook = this;

    new Sortable(hook.el, {
      animation: 0,
      draggable: '.sortable',
      revertOnSpill: true,
      scroll: true,
      onSort: event => {
        hook.pushEventTo(`#${hook.el.id}`, 'moved', {
          from: event.oldDraggableIndex,
          to: event.newDraggableIndex,
        });
      }
    });
  }
}
