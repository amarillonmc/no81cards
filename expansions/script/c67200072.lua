--创刻-柏木鸣海『家务苦手』
function c67200072.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE)
	e1:SetCountLimit(1,67200072+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c67200072.activate)
	c:RegisterEffect(e1) 
	--extra damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200072,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c67200072.damcon)
	e2:SetTarget(c67200072.damtg)
	e2:SetOperation(c67200072.damop)
	c:RegisterEffect(e2) 
end
function c67200072.filter(c)
	return c:IsSetCard(0xa673) and c:IsAbleToHand()
end
function c67200072.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c67200072.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200072,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
function c67200072.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x673) and eg:GetFirst():IsType(TYPE_FUSION)
end
function c67200072.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c67200072.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
