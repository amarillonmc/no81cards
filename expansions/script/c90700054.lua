local m=90700054
local cm=_G["c"..m]
cm.name="本能『本我的解放』"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90700054+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.condition)
	c:RegisterEffect(e2)  
end
function cm.mfilter(c,e,tp)
	return c:IsSetCard(0x6312) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN)
end
function cm.sfilter(c)
	return c:IsSetCard(0x6312) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsSSetable()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(90700054,0),aux.Stringid(90700054,1),aux.Stringid(90700054,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(90700054,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(90700054,1))+1
	end
	e:SetLabel(op)
	if op==0 or op==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op~=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.mfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.SSet(tp,tc)
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end