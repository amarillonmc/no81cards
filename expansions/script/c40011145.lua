--冰狱的死龙 掘墓龙
local m=40011145
local cm=_G["c"..m]
cm.named_with_IcePrison=1
function cm.IcePrison(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_IcePrison
end
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.tetg)
	e2:SetOperation(cm.teop)
	c:RegisterEffect(e2)
	
end
function cm.tfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) 
		and c:IsControler(tp) 
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(cm.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev) and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_EXTRA,0,1,nil)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.NegateActivation(ev)
	end
end
function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and ((c:IsFaceup() or c:IsLocation(LOCATION_HAND)) or (cm.IcePrison(c) and c:IsLocation(LOCATION_DECK)))
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE)
end
function cm.thfilter(c)
	return cm.IcePrison(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local tc=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)~=0 and tc:IsPreviousLocation(LOCATION_HAND) then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,nil)
		local b1=Duel.IsPlayerCanDraw(tp,1)
		local b2=sg:GetCount()>0
		local b3=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local ops={}
		local opval={}
		local off=1
		if b1 then
			ops[off]=aux.Stringid(m,3)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(m,4)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(m,5)
			opval[off-1]=3
			off=off+1
		end
		ops[off]=aux.Stringid(m,6)
		opval[off-1]=4
		off=off+1
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif opval[op]==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		elseif opval[op]==3 then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
