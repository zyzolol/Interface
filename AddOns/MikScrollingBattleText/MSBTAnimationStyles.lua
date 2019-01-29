-------------------------------------------------------------------------------
-- Title: Mik's Scrolling Battle Text Default Animation Styles
-- Author: Mik
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Private constants.
-------------------------------------------------------------------------------

-- How long to show stickies before they are faded.
local STICKY_FADE_IN_TIME = 0.17;
local STICKY_DISPLAY_TIME = 1.5;
local STICKY_FADE_OUT_TIME = 0.5;

-- How long to show static messages before they are faded.
local STATIC_DISPLAY_TIME = 3.15;
local STATIC_FADE_OUT_TIME = 0.5;

-- How long to wait between jiggles.
local JIGGLE_DELAY_TIME = 0.05;

-- The delta to use for the pow effect.
local POW_TEXT_DELTA = 0.7;

-- Default movement speed. (260 pixels every 3 seconds)
local MOVEMENT_SPEED = (3 / 260);

-- Minimum amount of space allowed between two strings.
local MIN_VERTICAL_SPACING = 8;
local MIN_HORIZONTAL_SPACING = 10;


-------------------------------------------------------------------------------
-- Private variables.
-------------------------------------------------------------------------------

-- Last used horizontal Y position and direction.
local lastHorizontalPositionY = {};
local lastHorizontalDirection = {};


-------------------------------------------------------------------------------
-- Imports.
-------------------------------------------------------------------------------

-- Local references to certain functions for faster access.
local math_floor = math.floor;
local math_ceil = math.ceil;
local math_random = math.random;
local math_max = math.max;
local math_abs = math.abs;


-------------------------------------------------------------------------------
-- Pow Sticky functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Animates the passed display event using using the zoom style.
-- ****************************************************************************
local function AnimatePowNormal(displayEvent)
 -- Local references for faster access.
 local displayTime = displayEvent.displayTime;
 local fadeOutTime = displayEvent.fadeOutTime;
 local elapsedTime = displayEvent.elapsedTime;
 
 -- Scale the text height.
 if (elapsedTime <= STICKY_FADE_IN_TIME) then
  local textDelta = displayEvent.fontSize * ((1 - (elapsedTime / STICKY_FADE_IN_TIME)) * POW_TEXT_DELTA);
  displayEvent.fontString:SetTextHeight(displayEvent.fontSize + textDelta);
  return false;
 
 -- Leave the text displayed.
 elseif (elapsedTime <= (STICKY_FADE_IN_TIME + displayTime)) then
  displayEvent.fontString:SetTextHeight(displayEvent.fontSize);
  return false;

 -- Fade out.
 elseif (elapsedTime <= (STICKY_FADE_IN_TIME + displayTime + fadeOutTime)) then
  displayEvent.alpha = 1 - ((elapsedTime - STICKY_FADE_IN_TIME - displayTime) / fadeOutTime);
  return false;
 end

 -- Return true to indicate the animation is complete.
 return true;
end


-- ****************************************************************************
-- Animates the passed display event using using the pow style.
-- ****************************************************************************
local function AnimatePowJiggle(displayEvent)
 -- Local references for faster access.
 local displayTime = displayEvent.displayTime;
 local fadeOutTime = displayEvent.fadeOutTime;
 local elapsedTime = displayEvent.elapsedTime;

 -- Scale the text height.
 if (elapsedTime <= STICKY_FADE_IN_TIME) then
  local textDelta = displayEvent.fontSize * ((1 - (elapsedTime / STICKY_FADE_IN_TIME)) * POW_TEXT_DELTA);
  displayEvent.fontString:SetTextHeight(displayEvent.fontSize + textDelta);
  return false;

 -- Jiggle the text around.
 elseif (elapsedTime <= (STICKY_FADE_IN_TIME + displayTime)) then
  if (elapsedTime - displayEvent.timeLastJiggled > JIGGLE_DELAY_TIME) then
   displayEvent.positionX = displayEvent.originalPositionX + math_ceil(math_random(-1, 1));
   displayEvent.positionY = displayEvent.originalPositionY + math_ceil(math_random(-1, 1));
   displayEvent.timeLastJiggled = elapsedTime;
  end

  displayEvent.fontString:SetTextHeight(displayEvent.fontSize);
  return false;

 -- Fade out.
 elseif (elapsedTime <= (STICKY_FADE_IN_TIME + displayTime + fadeOutTime)) then
  displayEvent.alpha = 1 - ((elapsedTime - STICKY_FADE_IN_TIME - displayTime) / fadeOutTime);
  return false;
 end

 -- Return true to indicate the animation is complete.
 return true;
