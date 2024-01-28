--吸血鬼红舞者
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,2)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Special Summon this card from your GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,6))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local ac=Duel.AnnounceType(tp)
	e:SetLabel(ac)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ty=TYPE_MONSTER
	if e:GetLabel()==1 then ty=TYPE_SPELL
	elseif e:GetLabel()==2 then ty=TYPE_TRAP end
	if Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_HAND,nil,ty)>0 and Duel.IsChainDisablable(0)
		and Duel.SelectYesNo(1-tp,aux.Stringid(id,4)) then
		Duel.DiscardHand(1-tp,Card.IsType,1,1,REASON_EFFECT+REASON_DISCARD,nil,ty)
		Duel.NegateEffect(0)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,ty)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-tp,Card.IsType,1-tp,LOCATION_DECK,0,1,1,nil,ty)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
end
function s.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_GRAVE) and c:IsPreviousControler(1-tp)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(5)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetValue(6)
			c:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
