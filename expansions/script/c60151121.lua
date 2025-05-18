--艾奇军团 御雷之影
function c60151121.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60151121.xyzfilter,4,2)
	c:EnableReviveLimit()
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151121.atkcon)
	e1:SetTarget(c60151121.cointg)
	e1:SetOperation(c60151121.coinop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151121,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(c60151121.thtg)
	e2:SetOperation(c60151121.thop)
	c:RegisterEffect(e2)
end
c60151121.toss_coin=true
function c60151121.xyzfilter(c)
	return c:IsSetCard(0x9b23)
end
function c60151121.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60151121.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():IsHasEffect(60151199)
end
function c60151121.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151121.chlimit)
		Duel.RegisterFlagEffect(tp,60151121,RESET_CHAIN,0,1)
	else
		e:SetCategory(CATEGORY_COIN+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,nil,1,1-tp,LOCATION_MZONE)
end
function c60151121.chlimit(e,ep,tp)
	return tp==ep
end
function c60151121.filter2(c)
	return c:IsAbleToGrave()
end
function c60151121.coinop(e,tp,eg,ep,ev,re,r,rp)

local c=e:GetHandler()
	if c:IsFacedown() then return end
	local res=0
	if Duel.GetFlagEffect(tp,60151121)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		if Duel.SelectYesNo(tp,aux.Stringid(60151121,0)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,c60151121.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoGrave(g1,REASON_EFFECT)
			end
		end
	end
	if res==1 then
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_UPDATE_ATTACK)
		e11:SetValue(e:GetHandler():GetAttack()/2)
		e11:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e11)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetAttack()/2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(tc:GetDefense()/2)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c60151121.filter3(c)
	return not c:IsCode(60151121) and c:IsAbleToGrave()
end
function c60151121.e1tgfilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c60151121.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(c60151121.e1tgfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,e:GetHandler(),e) and e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_MZONE) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151121.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_MZONE) then return end
	if e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151121,2))
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60151121.e1tgfilter),tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,e:GetHandler(),e)
		Duel.HintSelection(g)
		local rc=g:GetFirst()
		if rc:IsType(TYPE_MONSTER) then 
			local og=rc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
		end
		Duel.Overlay(e:GetHandler(),Group.FromCards(rc))
		--indes
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(60151121,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
		--battle indestructable
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e2)   
	end
end