end


-- ****************************************************************************
-- Initialize the passed display event and reposition the ones that are
-- currently animating in the scroll area to prevent overlaps.
-- ****************************************************************************
local function InitPow(newDisplayEvent, activeDisplayEvents, direction, behavior)
 -- Choose the correct animation function.
 newDisplayEvent.animationHandler = (behavior == "Jiggle") and AnimatePowJiggle or AnimatePowNormal;

 -- Set the new event's starting position.
 local anchorPoint = newDisplayEvent.anchorPoint;
 if (anchorPoint == "BOTTOMLEFT") then
  newDisplayEvent.positionX = 0;
 elseif (anchorPoint == "BOTTOM") then
  newDisplayEvent.positionX = math_ceil(newDisplayEvent.scrollWidth / 2);
 elseif (anchorPoint == "BOTTOMRIGHT") then
  newDisplayEvent.positionX = newDisplayEvent.scrollWidth;
 end
 newDisplayEvent.positionY = math_ceil(newDisplayEvent.scrollHeight / 2);

 -- Save the original x and y positions for calculating the jiggle effect.
 newDisplayEvent.originalPositionX = newDisplayEvent.positionX;
 newDisplayEvent.originalPositionY = newDisplayEvent.positionY;
 newDisplayEvent.timeLastJiggled = 0;
 
 -- Scale the display and fade out times based on the animation speed.
 newDisplayEvent.displayTime = STICKY_DISPLAY_TIME * (1/newDisplayEvent.animationSpeed);
 newDisplayEvent.fadeOutTime = STICKY_FADE_OUT_TIME * (1/newDisplayEvent.animationSpeed);

 -- Set the initial alpha of the new display event to fully visible.
 newDisplayEvent.alpha = 1;

 -- Get the number of sticky display events that are currently animating.
 local numActiveAnimations = #activeDisplayEvents;

 -- Exit if there is no need to check for collisions. 
 if (numActiveAnimations == 0) then return; end

 
 -- Check if the text is scrolling down.
 if (direction == "Down") then
  -- Get the middle sticky.
  local middleSticky = math_floor((numActiveAnimations + 2) / 2);

  -- Set the middle sticky to the center of the scroll area.
  activeDisplayEvents[middleSticky].originalPositionY = newDisplayEvent.scrollHeight / 2;
  activeDisplayEvents[middleSticky].positionY = activeDisplayEvents[middleSticky].originalPositionY;
   
  -- Loop backwards from the middle sticky and move the animating display events so they don't collide.
  for x = middleSticky - 1, 1, -1 do
   activeDisplayEvents[x].originalPositionY = activeDisplayEvents[x+1].originalPositionY - activeDisplayEvents[x].fontSize - MIN_VERTICAL_SPACING;
   activeDisplayEvents[x].positionY = activeDisplayEvents[x].originalPositionY
  end

  -- Loop forwards from the middle sticky and move the animating display events so they don't collide.
  for x = middleSticky + 1, numActiveAnimations do
   activeDisplayEvents[x].originalPositionY = activeDisplayEvents[x-1].originalPositionY + activeDisplayEvents[x-1].fontSize + MIN_VERTICAL_SPACING;
   activeDisplayEvents[x].positionY = activeDisplayEvents[x].originalPositionY
  end

  -- Move the new display event so it doesn't collide.
  newDisplayEvent.originalPositionY = activeDisplayEvents[numActiveAnimations].originalPositionY + activeDisplayEvents[numActiveAnimations].fontSize + MIN_VERTICAL_SPACING;
  newDisplayEvent.positionY = newDisplayEvent.originalPositionY;

 -- Text is scrolling up.
 else
  -- Get the middle sticky.
  local middleSticky = math_ceil(numActiveAnimations / 2);

  -- Set the middle sticky to the center of the scroll area.
  activeDisplayEvents[middleSticky].originalPositionY = newDisplayEvent.scrollHeight / 2;
  activeDisplayEvents[middleSticky].positionY = activeDisplayEvents[middleSticky].originalPositionY;

  -- Loop backwards from the middle sticky and move the animating display events so they don't collide.
  for x = middleSticky - 1, 1, -1 do
   activeDisplayEvents[x].originalPositionY = activeDisplayEvents[x+1].originalPositionY + activeDisplayEvents[x+1].fontSize + MIN_VERTICAL_SPACING;
   activeDisplayEvents[x].positionY = activeDisplayEvents[x].originalPositionY
  end

  -- Loop forwards from the middle sticky and move the animating display events so they don't collide.
  for x = middleSticky + 1, numActiveAnimations do
   activeDisplayEvents[x].originalPositionY = activeDisplayEvents[x-1].originalPositionY - activeDisplayEvents[x].fontSize - MIN_VERTICAL_SPACING;
   activeDisplayEvents[x].positionY = activeDisplayEvents[x].originalPositionY
  end

  -- Move the new display event so it doesn't collide.
  newDisplayEvent.originalPositionY = activeDisplayEvents[numActiveAnimations].originalPositionY - activeDisplayEvents[numActiveAnimations].fontSize - MIN_VERTICAL_SPACING;
  newDisplayEvent.positionY = newDisplayEvent.originalPositionY;
 end
