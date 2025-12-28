--幻叙咏者 闪闪
local s,id,o=GetID()
function s.initial_effect(c)
	--Link Summon
	aux.AddLinkProcedure(c,nil,2,99)
	c:EnableReviveLimit()
	--Place in S/T
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.placecon)
	e1:SetOperation(s.placeop)
	c:RegisterEffect(e1)	
end
function s.placecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.placeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DESTROY_REPLACE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTarget(s.desreptg)
		e2:SetValue(s.desrepval)
		e2:SetOperation(s.desrepop)
		c:RegisterEffect(e2)
		--Check Materials
		local mg=c:GetMaterial()
		if c:IsSummonType(SUMMON_TYPE_LINK) and mg:FilterCount(Card.IsSetCard,nil,0x838)>=2 then
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(id,2))
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_SPSUMMON_SUCCESS)
			e3:SetRange(LOCATION_SZONE)
			e3:SetCondition(s.grantcon)
			e3:SetOperation(s.grantop)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			e4:SetRange(LOCATION_SZONE)
			e4:SetTargetRange(LOCATION_SZONE,0)
			e4:SetTarget(s.eftg)
			e4:SetLabelObject(e3)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e4)
		end
	end
end
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x838)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	return true
end
function s.desrepval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=eg:Filter(s.repfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(tp)
	local res=Duel.TossCoin(tp,1)
	
	if res==coin then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function s.recfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsSetCard(0x838) and c:IsControler(tp) and c:IsAbleToHand()
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.recfilter,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(tp)
	local res=Duel.TossCoin(tp,1)
	
	if res==coin then
		--Guess Correct: Add destroyed cards to hand
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		--Guess Wrong: Return this card to hand
		if c:IsRelateToChain() then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
function s.eftg(e,c)
	local seq=e:GetHandler():GetSequence()
	local cseq=c:GetSequence()
	return math.abs(seq-cseq)==1 and c:IsFaceup() and (c:GetType()&TYPE_CONTINUOUS>0 or c:GetType()&TYPE_TRAP>0)
end
function s.cfilter(c)
	return c:IsSetCard(0x838) and c:IsFaceup()
end
function s.grantcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.grantop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	if g:GetCount()>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(tp)
	local res=Duel.TossCoin(tp,1)
	if res==coin then
		local val=tc:GetAttack()
		Duel.Recover(tp,val,REASON_EFFECT)
	else
		local val=tc:GetDefense()
		Duel.SetLP(tp,Duel.GetLP(tp)-val)
	end
end
