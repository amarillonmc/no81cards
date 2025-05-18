--天夜 苍炎霸刀
function c60150620.initial_effect(c)
	c:SetUniqueOnField(1,0,60150620)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150620.ffilter,aux.FilterBoolFunction(c60150620.ffilter2),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60150620.splimit)
	c:RegisterEffect(e1)
	
	--Immunity
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c60150620.efilter2)
	c:RegisterEffect(e3)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60150620,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c60150620.discon)
	e2:SetTarget(c60150620.distg)
	e2:SetOperation(c60150620.disop)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetLabelObject(e2)
	e5:SetValue(c60150620.matchk)
	c:RegisterEffect(e5)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c60150620.damcon)
	e4:SetOperation(c60150620.regop)
	c:RegisterEffect(e4)
end
function c60150620.ffilter(c)
	return c:IsSetCard(0x5b21) and c:IsType(TYPE_MONSTER)
end
function c60150620.ffilter2(c)
	return (c:IsSetCard(0x3b21) and c:IsAttribute(ATTRIBUTE_FIRE)) or c:IsHasEffect(60150643)
end
function c60150620.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150620.efilter2(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c60150620.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c60150620.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150620.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c60150620.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c60150620.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(60150620,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c60150620.matchk(e,c)
	local ef=e:GetLabelObject()
	local ct=c:GetFlagEffect(60150620)
	if ct<0 then ct=0 end
	ef:SetCountLimit(ct+1)
end