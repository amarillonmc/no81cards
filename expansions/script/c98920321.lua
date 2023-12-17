--闪刀姬-钢蕾
local s,id,o=GetID()
function c98920321.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,12421694,aux.FilterBoolFunction(c98920321.fusfilter),1,true,true)
	aux.AddContactFusionProcedure(c,c98920321.cfilter,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	Duel.AddCustomActivityCounter(98920321,ACTIVITY_CHAIN,c98920321.chainfilter)
	 --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920321.splimit)
	c:RegisterEffect(e1)
	--cannot link material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetCondition(c98920321.linkcon)
	e4:SetValue(1)
	c:RegisterEffect(e4) 
	--atk/def set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c98920321.adcon)
	e2:SetTarget(c98920321.adtg)
	e2:SetValue(c98920321.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(c98920321.defval)
	c:RegisterEffect(e3)
	 --bp disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetOperation(s.disop)
	c:RegisterEffect(e7)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(s.distg)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_DISABLE_EFFECT)
	e6:SetValue(RESET_TURN_SET)
	c:RegisterEffect(e6)
	 --redirect
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetValue(LOCATION_REMOVED)
	e8:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1115))
	c:RegisterEffect(e8)
end
function c98920321.linkcon(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c98920321.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98920321.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0x115) and re:IsActiveType(TYPE_SPELL))
end
function c98920321.fusfilter(c)
	 return c:IsSetCard(0x1115) and not c:IsAttribute(ATTRIBUTE_EARTH)
end
function c98920321.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c98920321.cfilter(c,fc)
	local tp=fc:GetControler()
	return c:IsAbleToRemoveAsCost() and (Duel.GetCustomActivityCount(98920321,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(98920321,1-tp,ACTIVITY_CHAIN)~=0) 
end
function c98920321.adcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget()
end
function c98920321.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c98920321.atkval(e,c)
	return c:GetBaseAttack()
end
function c98920321.defval(e,c)
	return c:GetBaseDefense()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.AdjustInstantly(e:GetHandler())
end
function s.disfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1115) and c:IsControler(tp)
end
function s.distg(e,c)
	local fid=e:GetHandler():GetFieldID()
	for _,flag in ipairs({c:GetFlagEffectLabel(id)}) do
		if flag==fid then return true end
	end
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and bc and s.disfilter(bc,e:GetHandlerPlayer()) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		return true
	end
	return false
end