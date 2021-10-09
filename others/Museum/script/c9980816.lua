--假面骑士部·Fourze-火箭状态
function c9980816.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c9980816.lcheck)
	c:EnableReviveLimit()
	 --atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9980816.atktg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9980816)
	e1:SetTarget(c9980816.target)
	e1:SetOperation(c9980816.activate)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980816.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980816.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980816,2))
end
function c9980816.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xcbc1)
end
function c9980816.spfilter1(c,e,tp)
	return c:IsSetCard(0xcbc1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c9980816.atktg(e,c)
	return c:IsSetCard(0xcbc1)
end
function c9980816.fselect1(g,tp)
	return Duel.IsExistingMatchingCard(c9980816.synfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c9980816.synfilter(c,g)
	return c:IsSetCard(0xcbc1) and c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function c9980816.fselect2(g,tp)
	return Duel.IsExistingMatchingCard(c9980816.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c9980816.xyzfilter(c,g)
	return c:IsSetCard(0xcbc1) and c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
end
function c9980816.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	local g=Duel.GetMatchingGroup(c9980816.spfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local b1=g:CheckSubGroup(c9980816.fselect1,1,ft,tp)
	local b2=g:CheckSubGroup(c9980816.fselect2,1,ft,tp)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and (b1 or b2) end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9980816,0),aux.Stringid(9980816,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9980816,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9980816,1))+1
	end
	e:SetLabel(op)
	local sg=nil
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c9980816.fselect1,false,1,ft,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c9980816.fselect2,false,1,ft,tp)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c9980816.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980816.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9980816.spfilter2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if op==0 then
			local e3=e1:Clone()
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e3:SetValue(LOCATION_DECKBOT)
			tc:RegisterEffect(e3,true)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	if op==0 then
		local tg=Duel.GetMatchingGroup(c9980816.synfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,rg:GetFirst(),nil,og,og:GetCount()-1,og:GetCount()-1)
		end
	else
		local tg=Duel.GetMatchingGroup(c9980816.xyzfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,rg:GetFirst(),og,og:GetCount(),og:GetCount())
		end
	end
end
