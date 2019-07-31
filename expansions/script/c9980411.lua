--平成骑士空我·惊异全能
function c9980411.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,c9980411.synfilter,c9980411.tfilter,1)
	c:EnableReviveLimit()
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980411,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c9980411.rmtg)
	e3:SetOperation(c9980411.rmop)
	c:RegisterEffect(e3)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetCondition(c9980411.atkcon)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	--cannot diratk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980411.sumsuc)
	c:RegisterEffect(e8)
end
function c9980411.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980411,0))
end 
function c9980411.synfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c9980411.tfilter(c)
	return c:IsCode(9980400)
end
function c9980411.atkcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9980411.rmfilter1(c,tp)
	local ctype=bit.band(c:GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return c:IsFaceup() and ctype~=0 and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c9980411.rmfilter2,tp,0,LOCATION_ONFIELD,1,nil,ctype)
end
function c9980411.rmfilter2(c,ctype)
	return c:IsFaceup() and c:IsType(ctype) and c:IsAbleToRemove()
end
function c9980411.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(tp) and c9980411.rmfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9980411.rmfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c9980411.rmfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,tp)
	local ctype=bit.band(g1:GetFirst():GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	local g2=Duel.GetMatchingGroup(c9980411.rmfilter2,tp,0,LOCATION_ONFIELD,nil,ctype)
	local gr=false
	if g1:GetFirst():IsLocation(LOCATION_GRAVE) then gr=true end
	g1:Merge(g2)
	if gr then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
	end
end
function c9980411.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local tg=Group.FromCards(tc)
		local ct=Duel.Remove(tg,REASON_EFFECT,LOCATION_REMOVED)
		if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local ctype=bit.band(tc:GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
			local g=Duel.GetMatchingGroup(c9980411.rmfilter2,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e),ctype)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetValue(ct*300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			tg:Merge(g)
		end
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980411,1))
	end
end
