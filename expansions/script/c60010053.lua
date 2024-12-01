--黄泉-远辞畴昔-
local m=60010053
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,60010029)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	--e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.retg1)
	e1:SetOperation(cm.retop1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
	--special summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.retg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and (Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)>=9 or (Duel.IsPlayerAffectedByEffect(tp,60010131) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)>=4)) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.retop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,2))~=0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if #g~=0 and Duel.IsEnvironment(60010029,tp) then
			Duel.Destroy(g,REASON_EFFECT)
			if #Duel.GetOperatedGroup()>=5 then
				Duel.SelectOption(tp,aux.Stringid(m,0))
				Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
				Duel.SelectOption(tp,aux.Stringid(m,1))
				Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,1))
				c:SetCardData(CARDDATA_CODE,m+1) 
			end
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return ag:GetClassCount(Card.GetRace)==ag:GetCount() and ag:GetClassCount(Card.GetAttribute)==ag:GetCount()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,nil)  end  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(cm.indtg)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end 
end  
function cm.indtg(e,c)
	return c:IsFaceup()
end
