--应敌模块-Set
local m=20000301
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000300") end) then require("script/c20000300") end
function cm.initial_effect(c)
	local e0=fu.copy(c,m)
	local e1=fu.give(c,m,EVENT_MSET,function(e,tp,eg,ep,ev,re,r,rp)return rp==1-tp end,
		function(c,tp,e)return c:IsFacedown() and (not e or c:IsRelateToEffect(e))end,EVENT_SSET,0)
end
