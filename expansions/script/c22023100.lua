--人理彼面 超级班扬
function c22023100.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22023050,aux.FilterBoolFunction(Card.IsFusionSetCard,0xff1),2,true,true)
	aux.EnableChangeCode(c,22023050,LOCATION_MZONE)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023100,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22023100)
	e1:SetCondition(c22023100.descon)
	e1:SetCost(c22023100.descost)
	e1:SetTarget(c22023100.destg)
	e1:SetOperation(c22023100.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023100,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c22023100.spcon)
	e2:SetTarget(c22023100.sptg)
	e2:SetOperation(c22023100.spop)
	c:RegisterEffect(e2)
end
function c22023100.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c22023100.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22023100.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c22023100.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		local ct=Duel.Destroy(tg,REASON_EFFECT)
		local b1=c:IsFaceup()
		local b2=c:IsFaceup()
		local b3=c:IsFaceup()
		if chk==0 then return ct>0 and (b1 or b2 or b3) end
		local sel=0
		local off=0
		repeat
			local ops={}
			local opval={}
			off=1
			if b1 then
				ops[off]=aux.Stringid(22023100,1)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(22023100,2)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(22023100,3)
				opval[off-1]=3
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			if opval[op]==1 then
				sel=sel+1
				b1=false
			elseif opval[op]==2 then
				sel=sel+2
				b2=false
			else
				sel=sel+4
				b3=false
			end
			ct=ct-1
		until ct==0 or off<3 or not Duel.SelectYesNo(tp,aux.Stringid(22023100,4))
		if bit.band(sel,1)~=0 and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PIERCE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(22023100,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22023100,1))
		end
		if bit.band(sel,2)~=0 and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
			e2:SetValue(2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e2)
			c:RegisterFlagEffect(22023100,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22023100,2))
		end
		if bit.band(sel,4)~=0 and c:IsFaceup() then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(1000)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e4)
		end
	end
end
function c22023100.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c22023100.spfilter(c,e,tp)
	return c:IsSetCard(0x6ff1) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22023100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22023100.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22023100.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22023100.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
