--星辉之星仪
function c9910602.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910602.spcon)
	e2:SetTarget(c9910602.sptg)
	e2:SetOperation(c9910602.spop)
	c:RegisterEffect(e2)
end
function c9910602.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c9910602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)>0
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsPlayerCanSpecialSummon(tp)
		and (Duel.GetMZoneCount(tp)>0 or Duel.GetLocationCountFromEx(tp)>0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	if b1 then
		Duel.SetTargetParam(Duel.SelectOption(tp,1056,1063,1073,1076))
	else
		Duel.SetTargetParam(Duel.SelectOption(tp,1056,1063,1073))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_EXTRA)
end
function c9910602.spop(e,tp,eg,ep,ev,re,r,rp)
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct=nil
	if opt==0 then ct=TYPE_FUSION end
	if opt==1 then ct=TYPE_SYNCHRO end
	if opt==2 then ct=TYPE_XYZ end
	if opt==3 then ct=TYPE_LINK end
	if not Duel.IsPlayerCanSpecialSummon(tp)
		or Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 then return end
	Duel.ShuffleExtra(tp)
	Duel.ConfirmExtratop(tp,1)
	local tc=Duel.GetExtraTopGroup(tp,1):GetFirst()
	if tc:IsType(ct) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