end


-------------------------------------------------------------------------------
-- Straight scroll functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Scrolls the passed display event upwards.
-- ****************************************************************************
local function ScrollUp(displayEvent)
 -- Local references for faster access.
 local scaledScrollTime = displayEvent.scaledScrollTime;
 local elapsedTime = displayEvent.elapsedTime;

 -- Calculate the fade effect start time to be halfway through the animation.
 local fadeStartTime =  scaledScrollTime / 2;

 -- Set the y position based on the elapsed time.
 displayEvent.positionY = math_floor(displayEvent.scrollHeight * (elapsedTime / scaledScrollTime));

 -- Fade the text out once enough time has passed.
 if (elapsedTime >= fadeStartTime) then
  local alpha = 1 - ((elapsedTime - fadeStartTime) / (scaledScrollTime - fadeStartTime));
  displayEvent.alpha = math_max(alpha, 0);
 end

 -- Return true to indicate that the animation is complete when enough time has passed.
 if (elapsedTime >= scaledScrollTime) then return true; end

 -- Return false to indicate the animation is NOT complete.
 return false;
end


-- ****************************************************************************
-- Scrolls the passed display event downwards.
-- ****************************************************************************
local function ScrollDown(displayEvent)
 -- Local references for faster access.
 local scaledScrollTime = displayEvent.scaledScrollTime;
 local elapsedTime = displayEvent.elapsedTime;

 -- Calculate the fade effect start time to be halfway through the animation.
 local fadeStartTime =  scaledScrollTime / 2;

 -- Set the y position based on the elapsed time.
 displayEvent.positionY = displayEvent.scrollHeight - math_floor(displayEvent.scrollHeight * (elapsedTime / scaledScrollTime));

 -- Fade the text out once enough time has passed.
 if (elapsedTime >= fadeStartTime) then
  local alpha = 1 - ((elapsedTime - fadeStartTime) / (scaledScrollTime - fadeStartTime));
  displayEvent.alpha = math_max(alpha, 0);
 end

 -- Return true to indicate that the animation is complete when enough time has passed.
 if (elapsedTime >= scaledScrollTime) then return true; end

 -- Return false to indicate the animation is NOT complete.
 return false;
end


