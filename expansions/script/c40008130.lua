--炼狱之战士
function c40008130.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9c),2,2)
	c:EnableReviveLimit()   
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c40008130.atkval)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008130,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40008130.chcon)
	e2:SetTarget(c40008130.chtg)
	e2:SetOperation(c40008130.chop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c40008130.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c40008130.indtg(e,c)
	return c:IsSetCard(0x9c) and c~=e:GetHandler()
end
function c40008130.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9c)
end
function c40008130.atkval(e,c)
	return c:GetLinkedGroup():FilterCount(c40008130.atkfilter,nil)*1200
end
function c40008130.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rc:IsSetCard(0x9c) and rc:IsControler(tp)
		and not rc:IsCode(40008130) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) 
end
function c40008130.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ftg=re:GetTarget()
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c40008130.chop(e,tp,eg,ep,ev,re,r,rp)
	local fop=re:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end