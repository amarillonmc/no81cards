--忠实的仆从，速速前来
local m=40010898
local cm=_G["c"..m]
cm.named_with_SilverThorn=1
function cm.SilverThorn(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_SilverThorn
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function cm.filter(c,e,tp)
	return cm.SilverThorn(c) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(cm.descon)
		e2:SetOperation(cm.desop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		Duel.RegisterEffect(e2,tp)
		if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			local g1=Duel.SelectMatchingCard(tp,cm.cilter1,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(g1)
			c:CancelToGrave()
			local sc=g1:GetFirst()
			Duel.Overlay(sc,Group.FromCards(c))
		else
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		end
	end
	Duel.SpecialSummonComplete()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
