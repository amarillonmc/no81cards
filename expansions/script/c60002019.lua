--时光酒桌 复月
local m=60002019
local cm=_G["c"..m]
function cm.initial_effect(c)
	--hand effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.cvtg1)
	e2:SetOperation(cm.cvop1)
	c:RegisterEffect(e2)
	--hand effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.cvtg2)
	e2:SetOperation(cm.cvop2)
	c:RegisterEffect(e2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.cvtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.cvfilter1(c)
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.cvop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	local t=Duel.GetFlagEffect(tp,60002009)
	if Duel.GetTurnCount()+t>=11 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local c=e:GetHandler()
		local hg=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_HAND,LOCATION_HAND,nil,1)
		local tc=hg:GetFirst()
		while tc do
			for i=1,11 do
				if tc:GetLevel()>=1 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_LEVEL)
					e1:SetValue(-1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
				end
			end
			tc=hg:GetNext()
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(cm.hlvop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.hlvop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(Card.IsLevelAbove,nil,1)
	local tc=hg:GetFirst()
	while tc do
		for i=1,11 do
			if tc:GetLevel()>=1 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(-1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
		tc=hg:GetNext()
	end
end
function cm.cvtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,nil)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function cm.cvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.filter(c)
	return c:IsType(TYPE_COUNTER) 
end
function cm.ofilter(c)
	return c:IsFaceup() and c:IsCode(60002024)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFlagEffect(tp,60002009)
	if Duel.GetTurnCount()+t>=11 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.RegisterFlagEffect(tp,60002009,RESET_PHASE+PHASE_END,0,1000)
	if Duel.IsExistingMatchingCard(cm.ofilter,tp,LOCATION_FZONE,0,1,c) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end