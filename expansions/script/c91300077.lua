--作弊勇者 阿尔比昂
function c91300077.initial_effect(c)
	--fusion summon
	aux.AddFusionProcFunRep2(c,c91300077.mfilter,2,2,true)
	c:EnableReviveLimit()
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,0)
	--e1:SetCost(c91300077.costchk)
	e1:SetTarget(c91300077.costtg)
	e1:SetOperation(c91300077.costop)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c91300077.coinop)
	c:RegisterEffect(e2)
	--
	if not CROSSROADS_COIN then
		CROSSROADS_COIN = true
		Crossroads_coin_effect_list={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c91300077.clear)
		Duel.RegisterEffect(ge0,0)
	end
end
function c91300077.clear(e,tp,eg,ep,ev,re,r,rp)
	Crossroads_coin_effect_list={}
end
function c91300077.mfilter(c)
	return c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_COIN))
end
function c91300077.tgfilter(c)
	return c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_COIN)) and c:IsAbleToGrave()
end
function c91300077.costchk(e,te_or_c,tp)
	return Duel.GetFlagEffect(tp,91300077)==0 and Duel.IsExistingMatchingCard(c91300077.tgfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsAbleToGrave()
end
function c91300077.costtg(e,te,tp)
	e:SetLabelObject(te)
	return te:IsHasProperty(EFFECT_FLAG_DICE)-- and te~=c91300077.used_e
end
function c91300077.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if Duel.GetFlagEffect(tp,91300077)==0 and Duel.IsExistingMatchingCard(c91300077.tgfilter,tp,LOCATION_HAND,0,1,te:GetHandler()) and e:GetHandler():IsAbleToGrave() and c91300077.used_e~=e:GetLabelObject() and Duel.SelectYesNo(tp,aux.Stringid(91300077,2)) then
		c91300077.used_e=e:GetLabelObject()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c91300077.tgfilter,tp,LOCATION_HAND,0,1,1,te:GetHandler())
		g:AddCard(e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
		local res=Duel.TossCoin(tp,1)
		if res==1 then
			c91300077.obverse(e,tp,eg,ep,ev,re,r,rp,1)
			if e:IsActivated() then
				Crossroads_coin_effect_list[aux.Stringid(91300077,1)]=c91300077.reverse
			end
		else
			c91300077.reverse(e,tp,eg,ep,ev,re,r,rp,1)
			if e:IsActivated() then
				Crossroads_coin_effect_list[aux.Stringid(91300077,0)]=c91300077.obverse
			end
		end
	end
end
function c91300077.thfilter(c)
	return (c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_COIN)) or c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) or c:IsCode(9300420,10173087,33701339,91300067,91300073,91300079)) and c:IsAbleToHand() and aux.NecroValleyFilter()(c)
end
function c91300077.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91300077.thfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c91300077.obverse(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c91300077.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c91300077.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if not tc then return end
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c91300077.reverse(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	else
		Duel.RegisterFlagEffect(tp,91300077,RESET_PHASE+PHASE_END,0,1)
	end
end
function c91300077.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,91300077)==0 then
		Duel.Hint(HINT_CARD,0,91300077)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetCondition(c91300077.repcon)
		e1:SetOperation(c91300077.repop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c91300077.repcon(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL) then return false end
	return r&REASON_COST>0
end
function c91300077.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,91300077)
	if Duel.TossCoin(tp,1)==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetLabelObject(re)
		--e1:SetCondition(c91300077.rthcon)
		e1:SetOperation(c91300077.rthop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--[[re:GetHandler():CancelToGrave()
		Duel.SendtoHand(re:GetHandler(),nil,REASON_EFFECT)]]
	end
end
function c91300077.rthcon(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT)
	return te==e:GetLabelObject()
end
function c91300077.rthop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject():GetHandler()
	if rc:IsRelateToEffect(e:GetLabelObject()) then
		rc:CancelToGrave()
		Duel.SendtoHand(rc,nil,REASON_EFFECT)
	end
end
