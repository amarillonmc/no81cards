--蝶幻-「流」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401020.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c71401020.mfilter,aux.NonTuner(c71401020.mfilter),1)
	c:EnableReviveLimit()
	--Fissure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c71401020.rmtarget)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--Gravekeeper's Servant
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD)
	e1a:SetCode(81674782)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1a:SetTargetRange(0xff,0xff)
	e1a:SetTarget(c71401020.checktg)
	c:RegisterEffect(e1a)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401020,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71401020)
	e2:SetCost(yume.ButterflyLimitCost)
	e2:SetTarget(c71401020.tg2)
	e2:SetOperation(c71401020.op2)
	c:RegisterEffect(e2)
	--cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71401020,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,71501020)
	e3:SetCondition(c71401020.con3)
	e3:SetCost(yume.ButterflyLimitCost)
	e3:SetTarget(c71401020.tg3)
	e3:SetOperation(c71401020.op3)
	c:RegisterEffect(e3)
	yume.ButterflyCounter()
end
c71401020.material_type=TYPE_SYNCHRO
function c71401020.mfilter(c)
	return c:IsSynchroType(TYPE_SYNCHRO) and c:IsRace(RACE_SPELLCASTER)
end
function c71401020.rmtarget(e,c)
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c71401020.checktg(e,c)
	return not c:IsPublic()
end
function c71401020.filter2(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c)
end
function c71401020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	local ct2=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and ct1>0 and Duel.IsPlayerCanDraw(tp,ct1)
			and ct2>0 and ct2==Duel.GetDecktopGroup(tp,ct2):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
	end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c71401020.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	if Duel.Draw(tp,ct1,REASON_EFFECT)==0 then return end
	local ct2=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local tg=Duel.GetDecktopGroup(tp,ct2)
	Duel.DisableShuffleCheck()
	if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,0,0,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
	if not c:IsImmuneToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(71401001,6)) then
		Duel.BreakEffect()
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e4=Effect.CreateEffect(c)
			e4:SetCode(EFFECT_CHANGE_TYPE)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e4:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e4)
		end
	end
end
function c71401020.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c71401020.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local ct2=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then
		return ct1>0 and Duel.IsPlayerCanDraw(tp,ct1)
			ct2>0 and ct2==Duel.GetDecktopGroup(tp,ct2):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct2,tp,LOCATION_DECK)
end
function c71401020.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if Duel.Draw(tp,ct1,REASON_EFFECT)==0 then return end
	local ct2=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	local tg=Duel.GetDecktopGroup(tp,ct2)
	Duel.DisableShuffleCheck()
	if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetDescription(aux.Stringid(71401020,2))
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		e2:SetValue(c71401020.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c71401020.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end