--罗德岛·术士干员-天火
function c79029023.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029023,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029023.descon)
	e1:SetTarget(c79029023.destg)
	e1:SetOperation(c79029023.desop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c79029023.val)
	c:RegisterEffect(e2) 
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DRAW)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029023.damcon)
	e3:SetTarget(c79029023.damtg)
	e3:SetOperation(c79029023.damop)
	c:RegisterEffect(e3)
end
function c79029023.atkfilter(c)
	return c:IsSetCard(0x1901)
end
function c79029023.val(e,c)
	local g=Duel.GetMatchingGroup(c79029023.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g:GetCount()
	return ct*300
end
function c79029023.filter(c,tp)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) or c:IsType(TYPE_MONSTER)
end
function c79029023.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029023.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local x=e:GetHandler():GetMaterialCount()
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,x,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c79029023.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg then
		local g=tg:Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,nil,REASON_EFFECT)
		end
	end
end
function c79029023.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsExists(c79029023.filter,1,nil,tp) then return false end
	local rc=re:GetFirstTarget()
	Duel.SendtoGrave(rc,REASON_EFFECT)
end
function c79029023.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c79029023.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c79029023.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end