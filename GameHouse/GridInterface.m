
#import "GridInterface.h"

Position PositionOfIndexInGrid(int index, GridSize gridSize, Orientation gridOrientation)
{
    return gridOrientation == VERTICAL ?
                (Position){index / gridSize.columns, index % gridSize.columns} :
                (Position){index % gridSize.rows, index / gridSize.rows};
}

int IndexOfPositionInGrid(Position position, GridSize gridSize, Orientation gridOrientation)
{
    return gridOrientation == VERTICAL ?
                gridSize.columns * position.row + position.column :
                gridSize.rows * position.column + position.row;
}

#pragma

/*Position PositionFromValue(NSValue *value)
{
    Position pos;
    if ([value isKindOfClass:[NSValue class]]) {
        [value getValue:&pos];
    }
    
    return pos;
}*/

/*int IndexOfPositionInGridOfSize(Position position, GridSize gridSize)
{
    return gridSize.columns * position.row + position.column;
}

Position PositionForIndexInGridOfSize(int index, GridSize gridSize)
{
    return (Position){index / gridSize.columns, index % gridSize.columns};
}*/

BOOL PositionsAreAdjacent(Position pos1, Position pos2)
{
    if (abs(pos1.row - pos2.row) <= 1 && abs(pos1.column - pos2.column) <= 1) {
        return (pos1.row == pos2.row) ^ (pos1.column == pos2.column);
    }
    
    return NO;
}

BOOL PositionsAreEqual(Position pos1, Position pos2)
{
    return pos1.row == pos2.row && pos1.column == pos2.column;
}

NSString *StringFromGridSize(GridSize gridSize)
{
    return [NSString stringWithFormat:@"%dx%d", gridSize.rows, gridSize.columns];
}

