--惧 轮  至 高 清 道 夫
function c53701026.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,c53701026.lcheck)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53701026,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c53701026.actcon)
	e1:SetOperation(c53701026.actop)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c53701026.value)
	c:RegisterEffect(e3)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(53701026,1))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetCondition(c53701026.decon)
	e9:SetTarget(c53701026.detg)
	e9:SetOperation(c53701026.deop)
	c:RegisterEffect(e9)
end
function c53701026.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3530)
end
function c53701026.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>=15
end
function c53701026.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c53701026.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*400
end
function c53701026.decon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c53701026.defilter(c,rac)
	return c:IsRace(rac)
end
function c53701026.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetBattleTarget()
	local desg=Duel.GetMatchingGroup(c53701026.defilter,tp,0,LOCATION_DECK,nil,tc:GetRace())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,desg,desg:GetCount(),0,0)
end
function c53701026.deop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetHandler():GetBattleTarget()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,g)
	local desg=Duel.GetMatchingGroup(c53701026.defilter,tp,0,LOCATION_DECK,nil,tc:GetRace())
	Duel.Destroy(desg,REASON_EFFECT)
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsChainAttackable() then
		Duel.ChainAttack()
	end
end
