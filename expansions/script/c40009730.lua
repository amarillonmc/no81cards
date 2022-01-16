--假面的奇术师 哈利
local m=40009730
local cm=_G["c"..m]
cm.named_with_MagiaDollD=1
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,cm.lcheck)
	c:EnableReviveLimit()  
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.thcost)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)  
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.negcon)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
end
function cm.MagiaDoll(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagiaDoll
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spfilter2(c,e,tp)
	return cm.MagiaDoll(c) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) or not c:IsForbidden())
		and Duel.IsExistingMatchingCard(cm.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function cm.spfilter3(c,e,tp)
	return cm.MagiaDoll(c) and c:IsFaceup() and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) or not c:IsForbidden())
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(cm.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g2=Duel.SelectMatchingCard(tp,cm.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	if g1:GetCount()>0 then
		if Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())<=0 then
			local tc1=g2:GetFirst()
			if tc1 then
				Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
			local tc2=g1:GetFirst()
			if tc2 then
			  --  g1:Sub(tc1)
		  --  end
			Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			g1:Merge(g2)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local sg1=g1:Select(tp,1,1,nil)
			local tc=sg1:GetFirst()
			if tc then
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				g1:Sub(sg1)
			end
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and c:GetLinkedGroup():IsExists(cm.tgfilter,1,nil)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
