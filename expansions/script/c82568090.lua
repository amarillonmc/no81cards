--AKD-辉旗的琴柳
function c82568090.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x825),aux.FilterBoolFunction(c82568090.fusionfilter1),1,true,true)
	--Summon 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,82568090)
	e3:SetOperation(c82568090.ctop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,82568190)
	e4:SetCost(c82568090.cost)
	e4:SetTarget(c82568090.target)
	e4:SetOperation(c82568090.operation)
	c:RegisterEffect(e4)
end
function c82568090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) 
	   and Duel.IsCanRemoveCounter(tp,1,0,0x5825,3,REASON_COST) and Duel.GetTurnPlayer()~=e:GetHandler():GetControler() end
	Duel.RemoveCounter(tp,1,0,0x5825,3,REASON_COST)
end
function c82568090.spfilter(c,e,tp,mg)
	return c:IsSetCard(0x825) and (c:IsLevelBelow(9) or c:IsRankBelow(6) or c:IsLinkBelow(5)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		   and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c82568090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Group.CreateGroup()
	mg:AddCard(e:GetHandler())
	if chk==0 then return Duel.IsExistingMatchingCard(c82568090.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c82568090.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Group.CreateGroup()
	mg:AddCard(e:GetHandler())
	Duel.Release(e:GetHandler(),REASON_COST)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568090.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c82568090.filter(c)
	return c:IsFaceup() 
end
function c82568090.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c82568090.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	local ri=0
	  while tc do   
	  tc:AddCounter(0x5825,1)
	  ri=tc:GetCounter(0x5825)
	  local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(ri*400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	  tc=g:GetNext()
   end
end
function c82568090.fusionfilter1(c)
	return  c:IsLevelAbove(5) 
end 