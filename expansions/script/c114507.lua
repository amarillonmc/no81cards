--里械仪者·血仪者
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114507)
function cm.initial_effect(c)
	local e1 = rsef.QO(c,EVENT_CHAINING,"dis",{1,m},"dis,des,pos,sp","dcal",LOCATION_HAND,rscon.discon(cm.disfilter,true),nil,cm.distg,cm.disop)
	local e2 = rsef.STO_FLIP(c,"sp",{1,m+100},"sp","de",nil,nil,rsop.target(rscf.spfilter2(Card.IsType,TYPE_RITUAL),"sp",LOCATION_GRAVE),cm.spop)
end
function cm.disfilter(e,tp,re,rp)
	local ev = Duel.GetCurrentChain()
	if ev < 2 then return false end
	local re2,rp2 = Duel.GetChainInfo(ev-1 , CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_CONTROLER)
	return ev >= 2 and rp2 == tp and re2:IsActiveType(TYPE_FLIP)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
end
function cm.disop(e,tp,eg,ep,ev,re)
	local c = rscf.GetSelf(e)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		local tc = rsop.SelectSolve(HINTMSG_POSCHANGE,tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,1,nil,{}):GetFirst()
		if tc and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) > 0 and c and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 then
			local spos=0
			if c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then spos=spos+POS_FACEUP_ATTACK end
			if c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
			Duel.SpecialSummon(c,0,tp,tp,false,false,spos)
			if c:IsFacedown() then
				Duel.ConfirmCards(1-tp,c)
			end
		end
	end
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(rscf.spfilter2(Card.IsType,TYPE_RITUAL)),tp,LOCATION_GRAVE,0,1,1,nil,{})
end