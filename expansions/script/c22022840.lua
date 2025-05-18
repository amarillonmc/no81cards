--灾厄征兆 巴格斯特
function c22022840.initial_effect(c)
	aux.AddMaterialCodeList(c,22022840)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,22021720),1,1)
	c:EnableReviveLimit()
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022840,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22022840)
	e3:SetCondition(c22022840.damcon)
	e3:SetTarget(c22022840.damtg)
	e3:SetOperation(c22022840.damop)
	c:RegisterEffect(e3)
	--damage ere 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22022840,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22022840)
	e4:SetCost(c22022840.erecost)
	e4:SetCondition(c22022840.damcon1)
	e4:SetTarget(c22022840.damtg)
	e4:SetOperation(c22022840.damop)
	c:RegisterEffect(e4)
end
c22022840.material_type=TYPE_SYNCHRO 
function c22022840.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c22022840.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2600)
	Duel.SelectOption(tp,aux.Stringid(22022840,1))
end
function c22022840.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.BreakEffect()
			Duel.SelectOption(tp,aux.Stringid(22022840,1))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(2600)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function c22022840.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022840.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end