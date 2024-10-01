--纯粹思维的洗礼
function c60010138.initial_effect(c)
	aux.AddCodeList(c,60010058,60010029)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010138.condition)
	e0:SetOperation(c60010138.activate)
	c:RegisterEffect(e0)
	--code
	local ge1=Effect.CreateEffect(c)
	ge1:SetCategory(CATEGORY_SEARCH)
	ge1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ge1:SetCode(EVENT_BATTLE_DESTROYING)
	ge1:SetProperty(EFFECT_FLAG_DELAY)
	ge1:SetCondition(aux.bdocon)
	ge1:SetTarget(c60010138.thtg)
	ge1:SetOperation(c60010138.thop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,60010058))
	e1:SetLabelObject(ge1)
	c:RegisterEffect(e1)
	--target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010138)
	e2:SetCondition(c60010138.tgcon)
	e2:SetTarget(c60010138.tgtg)
	e2:SetOperation(c60010138.tgop)
	c:RegisterEffect(e2)
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(0xff)
	e3:SetCountLimit(1,60010129+EFFECT_COUNT_CODE_DUEL)
	e3:SetOperation(c60010138.checkop)
	c:RegisterEffect(e3)
end
function c60010138.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not SpaceCheck then
		SpaceCheck={}
		for i=0,1 do
			local g=Duel.GetMatchingGroup(nil,i,LOCATION_HAND+LOCATION_DECK,0,nil)
			if #g==g:GetClassCount(Card.GetCode) then
				SpaceCheck[i]=true
			end
		end
	end
end
function c60010138.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010138.thfilter(c)
	return c:IsCode(60010058) and c:IsAbleToHand()
end
function c60010138.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010138.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010138,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010138.ownerfilter(c,tp)
	return c:IsCode(60010058) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010138.sefilter(c)
	return aux.IsCodeListed(c,60010029) and c:IsAbleToHand()
end
function c60010138.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60010138.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c60010138.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60010138.sefilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60010138.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010138.ownerfilter,1,nil,tp)
end
function c60010138.tgfilter(c)
	return aux.NegateMonsterFilter(c) and (c:GetAttack()>0 or c:GetDefense()>0)
end
function c60010138.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c60010138.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60010138.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c60010138.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c60010138.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NegateMonsterFilter(tc) then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_SET_ATTACK_FINAL)
		e0:SetValue(0)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0)
		local e1=e0:Clone()
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e1)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end
