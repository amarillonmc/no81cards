--里魂的残念
function c98500240.initial_effect(c)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(c98500240.actcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SPECIAL_SUMMON
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500240,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,98500240)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c98500240.target)
	e2:SetOperation(c98500240.activate)
	c:RegisterEffect(e2)
	--sset
	--set
	--[[local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98500240,2))
	e4:SetCategory(CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c98500240.cost)
	e4:SetCountLimit(1,98500240)
	e4:SetTarget(c98500240.settg2)
	e4:SetOperation(c98500240.setop2)
	c:RegisterEffect(e4)]]
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98500240,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCountLimit(1,98500241)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c98500240.sptg2)
	e5:SetOperation(c98500240.spop2)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98500241,5))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCost(aux.bfgcost)
	e6:SetCountLimit(1,98500242)
	e6:SetTarget(c98500240.tdtg)
	e6:SetOperation(c98500240.tdop)
	c:RegisterEffect(e6)
end
function c98500240.afilter(c)
	return (c:IsPosition(POS_FACEUP) and c:IsType(TYPE_MONSTER)) and not (c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FLIP) and c:IsPosition(POS_FACEUP))
end
function c98500240.afilter2(c)
	return c:IsPosition(POS_FACEDOWN) or (c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FLIP) and c:IsPosition(POS_FACEUP))
end
function c98500240.actcon(e)
	return Duel.IsExistingMatchingCard(c98500240.afilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(c98500240.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c98500240.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,98500240,0,TYPES_EFFECT_TRAP_MONSTER,1000,2000,4,RACE_BEASTWARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98500240.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,98500240,0,TYPES_EFFECT_TRAP_MONSTER,1000,2000,4,RACE_BEASTWARRIOR,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_FLIP)
		if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then
			c:RegisterFlagEffect(98500240,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98500240,3))
			--double tribute
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
			e1:SetValue(c98500240.condition)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			c:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function c98500240.condition(e,c)
	return c:IsType(TYPE_FLIP) and e:GetHandler():IsFacedown()
end
function c98500240.setcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_FLIP)
end
function c98500240.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c98500240.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
function c98500240.setfilter(c)
	return c:IsSetCard(0x985) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(98500240) and c:IsSSetable()
end
function c98500240.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98500240.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500240.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c98500240.setop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98500240.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function c98500240.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c98500240.spfilter3,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2
		and Duel.IsExistingMatchingCard(c98500240.spfilter4,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98500240.mtfilter(c,e)
	return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and c:IsCanOverlay()
end
function c98500240.spfilter3(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_FLIP) and c:IsCanBeEffectTarget(e) and c:IsCanOverlay()
end
function c98500240.spfilter4(c,e,tp)
	return c:IsSetCard(0x985) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98500240.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c98500240.spfilter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local g=tg:Filter(c98500240.mtfilter,nil,e)
		local tc=g:GetFirst()
		while tc do
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			Duel.Overlay(sc,Group.FromCards(tc))
			tc=g:GetNext()
			if c:IsRelateToEffect(e) and c:IsCanOverlay() then
			   Duel.Overlay(sc,Group.FromCards(c))  
			   end
		end
	end
end
function c98500240.filter(c)
	return c:IsSetCard(0x985)
end
function c98500240.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c98500240.filter(chkc) end
	if chk==0 then return 
		 Duel.IsExistingTarget(c98500240.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98500240.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c98500240.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
 end