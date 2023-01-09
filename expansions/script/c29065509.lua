--方舟骑士-煌
c29065509.named_with_Arknight=1
function c29065509.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c29065509.ovfilter,aux.Stringid(29065508,0),3,c29065509.xyzop)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c29065509.discon)
	e1:SetOperation(c29065509.disop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065509,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,29065509)
	e2:SetTarget(c29065509.destg)
	e2:SetOperation(c29065509.desop)
	c:RegisterEffect(e2)
end
function c29065509.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065509.xyzop(e,tp,chk)
	if chk==0 then return (Duel.IsCanRemoveCounter(tp,1,0,0x10ae,2,REASON_COST) or (Duel.GetFlagEffect(tp,29096814)==1 and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,1,REASON_COST))) and Duel.GetFlagEffect(tp,29065509)==0 end
	if Duel.GetFlagEffect(tp,29096814)==1 then
	Duel.ResetFlagEffect(tp,29096814)
	Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065509,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	else
	Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065509,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
end
function c29065509.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return re:GetHandler():GetControler()~=tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c29065509.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c29065509.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c29065509.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c29065509.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c29065509.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29065509.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c29065509.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.Destroy(g,REASON_EFFECT)
	Duel.SetLP(tp,Duel.GetLP(tp)-2000)
end