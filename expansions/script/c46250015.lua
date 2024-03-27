--英龙骑-雪虎
function c46250015.initial_effect(c)
	c:SetSPSummonOnce(46250015)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c46250015.lfilter,2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c46250015.sumcon)
	e1:SetTarget(c46250015.sumtg)
	e1:SetOperation(c46250015.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c46250015.atkval)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c46250015.spcon)
	e5:SetCost(c46250015.spcost)
	e5:SetTarget(c46250015.sptg)
	e5:SetOperation(c46250015.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c46250015.limcon)
	e6:SetOperation(c46250015.limop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_CHAIN_END)
	e8:SetOperation(c46250015.limop2)
	c:RegisterEffect(e8)
end
function c46250015.lfilter(c)
	return c:IsLinkSetCard(0xfc0)
end
function c46250015.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c46250015.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fc0) and not c:IsForbidden()
end
function c46250015.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c46250015.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c46250015.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c46250015.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if not g then return end
		local tc=g:GetFirst()
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c46250015.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e2:SetRange(LOCATION_SZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c46250015.matval)
		tc:RegisterEffect(e2)
	end
end
function c46250015.eqlimit(e,c)
	return e:GetOwner()==c
end
function c46250015.matval(e,c,mg)
	return c:IsRace(RACE_WYRM) and c:IsControler(e:GetHandlerPlayer())
end
function c46250015.atkval(e,c)
	return Group.GetSum(c:GetEquipGroup():Filter(Card.IsSetCard,nil,0x1fc0),Card.GetTextAttack)
end
function c46250015.spcon(e,tp,eg,ep,ev,re,r,rp)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0) and Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil)
end
function c46250015.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	local g=c:GetEquipGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.Release(c,REASON_COST)
end
function c46250015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c46250015.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil) then
			local tg=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND,0,1,1,nil,true,nil)
			Duel.BreakEffect()
			Duel.Summon(tp,tg:GetFirst(),true,nil)
		else
			Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_HAND,0))
		end
	end
end
function c46250015.limcon(e,tp,eg,ep,ev,re,r,rp)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0)
end
function c46250015.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c46250015.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(46250015,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c46250015.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetFlagEffect(46250015)~=0 then
		Duel.SetChainLimitTillChainEnd(c46250015.chainlm)
	end
	e:GetHandler():ResetFlagEffect(46250015)
end
function c46250015.chainlm(e,rp,tp)
	return tp==rp
end
