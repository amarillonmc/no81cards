local m=15000538
local cm=_G["c"..m]
cm.name="核机的物质·王国"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--p
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.pcon)
	e1:SetTarget(cm.ptg)
	e1:SetOperation(cm.pop)
	c:RegisterEffect(e1)
	--h+m
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,15000538)
	e2:SetCondition(cm.hmcon)
	e2:SetTarget(cm.hmtg)
	e2:SetOperation(cm.hmop)
	c:RegisterEffect(e2)
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(15000538)~=0
end
function cm.cfilter1(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_PENDULUM) and (c:IsType(TYPE_TUNER) or (c:IsLocation(LOCATION_PZONE) and c:IsSynchroType(TYPE_TUNER))) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c,e,tp,c)
end
function cm.cfilter2(c,e,tp,tc)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel()+tc:GetLevel(),Group.FromCards(c,tc))
end
function cm.spfilter(c,e,tp,lv,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_PENDULUM) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst())
	local lv=g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel()
	g1:Merge(g2)
	if Duel.SendtoExtraP(g1,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,nil)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			g:GetFirst():CompleteProcedure()
		end
	end
end
function cm.hmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==0
end
function cm.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3f3e) and c:IsAbleToHand()
end
function cm.tpfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.thfilter,c:GetControler(),LOCATION_DECK,0,1,nil) and not c:IsForbidden()
end
function cm.hmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.tpfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.hmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.tpfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()~=0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		local tc=g:GetFirst()
		if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			tc:RegisterFlagEffect(15000538,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
			if not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ag=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if ag:GetCount()>0 then
				Duel.SendtoHand(ag,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ag)
			end
		end
	end
end