function inside_box(x, y, box)
    return x >= box[1] and x <= box[1] + box[3] and y >= box[2] and y <= box[2] + box[4]
end