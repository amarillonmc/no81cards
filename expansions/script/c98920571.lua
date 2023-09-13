--捕食植物·仙人掌小龙
function c98920571.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x10f3),2,2)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920571,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920571.condition)
	e1:SetOperation(c98920571.operation)
	c:RegisterEffect(e1)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetTarget(c98920571.atktg)
	c:RegisterEffect(e4)
	--half atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(0,EFFECT_FLAG2_WICKED)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c98920571.atktg)
	e4:SetValue(c98920571.atkval)
	c:RegisterEffect(e4) 
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920571,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98920571.tgcon)
	e3:SetTarget(c98920571.tgtg)
	e3:SetOperation(c98920571.tgop)
	c:RegisterEffect(e3) 
	if not c98920571.check then
		c98920571.check=true
		jerrymg=Duel.GetFusionMaterial
		Duel.GetFusionMaterial=function(p)  
			   local g=Duel.GetMatchingGroup(c98920571.filter1,p,0,LOCATION_MZONE,nil)
			   return Group.__add(jerrymg(p),g)
		end
	end
end
function c98920571.atktg(e,c)
	return c:IsLevel(1)
end
function c98920571.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function c98920571.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920571.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920571.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(98920571,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end 
end
function c98920571.splimit(e,c)
	return not c:IsSetCard(0x10f3,0x1046) and c:IsLocation(LOCATION_EXTRA)
end
function c98920571.mttg(e,c)
	return c:GetOriginalType()&TYPE_MONSTER~=0
end
function c98920571.mtval(e,c)
	if not c then return false end
	return c:IsSetCard(0x10f3,0x1046)
end
function c98920571.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c98920571.filter1(c)
	return c:GetFlagEffect(98920571)>0
end
function c98920571.tgfilter(c)
	return c:IsSetCard(0x11c) and c:IsAbleToGrave()
end
function c98920571.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1041,1) end
end
function c98920571.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1041,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1041,1)
		if tc:IsLevelAbove(2) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c98920571.lvcon)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c98920571.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end