-- ****************************************************************************
-- Initialize the passed display event and reposition the ones that are
-- currently scrolling in the scroll area to prevent overlaps.
-- ****************************************************************************
local function InitStraight(newDisplayEvent, activeDisplayEvents, direction, behavior)
 -- Set the new event's starting X position.
 local anchorPoint = newDisplayEvent.anchorPoint;
 if (anchorPoint == "BOTTOMLEFT") then
  newDisplayEvent.positionX = 0;
 elseif (anchorPoint == "BOTTOM") then
  newDisplayEvent.positionX = math_ceil(newDisplayEvent.scrollWidth / 2);
 elseif (anchorPoint == "BOTTOMRIGHT") then
  newDisplayEvent.positionX = newDisplayEvent.scrollWidth;
 end
 
 -- Calculate how long the animation should take based on the height of the scroll area
 -- and scaled by the animation speed.
 newDisplayEvent.scaledScrollTime = newDisplayEvent.scrollHeight * MOVEMENT_SPEED * (1/newDisplayEvent.animationSpeed);

 -- Set the initial alpha of the new display event to fully visible.
 newDisplayEvent.alpha = 1;

 -- Get the number of display events that are currently scrolling for this style.
 local numActiveAnimations = #activeDisplayEvents;

 -- Scroll text down.
 if (direction == "Down") then
  -- Choose the correct animation function.
  newDisplayEvent.animationHandler = ScrollDown;

  -- Exit if there is no need to check for collisions. 
  if (numActiveAnimations == 0) then return; end

  -- Scale the per pixel time based on the animation speed.
  local perPixelTime = MOVEMENT_SPEED * (1/newDisplayEvent.animationSpeed);
  local currentDisplayEvent = newDisplayEvent;
  local prevDisplayEvent, topTimeCurrent;

  -- Move events that are colliding.
  for x = numActiveAnimations, 1, -1 do
   prevDisplayEvent = activeDisplayEvents[x];

   -- Calculate the elapsed time for the top point of the current display event.
   topTimeCurrent = currentDisplayEvent.elapsedTime + (currentDisplayEvent.fontSize + MIN_VERTICAL_SPACING) * perPixelTime;

   -- Adjust the elapsed time of the previous display event if the current one is colliding with it.
   if (prevDisplayEvent.elapsedTime < topTimeCurrent) then
    prevDisplayEvent.elapsedTime = topTimeCurrent;
   else
    -- Don't continue checking if there is no need.
    break;
   end

   currentDisplayEvent = prevDisplayEvent;
  end

 -- Scroll text up.
 else
  -- Choose the correct animation function.
  newDisplayEvent.animationHandler = ScrollUp;

  -- Exit if there is no need to check for collisions. 
  if (numActiveAnimations == 0) then return; end

  -- Scale the per pixel time based on the animation speed.
  local perPixelTime = MOVEMENT_SPEED * (1/newDisplayEvent.animationSpeed);
  local currentDisplayEvent = newDisplayEvent;
  local prevDisplayEvent, topTimePrev;

  -- Move events that are colliding.
  for x = numActiveAnimations, 1, -1 do
   prevDisplayEvent = activeDisplayEvents[x];

   -- Calculate the elapsed time for the top point of the previous display event.
   topTimePrev = prevDisplayEvent.elapsedTime - (prevDisplayEvent.fontSize + MIN_VERTICAL_SPACING) * perPixelTime;

   -- Adjust the elapsed time of the previous display event if the current one is colliding with it.
   if (topTimePrev < currentDisplayEvent.elapsedTime) then
    prevDisplayEvent.elapsedTime = currentDisplayEvent.elapsedTime + (prevDisplayEvent.fontSize + MIN_VERTICAL_SPACING) * perPixelTime;
   else
    -- Exit if there is no need to continue checking for collisions. 
    return;
   end

   currentDisplayEvent = prevDisplayEvent;
  end
 end -- Direction.
end


-------------------------------------------------------------------------------
-- Parabola scroll functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Scrolls the passed display event in a left parabola upwards.
-- ****************************************************************************
local function ScrollLeftParabolaUp(displayEvent)
 -- Leverage the scroll up logic.
 local animationComplete = ScrollUp(displayEvent);

 -- Calculate the new x position based on equation of a parabola.
 -- Equation of a parabola at vertex 0,0: x = y^2 / 4a
 local y = displayEvent.positionY - displayEvent.midPoint;
 displayEvent.positionX = (y * y) / displayEvent.fourA;

 -- Return whether or not the animation is complete.
 return animationComplete;
end


-- ****************************************************************************
-- Scrolls the passed display event in a left parabola downwards.
-- ****************************************************************************
local function ScrollLeftParabolaDown(displayEvent)
 -- Leverage the scroll up logic.
 local animationComplete = ScrollDown(displayEvent);

 -- Calculate the new x position based on equation of a parabola.
 -- Equation of a parabola at vertex 0,0: x = y^2 / 4a
 local y = displayEvent.positionY - displayEvent.midPoint;
 displayEvent.positionX = (y * y) / displayEvent.fourA;

 -- Return whether or not the animation is complete.
 return animationComplete;
end


-- ****************************************************************************
-- Scrolls the passed display event in a right parabola upwards.
-- ****************************************************************************
local function ScrollRightParabolaUp(displayEvent)
 -- Leverage the scroll up logic.
 local animationComplete = ScrollUp(displayEvent);

 -- Calculate the new x position based on equation of a parabola.
 -- Equation of a parabola at vertex 0,0: x = y^2 / 4a
 local y = displayEvent.positionY - displayEvent.midPoint;
 displayEvent.positionX = displayEvent.scrollWidth - ((y * y) / displayEvent.fourA);

 -- Return whether or not the animation is complete.
 return animationComplete;
