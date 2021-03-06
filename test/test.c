#include <stdio.h>
#include <unistd.h>
#include "Graphics/graphics.h"

char* my_string(void* item){
  return (char*)item;
}

int main()
{
  GUI* g = init_gui(NULL);
  create_main_window(g,"Test Window");
  set_main_size(g,300, 300);

  WIDGET* box = create_combobox(20,10,10,my_string);
  WIDGET* but = create_button("Hello",50,50);
  add_item_to_combobox(box,"Test 1");
  add_to_main(g,box);
  add_to_main(g,but);

  show_main(g);
  while(gui_running(g)){
    sleep(1);
  }

  destroy_gui(g);
  return 0;
}
