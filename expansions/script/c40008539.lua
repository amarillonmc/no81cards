--空牙团的刀语 瑞玛茹
function c40008539.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c40008539.lcheck)	
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008539,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,40008539)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c40008539.spcost)
	e2:SetTarget(c40008539.sptg)
	e2:SetOperation(c40008539.spop)
	c:RegisterEffect(e2)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c40008539.spcon2)
	e1:SetCountLimit(1,40008540)
	e1:SetTarget(c40008539.target)
	e1:SetOperation(c40008539.activate)
	c:RegisterEffect(e1)
end
function c40008539.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c40008539.cfilter(c,e,tp,zone)
	return Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingMatchingCard(c40008539.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalRace())
end
function c40008539.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then e:SetLabel(1) return true end
end
function c40008539.spfilter(c,e,tp)
	return c:IsSetCard(0x114) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008539.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if chk==0 then
		if e:GetLabel()==0 or not Duel.IsExistingMatchingCard(c40008539.cfilter,tp,LOCATION_MZONE,0,1,c,e,tp,zone) then return false end
		local g=Duel.GetMatchingGroup(c40008539.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return #g>0
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c40008539.cfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp,zone)
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	local cc=e:GetLabelObject()
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.GetMatchingGroup(c40008539.spfilter,tp,LOCATION_DECK,0,cc,e,tp,cc:GetOriginalRace(),zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40008539.spfilter2(c,e,tp,race,zone)
	return c:IsSetCard(0x114) and c:GetOriginalRace()~=race and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c40008539.spop(e,tp,eg,ep,ev,re,r,rp)
	local cc=e:GetLabelObject()
	if e:GetHandler():IsRelateToEffect(e) then
		local zone=e:GetHandler():GetLinkedZone(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c40008539.spfilter2,tp,LOCATION_DECK,0,1,1,cc,e,tp,cc:GetOriginalRace(),zone)
		Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c40008539.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c40008539.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c40008539.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc:IsSetCard(0x114) then
		if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(40008539,2)) then
			Duel.ConfirmCards(1-tp,tc)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end


