--键★等 － YURIPPE || K.E.Y Etc. Yurippe
--Scripted by: XGlitchy30

local s,id=GetID()

function s.initial_effect(c)
	c:EnableReviveLimit()
	--Gain all Types/Attributes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(RACE_ALL)
	c:RegisterEffect(e0)
	local e0x=e0:Clone()
	e0x:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0x:SetValue(ATTRIBUTE_ALL)
	c:RegisterEffect(e0x)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.lpcon(2000))
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc460))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2x)
	--direct attack
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(s.lpcon(4000))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immune
	local e4=e2:Clone()
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(s.lpcon(6000))
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLP(1-tp)>Duel.GetLP(tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0xc460)
end

function s.lpcon(lp)
	return	function(e)
				local tp=e:GetHandlerPlayer()
				return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))>=lp
			end
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end