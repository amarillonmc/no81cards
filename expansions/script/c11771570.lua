-- 混沌龙神 混沌的归来者
function c11771570.initial_effect(c)
	-- 同调召唤手续
	aux.AddSynchroProcedure(c,c11771570.tfilter,aux.NonTuner(c11771570.ntfilter),1)
	c:EnableReviveLimit()
	-- 翻开检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11771570,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11771570)
	e1:SetCondition(c11771570.con1)
	e1:SetTarget(c11771570.tg1)
	e1:SetOperation(c11771570.op1)
	c:RegisterEffect(e1)
	-- 除外特招
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771570,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,11771571)
	e2:SetCost(c11771570.cost2)
	e2:SetTarget(c11771570.tg2)
	e2:SetOperation(c11771570.op2)
	c:RegisterEffect(e2)
end
-- 同调素材：光属性混沌调整
function c11771570.tfilter(c)
	return c:IsSetCard(0xcf) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
-- 同调素材：暗属性混沌怪兽
function c11771570.ntfilter(c)
	return c:IsSetCard(0xcf) and c:IsAttribute(ATTRIBUTE_DARK)
end
-- 召唤限制
function c11771570.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_SYNCHRO) and not c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
-- 1
function c11771570.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c11771570.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11771570.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11771570.filter1(c)
	return c:IsSetCard(0xcf) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c11771570.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local lg=g:Filter(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
	local dg=g:Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	local stg=g:Filter(c11771570.filter1,nil)
	local b1=lg:GetCount()>0 and dg:GetCount()>0
	local b2=stg:GetCount()>0
	local sel=0
	if b1 and b2 then
		sel=Duel.SelectOption(tp,aux.Stringid(11771570,2),aux.Stringid(11771570,3))
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(11771570,2))
	elseif b2 then
		Duel.SelectOption(tp,aux.Stringid(11771570,3))
		sel=1
	else
		Duel.SortDecktop(tp,tp,g:GetCount())
		return
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local slg=lg:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sdg=dg:Select(tp,1,1,nil)
		slg:Merge(sdg)
		Duel.SendtoHand(slg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,slg)
		g:Sub(slg)
		Duel.SortDecktop(tp,tp,g:GetCount())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=stg:Select(tp,1,1,nil)
		Duel.SSet(tp,sg:GetFirst())
		g:Sub(sg)
		local mg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		if mg:GetCount()>0 then
			Duel.SendtoGrave(mg,REASON_EFFECT)
		end
		g:Sub(mg)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
end
-- 2
function c11771570.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11771570.filter2(c,attr)
	return c:IsAttribute(attr) and c:IsAbleToRemove()
end
function c11771570.filter3(c,e,tp)
	return c:IsSetCard(0xcf) and c:IsType(TYPE_MONSTER) and not c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c11771570.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lg=Duel.GetMatchingGroup(c11771570.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler(),ATTRIBUTE_LIGHT)
		local dg=Duel.GetMatchingGroup(c11771570.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler(),ATTRIBUTE_DARK)
		return lg:GetCount()>0 and dg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11771570.filter3,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11771570.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11771570.op2(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(c11771570.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
	local dg=Duel.GetMatchingGroup(c11771570.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
	if lg:GetCount()==0 or dg:GetCount()==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg1=lg:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg2=dg:Select(tp,1,1,nil)
	rg1:Merge(rg2)
	
	if Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT)==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11771570.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