end


-- ****************************************************************************
-- Scrolls the passed display event in a right parabola downwards.
-- ****************************************************************************
local function ScrollRightParabolaDown(displayEvent)
 -- Leverage the scroll down logic.
 local animationComplete = ScrollDown(displayEvent);

 -- Calculate the new x position based on equation of a parabola.
 -- Equation of a parabola at vertex 0,0: x = y^2 / 4a
 local y = displayEvent.positionY - displayEvent.midPoint;
 displayEvent.positionX = displayEvent.scrollWidth - ((y * y) / displayEvent.fourA);

 -- Return whether or not the animation is complete.
 return animationComplete;
end


-- ****************************************************************************
-- Initialize the passed display event and reposition the ones that are
-- currently scrolling in the scroll area to prevent overlaps.
-- ****************************************************************************
local function InitParabola(newDisplayEvent, activeDisplayEvents, direction, behavior)
 -- Leverage the straight logic.
 InitStraight(newDisplayEvent, activeDisplayEvents, direction, behavior);

 -- Choose correction animation function. 
 if (direction == "Down") then
   newDisplayEvent.animationHandler = (behavior == "CurvedRight") and ScrollRightParabolaDown or ScrollLeftParabolaDown;
 else
   newDisplayEvent.animationHandler = (behavior == "CurvedRight") and ScrollRightParabolaUp or ScrollLeftParabolaUp;
 end

 -- Calculate the scroll area midpoint.
 local midPoint = newDisplayEvent.scrollHeight / 2;
 newDisplayEvent.midPoint = midPoint;
 
 -- Calculate the parabola focal point.
 -- Equation of a parabola at vertex 0,0: x = y^2 / 4a
 newDisplayEvent.fourA = (midPoint * midPoint) / newDisplayEvent.scrollWidth;
end


-------------------------------------------------------------------------------
-- Horizontal scroll functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Scrolls the passed display event horizontally left.
-- ****************************************************************************
local function ScrollLeft(displayEvent)
 -- Local references for faster access.
 local scaledScrollTime = displayEvent.scaledScrollTime;
 local elapsedTime = displayEvent.elapsedTime;

 -- Calculate the fade effect start time to be halfway through the animation.
 local fadeStartTime =  scaledScrollTime / 2;

 -- Set the x position based on the elapsed time.
 displayEvent.positionX = displayEvent.scrollWidth - math_floor(displayEvent.scrollWidth * (elapsedTime / scaledScrollTime));


 -- Fade the text out once enough time has passed.
 if (elapsedTime >= fadeStartTime) then
  local alpha = 1 - ((elapsedTime - fadeStartTime) / (scaledScrollTime - fadeStartTime));
  displayEvent.alpha = math_max(alpha, 0);
 end

 -- Return true to indicate that the animation is complete when enough time has passed.
 if (elapsedTime >= scaledScrollTime) then return true; end
end


-- ****************************************************************************
-- Scrolls the passed display event horizontally right.
-- ****************************************************************************
local function ScrollRight(displayEvent)
 -- Local references for faster access.
 local scaledScrollTime = displayEvent.scaledScrollTime;
 local elapsedTime = displayEvent.elapsedTime;

 -- Calculate the fade effect start time to be halfway through the animation.
 local fadeStartTime =  scaledScrollTime / 2;

 -- Set the x position based on the elapsed time.
 displayEvent.positionX = math_floor(displayEvent.scrollWidth * (elapsedTime / scaledScrollTime));

 -- Fade the text out once enough time has passed.
 if (elapsedTime >= fadeStartTime) then
  local alpha = 1 - ((elapsedTime - fadeStartTime) / (scaledScrollTime - fadeStartTime));
  displayEvent.alpha = math_max(alpha, 0);
 end

 -- Return true to indicate that the animation is complete when enough time has passed.
 if (elapsedTime >= scaledScrollTime) then return true; end
end


