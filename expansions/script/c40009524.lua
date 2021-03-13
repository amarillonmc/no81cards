--残阳之骑士 赫洛诺斯
function c40009524.initial_effect(c)
	aux.AddCodeList(c,40009510)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009524,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009524)
	e1:SetCost(c40009524.spcost)
	e1:SetTarget(c40009524.sptg1)
	e1:SetOperation(c40009524.spop1)
	c:RegisterEffect(e1) 
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009524,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009525)
	e2:SetTarget(c40009524.sptg2)
	e2:SetOperation(c40009524.spop2)
	c:RegisterEffect(e2)   
end
function c40009524.rfilter(c,ft,tp)
	return (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c40009524.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c40009524.rfilter,1,nil,ft,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c40009524.rfilter,1,1,nil,ft,tp)
	e:SetLabel(sg:GetFirst():GetRace())
	Duel.Release(sg,REASON_COST)
end
function c40009524.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c40009524.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local c=e:GetHandler()
		local turnp=Duel.GetTurnPlayer()
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,turnp,LOCATION_EXTRA,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,turnp,0,LOCATION_EXTRA,nil)
		if bit.band(e:GetLabel(),RACE_WARRIOR)~=0 and g:GetCount()>0 and g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
			local sg=g:Select(turnp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGRAVE)
			local sg2=g2:Select(1-turnp,1,1,nil)
			sg:Merge(sg2)
			if sg:GetCount()>0 then
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end
function c40009524.spfilter(c,e,tp)
	return c:IsCode(40009510) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009524.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c40009524.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c40009524.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009524.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end



