local m=31400133
local cm=_G["c"..m]
cm.name="龙魔王 无形体·假面"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.indestg)
	e1:SetValue(cm.indesval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.copycost)
	e2:SetOperation(cm.copyop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m+100000000)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.indestg(e,c)
	return c:IsSetCard(0xda,0xe0) and c:IsType(TYPE_PENDULUM)
end
function cm.indesval(e,re,r,rp)
	return bit.band(r,REASON_RULE+REASON_BATTLE)==0
end
function cm.copyfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xe0)
end
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.copyfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.copyfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	e:SetLabel(tc:GetCode())
	Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():CopyEffect(e:GetLabel(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
end
function cm.filter(c,e,tp,ft)
	return c:IsSetCard(0xda,0xe0) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ft) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	local num=0
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			num=Duel.SpecialSummon(tc,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
		else
			num=Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	local c=e:GetHandler()
	if num==0 or not c:IsRelateToEffect(e) or not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.BreakEffect()
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end