local m=15005914
local cm=_G["c"..m]
cm.name="龙芯残机-差速赤璋"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--Remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.condition)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevel(8)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToRemove() and c:IsRace(RACE_MACHINE)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(0x9f43)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local xchk=(tc:GetOverlayCount()>0 and tc:IsType(TYPE_XYZ))
		local fchk=(tc:IsLocation(LOCATION_MZONE))
		if fchk then
			if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetLabelObject(tc)
				e1:SetCountLimit(1)
				if Duel.GetCurrentPhase()==PHASE_STANDBY then
					e1:SetLabel(Duel.GetTurnCount())
					e1:SetCondition(cm.retcon)
					e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
				else
					e1:SetReset(RESET_PHASE+PHASE_STANDBY)
				end
				e1:SetOperation(cm.retop)
				Duel.RegisterEffect(e1,tp)
			end
		else Duel.Remove(tc,0,REASON_EFFECT) end
		if tc:IsLocation(LOCATION_REMOVED) and xchk and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end