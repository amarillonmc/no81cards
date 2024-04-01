--渊洋火力覆盖
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--back to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5 and c:IsSetCard(0x3223)
end
function s.seqfilter(c,seq)
	local cseq=c:GetSequence()
	return cseq==seq and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetOverlayGroup(tp,LOCATION_ONFIELD,0)
	if chk==0 then return g:IsExists(Card.IsSetCard,1,nil,0x3223) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ovg=Duel.GetOverlayGroup(tp,LOCATION_ONFIELD,0)
	local num=ovg:FilterCount(Card.IsSetCard,nil,0x3223)
	local c=e:GetHandler()
	local zones={}
	for i=1,num do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		local flag=Duel.SelectField(tp,1,0,LOCATION_MZONE,0xe000e0)
		table.insert(zones,flag)
	end
	for n=1,#zones do
		local seq=math.log(zones[n]>>16,2)
		Duel.Hint(HINT_ZONE,tp,zones[n])
		local g=Duel.GetMatchingGroup(s.seqfilter,tp,0,LOCATION_MZONE,nil,seq)
		if #g>0 then
			local tc=g:GetFirst()
			local preatk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if preatk~=0 and tc:IsAttack(0) then Duel.Destroy(tc,REASON_EFFECT) end
		else
			Duel.Damage(1-tp,200,REASON_EFFECT)
		end
	end
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
