--究极异兽-大胃王之恶食大王
function c40008608.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,4,c40008608.ovfilter,aux.Stringid(40008608,0),4,c40008608.xyzop)
	c:EnableReviveLimit()   
	--atk,def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c40008608.val)
	c:RegisterEffect(e3)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008608,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c40008608.spcost)
	e2:SetCountLimit(1,40008608)
	e2:SetTarget(c40008608.target)
	e2:SetOperation(c40008608.operation)
	c:RegisterEffect(e2)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008608,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c40008608.reptg)
	c:RegisterEffect(e1)
end
function c40008608.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c40008608.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(6) and c:GetOverlayCount()>1
end
function c40008608.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008608)==0 end
	Duel.RegisterFlagEffect(tp,40008608,RESET_PHASE+PHASE_END,0,1)
end
function c40008608.val(e,c)
	return Duel.GetLP(c:GetControler())/2
end
function c40008608.filter(c,tp)
	return not c:IsType(TYPE_TOKEN)
		and (c:IsControler(tp) or c:IsAbleToChangeControler()) and c:GetAttack()>0
end
function c40008608.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c40008608.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c40008608.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40008608.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
end
function c40008608.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c40008608.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end