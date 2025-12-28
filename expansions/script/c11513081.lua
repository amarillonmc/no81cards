--骑士皇 普莉梅拉·誓约
function c11513081.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSetCard,0x1a2),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11513081,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1) 
	e1:SetTarget(c11513081.negtg)
	e1:SetOperation(c11513081.negop)
	c:RegisterEffect(e1) 
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11513081,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)  
	e2:SetCost(c11513081.spcost)
	e2:SetTarget(c11513081.sptg)
	e2:SetOperation(c11513081.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(function(e,c) 
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) end)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
	--set
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(11513081,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c11513081.settg)
	e4:SetOperation(c11513081.setop)
	c:RegisterEffect(e4)
end
c11513081.material_type=TYPE_SYNCHRO 
function c11513081.tdgck(g) 
	return g:GetClassCount(Card.GetLocation)==g:GetCount() 
end 
function c11513081.negtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)  
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and g:CheckSubGroup(c11513081.tdgck,1,3) end 
	local sg=g:SelectSubGroup(tp,c11513081.tdgck,false,1,3) 
	local x=Duel.SendtoDeck(sg,nil,2,REASON_COST)
	e:SetLabel(x)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,sg:GetCount(),PLAYER_ALL,LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,x*800)
end
function c11513081.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel() 
	local ng=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,x,x,nil) 
	if ng:GetCount()>0 then 
		local tc=ng:GetFirst() 
		while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end 
		tc=ng:GetNext() 
		end 
	end
	Duel.Recover(tp,x*800,REASON_EFFECT)
end
function c11513081.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c11513081.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11513081.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then  
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11513081,0)) then 
			Duel.BreakEffect() 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
		end  
	end
end
function c11513081.stfil(c)
	return c:IsSetCard(0x1a2) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() 
end
function c11513081.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513081.stfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c11513081.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c11513081.stfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end



