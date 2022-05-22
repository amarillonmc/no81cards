--奉神天使 王冠
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e = {fu_god.Counter(c,CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY,EVENT_SUMMON,0,cm.con,cm.tg,cm.op,EVENT_SPSUMMON)}
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_EFFECT)
		fu_god.Reg(e,m,tp)
end