--乱无章法的嵌合
function c72411740.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c72411740.target)
	e1:SetOperation(c72411740.operation)
	c:RegisterEffect(e1)
	--def to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c72411740.con)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c72411740.tg)
	e2:SetOperation(c72411740.op)
	c:RegisterEffect(e2)
end
function c72411740.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local hd=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then hd=hd-1 end
		return hd>0 end
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
end
function c72411740.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72411740.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local sg1=Group.Filter(sg,Card.IsType,nil,TYPE_SPELL):GetCount()
	local sg2=Group.Filter(sg,Card.IsType,nil,TYPE_TRAP):GetCount()
	local sg3=Group.Filter(sg,Card.IsType,nil,TYPE_MONSTER):GetCount()
	local ct=Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	if sg1>1 then
		--Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT) end
	if sg2>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c72411740.filter,tp,LOCATION_DECK,0,2,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
			--Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c72411740.filter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
			if g:GetCount()==2 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
	end
	if sg3>1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		--Duel.BreakEffect()
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c72411740.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c72411740.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c72411740.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end