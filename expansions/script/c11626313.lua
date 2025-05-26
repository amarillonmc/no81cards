--隐匿虫的繁衍
local m=11626313
local cm=_G["c"..m]
function c11626313.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--02
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tfilter(c)
	return c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tafilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and cm.ctfilter(chkc) end   
	if chk==0 then 
		local g=Duel.GetMatchingGroup(cm.tafilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
		local gg=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_MZONE,0,nil)
		return gg:GetCount()>0 and g:GetCount()>1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
end
function cm.spfilter(c,e,tp,ra)
	return c:IsRace(ra) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	local sg=Duel.GetMatchingGroup(cm.spfilter,1-tp,LOCATION_DECK,0,nil,e,1-tp,tc:GetRace())
	if hc:IsRelateToEffect(e) and hc:IsControler(tp) and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 and hc:IsLocation(LOCATION_HAND) and tc:IsRelateToEffect(e) then
		if tc:IsControler(tp) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
		if tc:IsControler(1-tp) and sg:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg1=sg:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sg1,0,1-tp,1-tp,false,false,POS_FACEUP)
			local tc2=sg1:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_INSECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
		end
	end
end
--
function cm.costfil(c,tp) 
	return c:IsRace(RACE_INSECT) and c:IsType(TYPE_MONSTER) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE,0,1,c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
   if chk==0 then return Duel.CheckReleaseGroupEx(tp,cm.costfil,1,REASON_COST,false,nil,tp) end  
	local g=Duel.SelectReleaseGroupEx(tp,cm.costfil,1,1,REASON_COST,false,nil,tp)
	Duel.Release(g,REASON_COST) 
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and cm.ctfilter(chkc) end   
	if chk==0 then 
		local g=Duel.GetMatchingGroup(cm.tafilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
		local gg=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_MZONE,0,nil)
		return gg:GetCount()>0 and g:GetCount()>1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	local sg=Duel.GetMatchingGroup(cm.spfilter,1-tp,LOCATION_DECK,0,nil,e,1-tp,tc:GetRace())
	if hc:IsRelateToEffect(e) and hc:IsControler(tp) and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 and hc:IsLocation(LOCATION_HAND) and tc:IsRelateToEffect(e) then
		if tc:IsControler(tp) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
		if tc:IsControler(1-tp) and sg:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg1=sg:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sg1,0,1-tp,1-tp,false,false,POS_FACEUP)
			local tc2=sg1:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_INSECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
		end
	end
	if Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		local dg=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoHand(dg,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,dg)
	end
end