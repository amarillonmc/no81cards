--├军团亚席 虚空之卡莉普拉┤
local m=60151124
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9b23),2,2)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151101,2))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151124.atkcon)
	e1:SetTarget(c60151124.cointg)
	e1:SetOperation(c60151124.coinop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c60151124.atkcon2)
	e2:SetTarget(c60151124.cointg)
	e2:SetOperation(c60151124.coinop)
	c:RegisterEffect(e2)
	--juo gai
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151124,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(c60151124.tdtg)
	e3:SetOperation(c60151124.tdop)
	c:RegisterEffect(e3)
end
c60151124.toss_coin=true
function c60151124.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK and not e:GetHandler():IsHasEffect(60151199)
end
function c60151124.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK and e:GetHandler():IsHasEffect(60151199)
end
function c60151124.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151124.chlimit)
		Duel.RegisterFlagEffect(tp,60151124,RESET_CHAIN,0,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,1-tp,LOCATION_MZONE)
end
function c60151124.chlimit(e,ep,tp)
	return tp==ep
end
function c60151124.filter2(c)
	return c:IsAbleToGrave()
end
function c60151124.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local res=0
	if Duel.GetFlagEffect(tp,60151124)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		if Duel.SelectYesNo(tp,aux.Stringid(60151124,0)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,c60151124.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoGrave(g1,REASON_EFFECT)
			end
		end
	end
	if res==1 then
		--damage
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(c60151124.regop)
		c:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(c60151124.damcon)
		e3:SetOperation(c60151124.damop)
		c:RegisterEffect(e3)
		--
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCategory(CATEGORY_DAMAGE)
		e4:SetCode(EVENT_TO_GRAVE)
		e4:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(c60151124.regcon2)
		e4:SetOperation(c60151124.regop2)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(60151124,1))
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5)
	end
end
function c60151124.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(60151124,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c60151124.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	return c:GetFlagEffect(60151124)~=0 and ex 
end
function c60151124.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60151124)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c60151124.cfilter(c)
	return c:IsSetCard(0x9b23) and c:IsReason(REASON_EFFECT)
end
function c60151124.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c60151124.cfilter,1,nil)
end
function c60151124.regop2(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local ct=eg:FilterCount(c60151124.cfilter,nil)
	if ct>0 then
		Duel.Hint(HINT_CARD,0,60151124)
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function c60151124.tdtgfilter(c,tp)
	return c:IsSetCard(0x9b23) and c:IsAbleToRemove() 
		and Duel.IsExistingMatchingCard(c60151124.tdtgfilter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c60151124.tdtgfilter2(c,tc)
	return c:IsSetCard(0x9b23) and (c:IsAbleToGrave() or c:IsAbleToHand()) and c:GetCode()~=tc:GetCode()
end
function c60151124.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151124.tdtgfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c60151124.tdtgfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60151124.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local g=Duel.SelectMatchingCard(tp,c60151124.tdtgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc)
			local tc2=g:GetFirst()
			if tc2:IsAbleToHand() and tc2:IsAbleToGrave() then
				if Duel.SelectYesNo(tp,aux.Stringid(60151124,3)) then
					Duel.SendtoHand(tc2,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc2)
				else
					Duel.SendtoGrave(tc2,REASON_EFFECT)
				end
			elseif tc2:IsAbleToHand() and not tc2:IsAbleToGrave() then
				Duel.SendtoGrave(tc2,REASON_EFFECT)
			elseif not tc2:IsAbleToHand() and tc2:IsAbleToGrave() then
				Duel.SendtoHand(tc2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc2)
			end
		end
	end
end
