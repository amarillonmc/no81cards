--契灵·荒川剑豪
local m=70052407
local set=0xff0
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.spcon)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,70052408)
	e2:SetTarget(cm.stptg)
	e2:SetOperation(cm.stpop)
	c:RegisterEffect(e2)
end
	--special summon
function cm.spfilter(c)
	return c:IsSetCard(0xff0) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
	--extra Summon
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.tfilter(c,e,tp)
	return c:IsSetCard(0xff0) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
--
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_UPDATE_ATTACK)
		e2_1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e2_1:SetValue(1500)
		e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2_1,true)
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local gn=Group.CreateGroup()
			local g2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)  
			while g2:GetCount()>0 do
				local tc2=g2:GetFirst()
				if tc2:IsCanBeBattleTarget(tc) then
					gn:AddCard(tc2)
					g2:RemoveCard(tc2)
				else
					g2:RemoveCard(tc2)
				end
			end
			if gn:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
				local g1=gn:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
				if g1:GetCount()>0 then
					local tc1=g1:GetFirst()
					if tc1:IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE) then
						if not tc1:IsPosition(POS_FACEUP_ATTACK) then
							Duel.ChangePosition(tc1,POS_FACEUP_ATTACK)
						end
						if not tc:IsPosition(POS_FACEUP_ATTACK) then
							Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
						end
						if tc1:IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE) then 
							Duel.CalculateDamage(tc,tc1)
						end
					end
				end
			end
		end
	end
end
	--special summon
function cm.cfilter(c,e,tp)
	return c:IsSetCard(0xff0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.stptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.stpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end