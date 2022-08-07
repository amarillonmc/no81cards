local m=15000850
local cm=_G["c"..m]
cm.name="修珀川的游侠·苍穹α"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,15000862)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	--Search&SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCountLimit(1,15000850)
	e3:SetCondition(cm.spcon)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return c:IsSetCard(0x9f3c) and c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.eqfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*1000
end
function cm.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function cm.eqsfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and Duel.IsExistingMatchingCard(cm.eqmfilter,tp,LOCATION_DECK,0,1,nil,c) and not c:IsPublic()
end
function cm.eqmfilter(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x9f3c) and tc:CheckEquipTarget(c) and c:IsAbleToHand()
end
function cm.eqspfilter(c,sc,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x9f3c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsCode(sc:GetCode())
end
function cm.fieldfilter(c)
	return not (c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x9f3c))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.eqsfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,cm.eqsfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	e:SetLabelObject(tc)
	Duel.ConfirmCards(1-tp,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not (tc:IsPublic() and tc:IsLocation(LOCATION_HAND)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.eqmfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.IsExistingMatchingCard(cm.eqspfilter,tp,LOCATION_HAND,0,1,nil,g:GetFirst(),e,tp) and not Duel.IsExistingMatchingCard(cm.fieldfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMZoneCount(tp)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,cm.eqspfilter,tp,LOCATION_HAND,0,1,1,nil,g:GetFirst(),e,tp)
				local sc=sg:GetFirst()
				if sc then
					Duel.SpecialSummonStep(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					sc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					sc:RegisterEffect(e2)
					Duel.SpecialSummonComplete()
					sc:CompleteProcedure()
					Duel.Equip(tp,tc,sc)
				end
			end
		end
	end
end