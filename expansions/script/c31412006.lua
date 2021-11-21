local m=31412006
local cm=_G["c"..m]
cm.name="黑泽喜太@超能竹马组"
if not pcall(function() require("expansions/script/c31412000") end) then require("script/c31412000") end
function cm.initial_effect(c)
	Seine_Quirk_Buddy.usual_form_enable(c,ATTRIBUTE_DARK)
end