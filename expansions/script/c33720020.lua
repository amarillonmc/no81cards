--奇迹的埋火
--Scripted by: XGlitchy30
local id=33720020
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--atk boost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(s.adcon)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)
	--replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(s.reptg)
	e5:SetValue(s.repval)
	c:RegisterEffect(e5)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--atk boost
function s.adcon(e)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL then return false end
	local eqc=e:GetHandler():GetEquipTarget()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and (a==eqc or d==eqc)
end
function s.atkval(e,c)
	local eqc=e:GetHandler():GetEquipTarget()
	local d=Duel.GetAttackTarget()
	if eqc==d then d=Duel.GetAttacker() end
	return d:GetAttack()/2
end
--replace
function s.desfilter(c)
	return c:IsSetCard(0xb) and c:IsAbleToRemove()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	if chk==0 then return eqc and eg:IsContains(eqc) and eqc:IsReason(REASON_EFFECT) and not eqc:IsReason(REASON_REPLACE) and eqc:GetReasonPlayer()==1-tp
		and eqc:IsAbleToHand() and c:IsAbleToHand()
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local val=eqc:GetTextAttack()
		if Duel.SendtoHand(Group.FromCards(c,eqc),nil,REASON_EFFECT)>0 and val>0 then
			Duel.Damage(1-tp,val,REASON_EFFECT)
		end
		return true
	else
		return false
	end
end
function s.repval(e,c)
	local cc=e:GetHandler()
	local eqc=cc:GetEquipTarget()
	return eqc and eqc:IsReason(REASON_EFFECT) and not eqc:IsReason(REASON_REPLACE) and eqc:GetReasonPlayer()==1-tp
end