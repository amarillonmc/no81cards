local m=15000365
local cm=_G["c"..m]
cm.name="碎梦交辉"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000351)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--Shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,15000365)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d or a:GetControler()==d:GetControler() then return false end
	return (a:IsCode(15000351) and a:IsControler(tp)) or (d:IsCode(15000351) and d:IsControler(tp))
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,LOCATION_MZONE)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	if g:GetCount()>1 then
		if Duel.SendtoGrave(g,REASON_RULE)~=0 then
			local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			local op1=0
			if b1 then op1=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
			else op1=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end

			local b2=Duel.IsExistingMatchingCard(cm.spfilter,1-tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			local op2=0
			if b2 then op2=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))
			else op2=Duel.SelectOption(1-tp,aux.Stringid(m,1))+1 end
			Duel.BreakEffect()
			if op1==0 and op2~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				local tc=g:GetFirst()
				if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
			elseif op1~=0 and op2==0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(1-tp,cm.spfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,tp)
				local tc=g:GetFirst()
				if tc then Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP) end
			elseif op1==0 and op2==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				local tc=g:GetFirst()
				if tc then Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) end
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(1-tp,cm.spfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp)
				local tc=g:GetFirst()
				if tc then Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) end
				Duel.SpecialSummonComplete()
			end
		end
	end
end
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end