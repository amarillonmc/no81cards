--冰汽时代 先行者
local m=33502202
local cm=_G["c"..m]
Duel.LoadScript("c33502200.lua")
function cm.initial_effect(c)
	local e1=syu.turnup(c,m,nil,nil,cm.turnupop,CATEGORY_SUMMON)
	local e2=syu.tograve(c,m,nil,nil,cm.gop,CATEGORY_SEARCH)
end
function cm.spfilter(c,e,tp)
	return c:IsSummonable(true,nil)
end
function cm.turnupop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		if not Duel.IsPlayerAffectedByEffect(tp,33502206) then Duel.SetLP(tp,Duel.GetLP(tp)-1000) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Summon(tp,sg:GetFirst(),true,nil)
	end
end
function cm.filter(c,tp)
	return c:IsCode(33502200) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) then return end
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		local b1=te:IsActivatable(tp,true,true)
		if b1 then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end