--Orth Saints IO
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104208)
function cm.initial_effect(c)
	local e0,e0_1=rkch.PenTri(c,m,rscost.lpcost(1000))
	local e1=rkch.PenAdd(c,{m,1},{1,m+1},{nil,cm.con,cm.target,cm.op},true)
	local e2=rsef.SC(c,EVENT_SUMMON_SUCCESS)
	e2:RegisterSolve(nil,nil,nil,cm.seop)
	local e3=rsef.QO(c,EVENT_FREE_CHAIN,{m,2},{1},"des",EFFECT_FLAG_CARD_TARGET,LOCATION_MZONE,rkch.gaincon(m),cm.eqcost,rstg.target(cm.eqfilter,"des",LOCATION_MZONE,LOCATION_MZONE),cm.eqop)
	local e4=rkch.MonzToPen(c,m,EVENT_RELEASE,false)
end
cm.dff=true
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0xccd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if sg then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.desfilter(c)
	return not c:IsRace(RACE_WARRIOR) or c:IsFacedown()
end
function cm.seop(e,tp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_ADVANCE) then return false end
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.eqfilter(c,ec)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:GetColumnGroupCount()>0
end
function cm.eqop(e,tp)
	local tc=Duel.GetFirstTarget()
	if tc then
		local g=tc:GetColumnGroup()
		Duel.Destroy(g,REASON_EFFECT)
	end
end