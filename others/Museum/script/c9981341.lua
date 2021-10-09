--天空璋 四季异变-冬
function c9981341.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(aux.TargetBoolFunction(Card.IsFacedown))
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c9981341.dirtg)
	c:RegisterEffect(e3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981341,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9981341.target)
	e1:SetOperation(c9981341.activate)
	c:RegisterEffect(e1)
	--set card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981341,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,9981341)
	e1:SetTarget(c9981341.settg)
	e1:SetOperation(c9981341.setop)
	c:RegisterEffect(e1)
end
function c9981341.dirtg(e,c)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c9981341.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6bd1)
end
function c9981341.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9981341.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sc=Duel.GetMatchingGroupCount(c9981341.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c9981341.filter(chkc) end
	if chk==0 then return sc>0 and Duel.IsExistingTarget(c9981341.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9981341.filter,tp,0,LOCATION_MZONE,1,sc,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c9981341.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c9981341.setfilter(c,e,tp)
	if not c:IsSetCard(0x6bd1) or c:IsCode(9981341) then return false end
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else return c:IsSSetable() end
end
function c9981341.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9981341.setfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9981341.setfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9981341.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetFirst():IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function c9981341.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local res=false
	if tc:IsType(TYPE_MONSTER) then
		res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		if res~=0 then Duel.ConfirmCards(1-tp,tc) end
	else
		res=Duel.SSet(tp,tc)
	end
	if res~=0 then
		local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end