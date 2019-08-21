--雨符『雨夜怪谈』
local m=1141701
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1141701.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1141701.tg1)
	e1:SetOperation(c1141701.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1141701.con2)
	e2:SetTarget(c1141701.tg2)
	e2:SetOperation(c1141701.op2)
	c:RegisterEffect(e2)
--
end
--
c1141701.muxu_ih_KTatara=1
--
function c1141701.tfilter1(c,e,tp)
	return muxu.check_set_Tatara(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1141701.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c1141701.tfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if chk==0 then return (b1 or b2) end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1141701,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1141701,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,LOCATION_MZONE)
	end
	if sel==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
--
function c1141701.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsDefensePos,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if sg:GetCount()<1 then return end
		Duel.ChangePosition(sg,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
	if sel==2 then
		if Duel.GetLocationCountFromEx(tp)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=Duel.SelectMatchingCard(tp,c1141701.tfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,tp,2,REASON_RULE)
		end
		if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
--
function c1141701.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,0x4040)~=0 and c:IsPreviousLocation(LOCATION_HAND)
end
--
function c1141701.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
--
function c1141701.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSSetable() then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.SSet(tp,c)
	Duel.ConfirmCards(1-tp,c)
end
--
