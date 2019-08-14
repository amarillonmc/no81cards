--├军团亚席 极舞之赛尔菲┤
function c60151123.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c60151123.tfilter,aux.NonTuner(Card.IsSetCard,0x9b23),1)
	c:EnableReviveLimit()
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151101,2))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151123.atkcon)
	e1:SetTarget(c60151123.cointg)
	e1:SetOperation(c60151123.coinop)
	c:RegisterEffect(e1)
	local e111=Effect.CreateEffect(c)
	e111:SetDescription(aux.Stringid(60151101,2))
	e111:SetCategory(CATEGORY_TOGRAVE)
	e111:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e111:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e111:SetCode(EVENT_SPSUMMON_SUCCESS)
	e111:SetCondition(c60151123.atkcon2)
	e111:SetTarget(c60151123.cointg)
	e111:SetOperation(c60151123.coinop)
	c:RegisterEffect(e111)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(c60151123.rmtg)
	e2:SetOperation(c60151123.rmop)
	c:RegisterEffect(e2)
end
c60151123.toss_coin=true
function c60151123.tfilter(c)
	return c:IsSetCard(0x9b23)
end
function c60151123.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and not e:GetHandler():IsHasEffect(60151199)
end
function c60151123.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetHandler():IsHasEffect(60151199)
end
function c60151123.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151123.chlimit)
		Duel.RegisterFlagEffect(tp,60151123,RESET_CHAIN,0,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	end
end
function c60151123.chlimit(e,ep,tp)
	return tp==ep
end
function c60151123.filter2(c)
	return c:IsAbleToGrave()
end
function c60151123.coinop(e,tp,eg,ep,ev,re,r,rp)
	
local c=e:GetHandler()
	if c:IsFacedown() then return end
	local res=0
	if Duel.GetFlagEffect(tp,60151123)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		if Duel.SelectYesNo(tp,aux.Stringid(60151123,0)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,c60151123.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoGrave(g1,REASON_EFFECT)
			end
		end
	end
	if res==1 then
		--attack all
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(60151123,1))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ATTACK_ALL)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e4)
	end
end
function c60151123.filter3(c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(60151123) and c:IsAbleToGrave()
end
function c60151123.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c60151123.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c60151123.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c60151123.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g1:GetCount()>0 then
		if Duel.SendtoGrave(g1,REASON_EFFECT) then Duel.BreakEffect()
			local tc=Duel.GetFirstTarget()
			local tc2=g1:GetFirst()
			local atk=tc2:GetAttack()
			local def=tc2:GetDefense()
			if tc:IsRelateToEffect(e) and tc:IsFaceup() then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-atk)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetValue(-atk)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			end
		end
	end
end