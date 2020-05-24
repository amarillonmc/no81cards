--蚀刻龙·霸主龙
function c55100040.initial_effect(c)
	 --synchro summon
	aux.AddSynchroMixProcedure(c,c55100040.matfilter1,nil,nil,aux.NonTuner(Card.IsSetCard,0x9551,0xa551,0x6551),1)
	c:EnableReviveLimit()
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,55100040)
	e1:SetCost(c55100040.cost)
	e1:SetTarget(c55100040.target)
	e1:SetOperation(c55100040.activate)
	c:RegisterEffect(e1)
  --to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55100040,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,551000400)
	e3:SetTarget(c55100040.tgtg)
	e3:SetOperation(c55100040.tgop)
	c:RegisterEffect(e3)
end
function c55100040.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsSynchroType(TYPE_MONSTER) and c:IsSetCard(0x9551,0xa551,0x6551))
end
function c55100040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c55100040.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6551,0x9551,0xa551) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55100040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3
		and Duel.IsExistingMatchingCard(c55100040.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c55100040.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,7)
	local g=Duel.GetDecktopGroup(tp,7):Filter(c55100040.filter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if g:GetCount()>0 then
		if ft<=0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		elseif ft>=g:GetCount() then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,ft,ft,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			g:Sub(sg)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	Duel.ShuffleDeck(tp)
end
function c55100040.tgfilter(c)
	return c:IsSetCard(0x9551,0xa551,0x6551) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c55100040.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55100040.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c55100040.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c55100040.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end