def contextLoader():
    """
    This function loads the context of the current environment and returns it as a list of strings.
    Currently limited to 4 lines of the text file
    """
    context = []
    with open("./backend/src/restaurantData/llmContext.txt",'r') as f:
        for i in range(0,len(f.readlines())):
            if(i<4):
                context.append(f.readline())
    
    return context