-- ****************************************************************************
-- Reposition the passed display events to prevent overlaps.
-- ****************************************************************************
local function RepositionHorizontalRight(currentDisplayEvent, activeDisplayEvents, startEvent)
 -- Scale the per pixel time based on the animation speed.
 local perPixelTime = MOVEMENT_SPEED * (1/currentDisplayEvent.animationSpeed);

 -- Get the top and bottom points of the current display events.
 local topCurrent = currentDisplayEvent.positionY + currentDisplayEvent.fontSize;
 local bottomCurrent = currentDisplayEvent.positionY;

 local prevDisplayEvent, topPrev, bottomPrev;
 local leftTimePrev, rightTimeCurrent;
 for x = startEvent, 1, -1 do
  -- Get the top and bottom points of the previous display event.
  prevDisplayEvent = activeDisplayEvents[x];
  topPrev = prevDisplayEvent.positionY + prevDisplayEvent.fontSize;
  bottomPrev = prevDisplayEvent.positionY;

  -- Check for a vertical collision.
  if ((topCurrent >= bottomPrev and topCurrent <= topPrev) or (bottomCurrent >= bottomPrev and bottomCurrent <= topPrev)) then
   -- Calculate the elapsed time for the left and right points.
   leftTimePrev = prevDisplayEvent.elapsedTime + (prevDisplayEvent.offsetLeft or 0) * perPixelTime;
   rightTimeCurrent = currentDisplayEvent.elapsedTime + ((currentDisplayEvent.offsetRight or 0) + MIN_HORIZONTAL_SPACING) * perPixelTime;

   -- Adjust the elapsed time of the previous display event if the current one is colliding with it.
   if (leftTimePrev <= rightTimeCurrent) then
    prevDisplayEvent.elapsedTime = rightTimeCurrent + math_abs((prevDisplayEvent.offsetLeft or 0) * perPixelTime);

    -- Move events that are now colliding as a result of moving this one.
    RepositionHorizontalRight(prevDisplayEvent, activeDisplayEvents, x - 1);
   end -- Horizontal collision.
  end -- Vertical collision.
 end
end


-- ****************************************************************************
-- Reposition the passed display events to prevent overlaps.
-- ****************************************************************************
local function RepositionHorizontalLeft(currentDisplayEvent, activeDisplayEvents, startEvent)
 -- Scale the per pixel time based on the animation speed.
 local perPixelTime = MOVEMENT_SPEED * (1/currentDisplayEvent.animationSpeed);

 -- Get the top and bottom points of the current display events.
 local topCurrent = currentDisplayEvent.positionY + currentDisplayEvent.fontSize;
 local bottomCurrent = currentDisplayEvent.positionY;

 local prevDisplayEvent, topPrev, bottomPrev;
 local rightTimePrev, leftTimeCurrent;
 for x = startEvent, 1, -1 do
  -- Get the top and bottom points of the previous display event.
  prevDisplayEvent = activeDisplayEvents[x];
  topPrev = prevDisplayEvent.positionY + prevDisplayEvent.fontSize;
  bottomPrev = prevDisplayEvent.positionY;

  -- Check for a vertical collision.
  if ((topCurrent >= bottomPrev and topCurrent <= topPrev) or (bottomCurrent >= bottomPrev and bottomCurrent <= topPrev)) then
   -- Calculate the elapsed time for the left and right points.
   rightTimePrev = prevDisplayEvent.elapsedTime - ((prevDisplayEvent.offsetRight or 0) + MIN_HORIZONTAL_SPACING) * perPixelTime;
   leftTimeCurrent =  currentDisplayEvent.elapsedTime - (currentDisplayEvent.offsetLeft or 0) * perPixelTime;

   -- Adjust the elapsed time of the previous display event if the current one is colliding with it.
   if (rightTimePrev <= leftTimeCurrent) then
    prevDisplayEvent.elapsedTime = leftTimeCurrent + ((prevDisplayEvent.offsetRight or 0) + MIN_HORIZONTAL_SPACING) * perPixelTime;

    -- Move events that are now colliding as a result of moving this one.
    RepositionHorizontalLeft(prevDisplayEvent, activeDisplayEvents, x - 1);
   end -- Horizontal collision.
  end -- Vertical collision.
 end
end


