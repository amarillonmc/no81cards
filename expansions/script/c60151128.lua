--├军团首席 全能之玛特咖┤
function c60151128.initial_effect(c)
	c:SetUniqueOnField(1,0,60151128)
	--xyz summon
	aux.AddXyzProcedure(c,c60151128.xyzfilter,12,2)
	c:EnableReviveLimit()
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151128.atkcon)
	e1:SetTarget(c60151128.cointg)
	e1:SetOperation(c60151128.coinop)
	c:RegisterEffect(e1)
	local e111=Effect.CreateEffect(c)
	e111:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e111:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e111:SetCode(EVENT_SPSUMMON_SUCCESS)
	e111:SetCondition(c60151128.atkcon2)
	e111:SetTarget(c60151128.cointg)
	e111:SetOperation(c60151128.coinop)
	c:RegisterEffect(e111)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60151128.atkcon2)
	e2:SetTarget(c60151128.target)
	e2:SetOperation(c60151128.activate)
	c:RegisterEffect(e2)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c60151128.reptg)
	c:RegisterEffect(e7)
end
c60151128.toss_coin=true
function c60151128.xyzfilter(c)
	return c:IsSetCard(0x9b23)
end
function c60151128.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9b23)
		and not e:GetHandler():IsHasEffect(60151199)
end
function c60151128.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9b23)
		and e:GetHandler():IsHasEffect(60151199)
end
function c60151128.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151128.chlimit)
		Duel.RegisterFlagEffect(tp,60151128,RESET_CHAIN,0,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
	end
end
function c60151128.chlimit(e,ep,tp)
	return tp==ep
end
function c60151128.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local res=0
	if Duel.GetFlagEffect(tp,60151128)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	if res==1 then
		--
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(60151123,1))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(0,1)
		e2:SetValue(aux.TRUE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetCondition(c60151128.limcon)
		e:GetHandler():RegisterEffect(e2)
	end
end
function c60151128.limcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<1
end
function c60151128.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9b23)
end
function c60151128.filter(c,e,tp)
	return c:GetSummonPlayer()==tp and not c:IsDisabled()
		and (not e or (c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)))
end
function c60151128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local a=eg:FilterCount(c60151128.filter,nil,nil,1-tp)
		local b=Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		return eg:IsExists(c60151128.filter,1,nil,nil,1-tp) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) 
			and b>=a and c:GetFlagEffect(60151128)==0
	end
	local g=eg:Filter(c60151128.filter,nil,nil,1-tp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,g:GetCount(),0,0)
	c:RegisterFlagEffect(60151128,RESET_CHAIN,0,1)
end
function c60151128.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(c60151128.filter,nil,e,1-tp)
	local b=Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 and b>0 and b>=g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,g:GetCount(),g:GetCount(),nil)
		if g1:GetCount()>0 then
			if Duel.SendtoGrave(g1,REASON_EFFECT) then
				local tc=g:GetFirst()
				while tc do
					if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
						Duel.NegateRelatedChain(tc,RESET_TURN_SET)
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+0x1fe0000)
						tc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetValue(RESET_TURN_SET)
						e2:SetReset(RESET_EVENT+0x1fe0000)
						tc:RegisterEffect(e2)
						local e3=Effect.CreateEffect(c)
						e3:SetDescription(aux.Stringid(60151128,1))
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
						e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
						e3:SetValue(1)
						e3:SetReset(RESET_EVENT+0x1fe0000)
						tc:RegisterEffect(e3)
						local e4=e3:Clone()
						e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
						tc:RegisterEffect(e4)
						local e5=e3:Clone()
						e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
						tc:RegisterEffect(e5)
						local e6=e3:Clone()
						e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
						tc:RegisterEffect(e6)
					end
					tc=g:GetNext()
				end
			end
		end
	end
end
function c60151128.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(60151128,2)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end