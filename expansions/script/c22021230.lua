--人理之诗 贯穿死翔之枪
function c22021230.initial_effect(c)
	aux.AddCodeList(c,22021220) 
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to grave 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(22021230,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCountLimit(1,22021230)
	e1:SetCondition(c22021230.tgcon)
	e1:SetTarget(c22021230.tgtg)
	e1:SetOperation(c22021230.tgop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(22021230,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c22021230.damcon)
	e2:SetTarget(c22021230.damtg)
	e2:SetOperation(c22021230.damop)
	c:RegisterEffect(e2)
end
function c22021230.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==tp and rc:IsCode(22021220) 
end 
function c22021230.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0) 
end 
function c22021230.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.SelectOption(tp,aux.Stringid(22020370,2))
		Duel.SelectOption(tp,aux.Stringid(22020370,3))
		Duel.SendtoGrave(tc,REASON_EFFECT) 
	end 
end 
function c22021230.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_EFFECT)~=0 and re and re:GetHandler():IsCode(22021220)
end
function c22021230.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c22021230.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.SelectOption(tp,aux.Stringid(22020370,4))
	Duel.Damage(p,d,REASON_EFFECT)
end




