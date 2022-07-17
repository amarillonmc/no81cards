--永夏的扬帆
function c9910973.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910973.flag)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910973+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910973.target)
	e1:SetOperation(c9910973.activate)
	c:RegisterEffect(e1)
end
function c9910973.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910973.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x5954)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c9910973.filter(c,tp)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsStatus(STATUS_SPSUMMON_TURN)
		and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910973.spfilter1(c,e,tp,mg)
	local g=Group.FromCards(c)
	g:Merge(mg)
	return c:IsSetCard(0x5954) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9910973.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function c9910973.spfilter2(c,e,tp,mg)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetLevel()>0 and mg:CheckSubGroup(c9910973.gselect1,2,2,c)
end
function c9910973.spfilter3(c,e,tp,mg)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and mg:GetSum(Card.GetLevel)==c:GetLevel() and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c9910973.spfilter4(c,e,tp,lv)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsLevel(lv) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910973.gselect1(g,mc)
	return g:GetSum(Card.GetLevel)==mc:GetLevel() and Duel.GetLocationCountFromEx(tp,tp,g,mc)>0
end
function c9910973.gselect2(g,e,tp)
	return Duel.IsExistingMatchingCard(c9910973.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function c9910973.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910973.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9910973.tffilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910973.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,g)
	if chk==0 then return b1 or b2 end
end
function c9910973.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910973.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local g1=Duel.GetMatchingGroup(c9910973.tffilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	local g2=Duel.GetMatchingGroup(c9910973.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,g)
	local b1=#g1>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=#g2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not (b1 or b2) then return end
	local lab=0
	local loc=LOCATION_HAND+LOCATION_DECK
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9910973,0),aux.Stringid(9910973,1))==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		if tc then loc=loc-tc:GetLocation() end
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		lab=1
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		if tc then loc=loc-tc:GetLocation() end
		if tc and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
			g=Duel.GetMatchingGroup(c9910973.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
			if Duel.IsExistingMatchingCard(c9910973.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local rg=g:SelectSubGroup(tp,c9910973.gselect2,false,2,2,e,tp)
				local lv=rg:GetSum(Card.GetLevel)
				if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=Duel.SelectMatchingCard(tp,c9910973.spfilter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
					if #tg>0 then Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP) end
				end
			end
		end
		lab=2
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabel(lab,loc)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910973.regcon)
	e1:SetOperation(c9910973.regop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910973.regcon(e,tp,eg,ep,ev,re,r,rp)
	local lab,loc=e:GetLabel()
	local g=Duel.GetMatchingGroup(c9910973.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local b1=lab==2 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9910973.tffilter,tp,loc,0,1,nil,tp)
	local b2=lab==1
		and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910973.spfilter1,tp,loc,0,1,nil,e,tp,g)
	return b1 or b2
end
function c9910973.regop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(9910973,2)) then return end
	Duel.Hint(HINT_CARD,0,9910973)
	local lab,loc=e:GetLabel()
	local g=Duel.GetMatchingGroup(c9910973.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local g1=Duel.GetMatchingGroup(c9910973.tffilter,tp,loc,0,nil,tp)
	local g2=Duel.GetMatchingGroup(c9910973.spfilter1,tp,loc,0,nil,e,tp,g)
	if lab==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g2:Select(tp,1,1,nil)
		if sg:GetCount()>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
			g=Duel.GetMatchingGroup(c9910973.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
			if Duel.IsExistingMatchingCard(c9910973.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local rg=g:SelectSubGroup(tp,c9910973.gselect2,false,2,2,e,tp)
				local lv=rg:GetSum(Card.GetLevel)
				if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=Duel.SelectMatchingCard(tp,c9910973.spfilter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
					if #tg>0 then Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP) end
				end
			end
		end
	end
end
