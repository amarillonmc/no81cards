--灼经-「烈火一闪」
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc31)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsFaceupEx() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceupEx,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,Card.IsFaceupEx,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
end
function s.efilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc31) and c:IsLinkAbove(3)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetOriginalCodeRule()
	local type=tc:GetType()
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetLabel(code)
	e3:SetTarget(s.distg)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetLabel(code)
	e4:SetTarget(s.distg2)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetLabel(code)
	e5:SetCondition(s.discon2)
	e5:SetOperation(s.disop)
	e5:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e5,tp)
	if Duel.IsExistingMatchingCard(s.efilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local op=aux.SelectFromOptions(tp,{tc:IsAbleToRemove(),1102},{true,1131})
		if op==1 then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		elseif c:IsLocation(LOCATION_SZONE) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e4:SetTarget(s.dis2tg)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetLabel(c:GetSequence(),type,c:GetFieldID())
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_CHAIN_SOLVING)
			e5:SetOperation(s.dis2op)
			e5:SetReset(RESET_PHASE+PHASE_END)
			e5:SetLabel(c:GetSequence(),type)
			Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e6:SetTarget(s.dis2tg)
			e6:SetReset(RESET_PHASE+PHASE_END)
			e6:SetLabel(c:GetSequence(),type)
			Duel.RegisterEffect(e6,tp)
			Duel.Hint(HINT_ZONE,tp,0x1<<(c:GetSequence()+8))
		end
	end
end
function s.distg(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.distg2(e,c)
	return c:IsType(TYPE_TRAP) and c:IsOriginalCodeRule(e:GetLabel())
end
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.dis2tg(e,c)
	local seq,type,fid=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return c:IsType(bit.band(type,0x7)) and aux.GetColumn(c,tp)==seq and c:GetFieldID()~=fid
end
function s.dis2op(e,tp,eg,ep,ev,re,r,rp)
	local tseq,type=e:GetLabel()
	local controller,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if re:GetHandler():IsType(bit.band(type,0x7)) and seq<=4 and (controller==tp and seq==tseq or controller==1-tp and seq==4-tseq) then
		Duel.NegateEffect(ev)
	end
end
