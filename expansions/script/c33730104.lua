--键★高潮 小镇、时光的流逝、人 || Città, Scorrere del Tempo, Persone
--Scripted by: XGlitchy30

local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--transfer orbs
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.trcon)
	e2:SetOperation(s.trop)
	c:RegisterEffect(e2)
	--place orb
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.ctcon)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
	--Replace destruction
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(s.desreptg)
	e4:SetValue(s.desrepval)
	e4:SetOperation(s.desrepop)
	c:RegisterEffect(e4)
	--register SS
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.spfilter,nil)
	if #g<=0 then return end
	for p=tp,1-tp,1-2*tp do
		local ct=g:FilterCount(Card.IsSummonPlayer,nil,p)
		if ct>0 then
			if Duel.GetFlagEffect(p,id)<=0 then
				Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1,0)
			end
			Duel.SetFlagEffectLabel(p,id,Duel.GetFlagEffectLabel(p,id)+ct)
		end
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x1460,1,c) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain(0) and c:IsFaceup() then
		c:AddCounter(0x1460,1)
	end
end

function s.trfilter(c,tc)
	local ct=c:GetCounter(0x1460)
	return ct>0 and c:IsCanRemoveCounter(tp,0x1460,ct,REASON_EFFECT) and tc:IsCanAddCounter(0x1460,ct)
end
function s.trcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.trfilter,1,nil,e:GetHandler())
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.trfilter,nil,e:GetHandler())
	if #g<=0 then return end
	Duel.Hint(HINT_CARD,tp,id)
	local exg=Group.CreateGroup()
	while #g>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		local ct=tc:GetCounter(0x1460)
		tc:RemoveCounter(tp,0x1460,ct,REASON_EFFECT)
		local diff=math.abs(ct-tc:GetCounter(0x1460))
		e:GetHandler():AddCounter(0x1460,diff)
		exg:AddCard(tc)
		g=eg:Filter(s.trfilter,exg,e:GetHandler())
	end
end

function s.ctcon(e,tp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,id)>0 and Duel.GetFlagEffectLabel(tp,id)>=3
end
function s.ctop(e,tp)
	local c=e:GetHandler()
	if c:IsRelateToChain(0) and c:IsFaceup() and c:IsCanAddCounter(0x1460,1) then
		c:AddCounter(0x1460,1)
	end
end

function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x460) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsReason(REASON_REPLACE+REASON_RULE)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) and c:IsCanRemoveCounter(tp,0x1460,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.desrepval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1460,1,REASON_EFFECT+REASON_REPLACE)
end