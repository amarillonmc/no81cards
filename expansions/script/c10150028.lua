--光道神谕者 露米娅
function c10150028.initial_effect(c)
	--discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10150028,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10150028)
	e1:SetCost(c10150028.discost)
	e1:SetTarget(c10150028.distg)
	e1:SetOperation(c10150028.disop)
	c:RegisterEffect(e1) 
	--discard deck 2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(10150028,2))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10150028.discon)
	e2:SetTarget(c10150028.distg)
	e2:SetOperation(c10150028.disop)
	c:RegisterEffect(e2)   
end
function c10150028.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c10150028.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c10150028.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end
function c10150028.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10150028.rfilter(c,tp)
	return c:IsLevelAbove(1) and Duel.IsPlayerCanDiscardDeck(tp,math.min(5,c:GetLevel()))
end
function c10150028.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()~=100 then e:SetLabel(0) return false end
	   e:SetLabel(0)
	   return Duel.CheckReleaseGroupEx(tp,c10150028.rfilter,1,nil,tp)
	end
	e:SetLabel(0)
	e:SetValue(0)
	local tc=Duel.SelectReleaseGroupEx(tp,c10150028.rfilter,1,1,nil,tp):GetFirst()
	local lv=tc:GetLevel()
	e:SetValue(lv)
	Duel.Release(tc,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,math.min(5,lv))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c10150028.spfilter(c,e,tp)
	return c:IsSetCard(0x38) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10150028.disop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetValue()
	Duel.DiscardDeck(tp,math.min(5,lv),REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local sg=g:Filter(c10150028.spfilter,nil,e,tp)
	if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10150028,1))  then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
	end
end

