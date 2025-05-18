--艾奇军团 泄欲者
function c60151109.initial_effect(c)
	--xyzlv
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c60151109.xyzlv)
	c:RegisterEffect(e0)
	
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151109,5))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c60151109.ntcon)
	c:RegisterEffect(e1)
	
	--2xg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151109,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,60151109)
	e2:SetCost(c60151109.e1cost)
	e2:SetTarget(c60151109.e1tg)
	e2:SetOperation(c60151109.e1op)
	c:RegisterEffect(e2)


	--2xg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151109,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,6011109)
	e3:SetCondition(c60151109.spcon)
	e3:SetTarget(c60151109.sptg)
	e3:SetOperation(c60151109.spop)
	c:RegisterEffect(e3)
end

c60151109.toss_coin=true
function c60151109.xyzlv(e,c,rc)
	return 0x40000+e:GetHandler():GetLevel()
end
function c60151109.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c60151109.e1costf(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c60151109.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151109.e1costf,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c60151109.e1costf,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c60151109.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151109.chlimit)
		Duel.RegisterFlagEffect(tp,60151109,RESET_CHAIN,0,1)
	else
		e:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE+CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c60151109.chlimit(e,ep,tp)
	return tp==ep
end
function c60151109.e1opf(c)
	return c:IsAbleToGrave()
end
function c60151109.e1opff(c)
	return c:IsLevelAbove(1)
end
function c60151109.e1opfff(c,e,tp)
	local scg=Duel.GetReleaseGroup(tp,true,REASON_EFFECT):Filter(c60151109.e1opff,c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x9b23) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
			and scg:CheckWithSumGreater(Card.GetLevel,c:GetLevel())
end
function c60151109.e1opsf(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60151109.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=0
	if Duel.GetFlagEffect(tp,60151109)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151109.e1opf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
	if res==1 then
		if e:GetHandler():IsRelateToEffect(e) then
			if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
				if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
				local g=Duel.GetMatchingGroup(c60151109.e1opsf,tp,LOCATION_GRAVE,0,nil)
				if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151109,6)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
					local sg=g:Select(tp,1,1,nil)
					Duel.SSet(tp,sg:GetFirst())
				end
			end
		end
	end
end

--2xg

function c60151109.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler()~=e:GetHandler()
end
function c60151109.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151109.spopf(c)
	return c:IsCanOverlay() and c:IsFaceup()
end
function c60151109.xyzfilter2(c,mg)
	return c:IsType(TYPE_XYZ) and mg:CheckSubGroup(c60151109.gselect,1,#mg,c)
end
function c60151109.gselect(sg,c)
	return sg:IsExists(Card.IsSetCard,1,nil,0x9b23) and c:IsXyzSummonable(sg,#sg,#sg)
end
function c60151109.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
			local mg=Duel.GetMatchingGroup(c60151109.spopf,tp,LOCATION_MZONE,0,nil)
			local exg=Duel.GetMatchingGroup(c60151109.xyzfilter2,tp,LOCATION_EXTRA,0,nil,mg)
			if exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151109,4)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=exg:Select(tp,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sg=mg:SelectSubGroup(tp,c60151109.gselect,false,1,mg:GetCount(),tg:GetFirst())
				Duel.XyzSummon(tp,tg:GetFirst(),sg,#sg,#sg)
			end
		end
	end
end