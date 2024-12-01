--露西亚·深红囚影
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE)
	--e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	c:RegisterEffect(e2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.immcon)
	e1:SetValue(cm.immval)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e0)

	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_MZONE)
	e9:SetOperation(cm.desop)
	c:RegisterEffect(e9)
	
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==e:GetHandler():GetOwner()
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetLocation()==LOCATION_HAND then i=1 else i=2 end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,i)) then return end
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then c:CompleteProcedure() end
	local i=math.random(3,8)
	Duel.Hint(24,0,aux.Stringid(60000032,i))
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,60000032) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local i=math.random(3,8)
		Duel.Hint(24,0,aux.Stringid(60000032,i))
	end
end
function cm.immcon(e)
	local c=e:GetHandler()
	return c:IsPosition(POS_FACEUP_DEFENSE)
end
function cm.immval(e,te_or_c)
	local res=aux.GetValueType(te_or_c)~="Effect" or (te_or_c:IsActivated() and te_or_c:GetOwner()~=e:GetHandler())
	if res then
		if aux.GetValueType(te_or_c)=="Effect" then Duel.Hint(HINT_CARD,0,m) end
		local c=e:GetHandler()
		Card.RegisterFlagEffect(e:GetHandler(),m,0,0,1)
	end
	return res
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)~=0 and Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)~=0 then
		Card.ResetFlagEffect(e:GetHandler(),m)
		if Duel.IsExistingMatchingCard(cm.refil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.refil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		local i=math.random(3,8)
		Duel.Hint(24,0,aux.Stringid(60000032,i))
	end
end
function cm.refil(c)
	return c:IsCode(60000037) and c:IsAbleToHand()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and rp==1-tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFlagEffect(tp,60000036)~=0 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,Duel.GetFlagEffect(tp,60000036)*600,REASON_EFFECT)
	local i=math.random(3,8)
	Duel.Hint(24,0,aux.Stringid(60000032,i))
end

--random
function getrand()
	local result=0
	local g=Duel.GetDecktopGroup(0,5)
	local tc=g:GetFirst()
	while tc do
		result=result+tc:GetCode()
		tc=g:GetNext()
	end
	math.randomseed(result)
end




















