--閃刀機－イーグルブースター
local m=91030011
local cm=c91030011
function c91030011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE+TIMING_DRAW_PHASE,TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2) or Duel.GetTurnPlayer()~=tp
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9d3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
end
function cm.fit(c)
return c:IsFaceup() and c:IsSetCard(0x9d3) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsSetCard(0x9d3) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) or  Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) or Duel.IsExistingTarget(cm.fit,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local b1=Duel.IsExistingTarget(cm.fit,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b3=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
	 local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,0)},
			{b2,aux.Stringid(m,1)},
			{b3,aux.Stringid(m,2)})
	if op==1 then 
	local g=Duel.SelectTarget(tp,cm.fit,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.HintSelection(g)
	e:GetHandler():RegisterFlagEffect(1,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	 e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:GetHandler():RegisterFlagEffect(2,RESET_PHASE+PHASE_END,0,1)
	elseif op==3 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:GetHandler():RegisterFlagEffect(3,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1)>0  then
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_QUICKPLAY)>=3 and Duel.SelectYesNo(tp,aux.Stringid(m,3))then
			 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e2:SetValue(LOCATION_HAND)
	tc:RegisterEffect(e2)
		end
	end
	Duel.ResetFlagEffect(c,1)
	elseif c:GetFlagEffect(2)>0  then
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	Duel.ResetFlagEffect(c,2)
	elseif c:GetFlagEffect(3)>0  then
	local g=Duel.SelectMatchingCard(tp,cm.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	   if #g>0 then Duel.LinkSummon(tp,g:GetFirst(),nil) end
	Duel.ResetFlagEffect(c,3)
	end
	 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_M1)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SKIP_M2)
		Duel.RegisterEffect(e2,tp)
end
function cm.lfilter(c)
	return c:IsLinkSummonable(nil)
end
function cm.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
