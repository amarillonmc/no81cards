--方舟骑士-卡达
c29052475.named_with_Arknight=1
function c29052475.initial_effect(c)
	aux.AddCodeList(c,29052476)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29052475,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29052475)
	e1:SetCost(c29052475.thcost)
	e1:SetTarget(c29052475.thtg)
	e1:SetOperation(c29052475.thop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29052475,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,29052476)
	e2:SetTarget(c29052475.tktg)
	e2:SetOperation(c29052475.tkop)
	c:RegisterEffect(e2)
end
c29052475.kinkuaoi_Akscsst=true
function c29052475.refilter(c,tp)
	return c:IsType(TYPE_TOKEN) and c:IsReleasableByEffect()
end
function c29052475.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29052476,0,TYPES_TOKEN_MONSTER,1000,1000,5,RACE_MACHINE,ATTRIBUTE_LIGHT)) or (Duel.IsExistingMatchingCard(c29052475.refilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c29052475.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,29052476,0,TYPES_TOKEN_MONSTER,1000,1000,5,RACE_MACHINE,ATTRIBUTE_LIGHT)
	local b2=Duel.IsExistingMatchingCard(c29052475.refilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(29052475,1)},{b2,aux.Stringid(29052475,2)})
	if op==1 then
		local token=Duel.CreateToken(tp,29052476)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	if op==2 then
		local rg=Duel.SelectMatchingCard(tp,c29052475.refilter,tp,LOCATION_MZONE,0,1,1,nil)
		if Duel.Release(rg,REASON_EFFECT)>0 then
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
				Duel.HintSelection(g)
				local tc=g:GetFirst()
				Duel.Destroy(tc,REASON_EFFECT) 
			end
		end
	end
end















--e1
function c29052475.thfilter(c,e,tp)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c.kinkuaoi_Akscsst
end
function c29052475.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c29052475.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c29052475.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29052475.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29052475.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end












