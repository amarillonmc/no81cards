--你这卡太阴了！
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)   
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(s.xxop) 
	c:RegisterEffect(e1)
end

function s.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local count=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_EXTRA,0,nil,id)
	for i=1,count do
	Duel.ConfirmCards(1-tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabel(ac)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.disop)
	local count=Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetLabel(ac)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.disop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetLabel(ac)
	e3:SetCondition(s.negcon)
	e3:SetOperation(s.disop)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e5,tp)
	end
end


function s.cfilter(c,ac)
	return c:IsCode(ac) 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return ac and eg:IsExists(s.cfilter,1,nil,ac)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return ac and Duel.GetAttacker():GetControler()~=tp and Duel.GetAttacker():IsCode(ac)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local roll=s.roll(1,9)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,roll))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,roll))
end


function s.roll(min,max)
	if not s.random then
		local g=Duel.GetFieldGroup(0,0xff,0xff):RandomSelect(2,1)
		s.random=g:GetFirst():GetCode()+Duel.GetTurnCount()+Duel.GetFieldGroupCount(1,LOCATION_GRAVE,0)
	end
	min=tonumber(min)
	max=tonumber(max)
	s.random=((s.random*1103515245+12345)%32767)/32767
	if min~=nil then
		if max==nil then
			return math.floor(s.random*min)+1
		else
			max=max-min+1
			return math.floor(s.random*max+min)
		end
	end
	return s.random
end