-- ****************************************************************************
-- Initialize the passed display event and reposition the ones that are
-- currently scrolling in the scroll area to prevent overlaps.
-- ****************************************************************************
local function InitHorizontal(newDisplayEvent, activeDisplayEvents, direction, behavior)
 -- Calculate how long the animation should take based on the width of the scroll area
 -- and scaled by the animation speed.
 newDisplayEvent.scaledScrollTime = newDisplayEvent.scrollWidth * MOVEMENT_SPEED * (1/newDisplayEvent.animationSpeed);

 -- Modify the direction and anchor if the direction is alternating.
 local anchorPoint = newDisplayEvent.anchorPoint;
 if (direction ~= "Left" and direction ~= "Right") then
  -- Select direction and anchor point based on the last event.
  direction = (lastHorizontalDirection[activeDisplayEvents] == "Left") and "Right" or "Left";
  lastHorizontalDirection[activeDisplayEvents] = direction;
  anchorPoint = (direction == "Left") and "BOTTOMRIGHT" or "BOTTOMLEFT";
  newDisplayEvent.anchorPoint = anchorPoint;

  -- Start at the scroll area's mid point.
  newDisplayEvent.elapsedTime = newDisplayEvent.scaledScrollTime / 2;
 end

 -- Calculate the left and right offsets from the anchor point.
 local fontStringWidth = newDisplayEvent.fontString:GetStringWidth();
 if (anchorPoint == "BOTTOMLEFT") then
  newDisplayEvent.offsetLeft = 0;
  newDisplayEvent.offsetRight = fontStringWidth;
 elseif (anchorPoint == "BOTTOM") then
  local halfWidth = fontStringWidth / 2;
  newDisplayEvent.offsetLeft = -halfWidth;
  newDisplayEvent.offsetRight = halfWidth;
 elseif (anchorPoint == "BOTTOMRIGHT") then
  newDisplayEvent.offsetLeft = -fontStringWidth;
  newDisplayEvent.offsetRight = 0;
 end

 -- Set the initial alpha of the new display event to fully visible.
 newDisplayEvent.alpha = 1;


 -- Check if the text is growing down.
 local positionY;
 if (behavior == "GrowDown") then
  -- Calculate the y position based on the last event.
  positionY = lastHorizontalPositionY[activeDisplayEvents] or newDisplayEvent.scrollHeight;
  positionY = positionY - newDisplayEvent.fontSize - MIN_VERTICAL_SPACING;
  if (positionY < 0) then positionY = newDisplayEvent.scrollHeight; end

 -- Text is growing up.
 else
  -- Calculate the y position based on the last event.
  positionY = lastHorizontalPositionY[activeDisplayEvents] or 0;
  positionY = positionY + newDisplayEvent.fontSize + MIN_VERTICAL_SPACING;
  if (positionY > newDisplayEvent.scrollHeight) then positionY = 0; end
 end

 -- Set the y position to the calculated value and save it for the next event.
 newDisplayEvent.positionY = positionY;
 lastHorizontalPositionY[activeDisplayEvents] = positionY;

 -- Get the number of display events that are currently scrolling for this style.
 local numActiveAnimations = #activeDisplayEvents;

 -- Scroll text right.
 if (direction == "Right") then
  -- Choose the correct animation function.
  newDisplayEvent.animationHandler = ScrollRight;

  -- Exit if there is no need to check for collisions. 
  if (numActiveAnimations == 0) then return; end

  -- Move events that are colliding.
  RepositionHorizontalRight(newDisplayEvent, activeDisplayEvents, numActiveAnimations);

 -- Scroll text left.
 else
  -- Choose the correct animation function.
  newDisplayEvent.animationHandler = ScrollLeft;

  -- Exit if there is no need to check for collisions. 
  if (numActiveAnimations == 0) then return; end

  -- Move events that are colliding.
  RepositionHorizontalLeft(newDisplayEvent, activeDisplayEvents, numActiveAnimations);
 end   
end


-------------------------------------------------------------------------------
-- Static scroll functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Animates the passed display event using the static style.
-- ****************************************************************************
local function ScrollStatic(displayEvent)
 -- Local references for faster access.
 local displayTime = displayEvent.displayTime;
 local fadeOutTime = displayEvent.fadeOutTime;
 local elapsedTime = displayEvent.elapsedTime;

 -- Leave the text displayed. 
 if (elapsedTime <= displayTime) then
  return false;

 -- Fade out.
 elseif (elapsedTime <= displayTime + fadeOutTime) then
  displayEvent.alpha = 1 - ((elapsedTime - displayTime) / fadeOutTime);
  return false; 
 end
 
 -- Return true to indicate the animation is complete.
 return true;
end


