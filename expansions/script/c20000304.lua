--应敌模块-Add
local m=20000304
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000300") end) then require("script/c20000300") end
function cm.initial_effect(c)
	local e0=fu.copy(c,m)
	local e1=fu.give(c,m,EVENT_TO_HAND,function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetCurrentPhase()~=PHASE_DRAW end,
	function(c,tp)return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)end,0,0)
end
