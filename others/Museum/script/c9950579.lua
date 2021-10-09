--fate·英灵切嗣
function c9950579.initial_effect(c)
	  --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9950579.lcheck)
	c:EnableReviveLimit()
--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950579.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
  --activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6ba6))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
 --to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950579,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,9950579)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9950579.tgtg)
	e2:SetOperation(c9950579.tgop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950579,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetTarget(c9950579.tptg)
	e2:SetOperation(c9950579.tpop)
	c:RegisterEffect(e2)
end
function c9950579.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6ba6)
end
function c9950579.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950579,0))
end
function c9950579.tgfilter(c)
	return c:IsSetCard(0x6ba6) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c9950579.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c9950579.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950579.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9950579.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9950579.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950579.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
		and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local zone=e:GetHandler():GetLinkedZone(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9950579.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
		if zone~=0 and sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c9950579.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c9950579.tpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9950579,2))
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
