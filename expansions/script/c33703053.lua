--动物朋友 美西螈
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsSetCard(0x442) and c:IsPublic()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function s.spfilter(c,e,tp,id)
	return c:IsReason(REASON_DESTROY) and c:GetTurnID()==id
		and c:IsSetCard(0x442) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) or g:GetCount()>2 and g:FilterCount(Card.IsAbleToDeck,nil)==g:GetCount() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount())) end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil)
	local ct=g:GetCount()
	local op1=ct>=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsRelateToEffect(e)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local op2=ct>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:FilterCount(Card.IsAbleToDeck,nil)==ct
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount())
	local off=1
	local ops={}
	local opval={}
	if op1 then
		ops[off]=aux.Stringid(id,0)
		opval[off-1]=1
		off=off+1
	end
	if op2 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	elseif opval[op]==2 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then
			ft=1
		end
		local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,Duel.GetTurnCount())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=tg:Select(tp,1,ft,nil)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			aux.PlaceCardsOnDeckBottom(tp,g,REASON_EFFECT)
		end
	end
end