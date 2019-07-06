--甜蜜盛宴
function c33700159.initial_effect(c)
	 c:SetUniqueOnField(1,0,33700159) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33700159.con)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c33700159.tg)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700159,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c33700159.recon)
	e3:SetTarget(c33700159.retg)
	e3:SetOperation(c33700159.reop)
	c:RegisterEffect(e3)
end
function c33700159.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c33700159.tg(e,c)
	return  c:IsPosition(POS_DEFENSE)
end
function c33700159.recon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return   ep==1-tp and rc:IsControler(tp) and rc:IsRace(RACE_T) and Duel.GetAttackTarget()==nil and Duel.GetLP(tp)>=12000
end
function c33700159.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c33700159.reop(e,tp,eg,ep,ev,re,r,rp)
	 if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