-- ****************************************************************************
-- Initialize the passed display event and reposition the ones that are
-- currently scrolling in the scroll area to prevent overlaps.
-- ****************************************************************************
local function InitStatic(newDisplayEvent, activeDisplayEvents, direction, behavior)
 -- Set the animation function.
 newDisplayEvent.animationHandler = ScrollStatic;

 -- Set the new event's starting X position.
 local anchorPoint = newDisplayEvent.anchorPoint;
 if (anchorPoint == "BOTTOMLEFT") then
  newDisplayEvent.positionX = 0;
 elseif (anchorPoint == "BOTTOM") then
  newDisplayEvent.positionX = math_ceil(newDisplayEvent.scrollWidth / 2);
 elseif (anchorPoint == "BOTTOMRIGHT") then
  newDisplayEvent.positionX = newDisplayEvent.scrollWidth;
 end
 
 -- Scale the display and fade out times based on the animation speed.
 newDisplayEvent.displayTime = STATIC_DISPLAY_TIME * (1/newDisplayEvent.animationSpeed);
 newDisplayEvent.fadeOutTime = STATIC_FADE_OUT_TIME * (1/newDisplayEvent.animationSpeed);

 -- Set the initial alpha of the new display event to fully visible.
 newDisplayEvent.alpha = 1;

 -- Get the number of display events that are currently animating for this style.
 local numActiveAnimations = #activeDisplayEvents;
 local positionY;
 
 -- Static display is growing downwards. 
 if (direction == "Down") then
  positionY = newDisplayEvent.scrollHeight;

  -- Offset the new display event correctly if there are already animating events.
  if (numActiveAnimations > 0) then
   -- Set the next y position to after the last display event.
   positionY = activeDisplayEvents[numActiveAnimations].positionY - newDisplayEvent.fontSize - MIN_VERTICAL_SPACING;

   -- Wrap the y position if it is outside the scroll area's height.
   if (positionY < 0) then positionY = newDisplayEvent.scrollHeight; end 
  end
  
 -- Static display is growing upwards. 
 else
  positionY = 0;
  
  -- Offset the new display event correctly if there are already animating events.
  if (numActiveAnimations > 0) then
   -- Set the next y position to before the last display event.
   positionY = activeDisplayEvents[numActiveAnimations].positionY + newDisplayEvent.fontSize + MIN_VERTICAL_SPACING;
   
   -- Wrap the y position if it is outside the scroll area's height.
   if (positionY > newDisplayEvent.scrollHeight) then positionY = 0; end

  end
 end

 
 -- Check if there are already animating events.
 if (numActiveAnimations > 0) then
  -- Get the top and bottom points of the new display event.
  local topNew = positionY + newDisplayEvent.fontSize;
  local bottomNew = positionY;

  -- Loop through all the old display events to force old animations that the new one overlaps to complete.
  local oldDisplayEvent, topOld, bottomOld;
  for x = 1, numActiveAnimations - 1 do
   -- Get the top and bottom points of the old display event.
   oldDisplayEvent = activeDisplayEvents[x];
   bottomOld = oldDisplayEvent.positionY;
   topOld = bottomOld + oldDisplayEvent.fontSize;

   -- Force the old animation to complete if the new display event is overlapping it.
   if ((topNew >= bottomOld and topNew <= topOld) or (bottomNew >= bottomOld and bottomNew <= topOld)) then
    oldDisplayEvent.elapsedTime = (STATIC_DISPLAY_TIME + STATIC_FADE_OUT_TIME) * (1/oldDisplayEvent.animationSpeed);
   end
  end
 end

 -- Set the y position to the calculated value. 
 newDisplayEvent.positionY = positionY;
end




-------------------------------------------------------------------------------
-- Load.
-------------------------------------------------------------------------------

-- Register the default animation styles.
MikSBT.RegisterAnimationStyle("Straight", InitStraight, "Up;Down", nil);
MikSBT.RegisterAnimationStyle("Parabola", InitParabola, "Up;Down", "CurvedLeft;CurvedRight");
MikSBT.RegisterAnimationStyle("Horizontal", InitHorizontal, "Alternate;Left;Right", "GrowUp;GrowDown");
MikSBT.RegisterAnimationStyle("Static", InitStatic, "Up;Down", nil);

-- Register the default sticky animation styles.
MikSBT.RegisterStickyAnimationStyle("Pow", InitPow, "Up;Down", "Normal;Jiggle");
MikSBT.RegisterStickyAnimationStyle("Static", InitStatic, "Up;Down", nil);