--GUARDIAN 今宫
function c33700045.initial_effect(c)
	  --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700045,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c33700045.spcon)
	e1:SetCost(c33700045.spcost)
	e1:SetTarget(c33700045.sptg)
	e1:SetOperation(c33700045.spop)
	c:RegisterEffect(e1)
end
function c33700045.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c33700045.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700045.cfilter,1,nil,tp)
end
function c33700045.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1021,eg:GetCount(),REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1021,eg:GetCount(),REASON_COST) 
end
function c33700045.pfilter(c)
	return  c:IsFaceup() and c:IsCanTurnSet()
end
function c33700045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:IsExists(c33700045.pfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33700045.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	if Duel.ChangePosition(eg,POS_FACEDOWN_DEFENSE)~=0 then
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=og:GetNext()
		end
	end
	end
end
