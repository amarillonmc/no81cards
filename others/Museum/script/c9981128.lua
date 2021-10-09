--最佳搭配Rogue
function c9981128.initial_effect(c)
	   --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5bc3),4,2)
	c:EnableReviveLimit()
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981128,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e1:SetCondition(c9981128.atkcon)
	e1:SetCost(c9981128.atkcost)
	e1:SetOperation(c9981128.atkop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c9981128.indcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttackAbove,2000))
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c9981128.indcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttackAbove,2000))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981128,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCost(c9981128.descost)
	e4:SetTarget(c9981128.destg)
	e4:SetOperation(c9981128.desop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981128.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981128.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981128,2))
end
function c9981128.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttackTarget() and e:GetHandler():GetOverlayCount()~=0
end
function c9981128.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(9981128)==0 end
	e:GetHandler():RegisterFlagEffect(9981128,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c9981128.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981128,3))
end
function c9981128.indcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9981128.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9981128.descfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5bc3)
end
function c9981128.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	local ct=Duel.GetMatchingGroupCount(c9981128.descfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9981128.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981128,3))
	end
end