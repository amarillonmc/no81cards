--创生之海
function c9910803.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910803)
	e1:SetTarget(c9910803.rmtg)
	e1:SetOperation(c9910803.rmop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910804)
	e2:SetCost(c9910803.thcost)
	e2:SetTarget(c9910803.thtg)
	e2:SetOperation(c9910803.thop)
	c:RegisterEffect(e2)
end
function c9910803.rmfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemove()
end
function c9910803.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	if chk==0 then return Duel.IsExistingTarget(c9910803.rmfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
		and tc and tc:IsCanBeEffectTarget(e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910803.rmfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetTargetCard(tc)
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910803.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910803.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 or Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=2 then return end
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local flag=false
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9910801,0x6951,0x4011,0,500,1,RACE_FAIRY,ATTRIBUTE_LIGHT)
		and Duel.SelectYesNo(tp,aux.Stringid(9910803,0)) then
		if not flag then Duel.BreakEffect() end
		local token=Duel.CreateToken(tp,9910801)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			flag=true
			ft=ft-1
		end
	end
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9910802,0x6951,0x4011,500,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT)
		and Duel.SelectYesNo(tp,aux.Stringid(9910803,1)) then
		if not flag then Duel.BreakEffect() end
		local token=Duel.CreateToken(tp,9910802)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			flag=true
			ft=ft-1
		end
	end
	if flag then Duel.SpecialSummonComplete() end
end
function c9910803.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c9910803.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9910803.thfilter(c)
	return c:IsSetCard(0x6951) and c:GetCode()~=9910803 and c:IsAbleToHand()
end
function c9910803.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910803.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910803.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910803.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
