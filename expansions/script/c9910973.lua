--永夏的扬帆
require("expansions/script/c9910950")
function c9910973.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910973+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910973.target)
	e1:SetOperation(c9910973.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9910973.spcon)
	e2:SetCost(c9910973.spcost)
	e2:SetTarget(c9910973.sptg)
	e2:SetOperation(c9910973.spop)
	c:RegisterEffect(e2)
end
function c9910973.setfilter(c)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(9910973)
end
function c9910973.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
		return ft>0 and Duel.IsExistingMatchingCard(QutryYx.Filter0,tp,LOCATION_REMOVED,0,3,nil)
			and Duel.IsExistingMatchingCard(c9910973.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED)
end
function c9910973.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	local g1=Duel.GetMatchingGroup(QutryYx.Filter0,tp,LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(c9910973.setfilter,tp,LOCATION_DECK,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local op=0
	if #g1>=6 and #g2>=2 and ft>=2 then
		op=1+Duel.SelectOption(tp,aux.Stringid(9910973,0),aux.Stringid(9910973,1))
	elseif #g1>=3 and #g2>=1 and ft>=1 then
		op=1+Duel.SelectOption(tp,aux.Stringid(9910973,0))
	end
	if op>0 then
		res=QutryYx.ToDeck(tp,op*3)
		if res then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c9910973.setfilter,tp,LOCATION_DECK,0,op,op,nil)
			if g:GetCount()>0 then
				Duel.SSet(tp,g)
			end
		end
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
function c9910973.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9910973.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost(POS_FACEDOWN) end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
end
function c9910973.spfilter(c,e,tp)
	return c:IsSetCard(0x5954) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910973.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910973.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910973.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910973.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
