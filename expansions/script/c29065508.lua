--方舟骑士-陈
c29065508.named_with_Arknight=1
function c29065508.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c29065508.ovfilter,aux.Stringid(29065508,0),3,c29065508.xyzop)
	c:EnableReviveLimit()
	--Double attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065508,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,29065508)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c29065508.discon)
	e2:SetTarget(c29065508.distg)
	e2:SetOperation(c29065508.disop)
	c:RegisterEffect(e2)
end
function c29065508.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065508.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x10ae,2,REASON_COST) and Duel.GetFlagEffect(tp,29065508)==0 end
	Duel.RemoveCounter(tp,1,1,0x10ae,2,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065508,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c29065508.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c29065508.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c29065508.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end