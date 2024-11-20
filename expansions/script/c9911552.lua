--开绽紫炎蔷薇的歌唱
function c9911552.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9911552)
	e1:SetTarget(c9911552.pstg)
	e1:SetOperation(c9911552.psop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9911553)
	e2:SetCondition(c9911552.descon)
	e2:SetTarget(c9911552.destg)
	e2:SetOperation(c9911552.desop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911554)
	e3:SetCondition(c9911552.spcon)
	e3:SetTarget(c9911552.sptg)
	e3:SetOperation(c9911552.spop)
	c:RegisterEffect(e3)
end
function c9911552.desfilter(c,check)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_PENDULUM>0
		and (check or (c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==0 or c:GetSequence()==4)))
end
function c9911552.psfilter(c)
	return c:IsSetCard(0x6952) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9911552.pstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9911552.desfilter(chkc,check) end
	if chk==0 then return Duel.IsExistingTarget(c9911552.desfilter,tp,LOCATION_ONFIELD,0,1,nil,check)
		and Duel.IsExistingMatchingCard(c9911552.psfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9911552.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9911552.tefilter(c,ls,rs)
	return c:IsType(TYPE_PENDULUM) and c:GetLevel()>ls and c:GetLevel()<rs
end
function c9911552.psop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9911552.psfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		local l,r=Duel.GetFieldCard(tp,LOCATION_PZONE,0),Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if not (l and r) then return end
		local ls,rs=l:GetCurrentScale(),r:GetCurrentScale()
		if ls>rs then ls,rs=rs,ls end
		if Duel.IsExistingMatchingCard(c9911552.tefilter,tp,LOCATION_DECK,0,1,nil,ls,rs)
			and Duel.SelectYesNo(tp,aux.Stringid(9911552,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911552,1))
			local sg=Duel.SelectMatchingCard(tp,c9911552.tefilter,tp,LOCATION_DECK,0,1,1,nil,ls,rs)
			Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
		end
	end
end
function c9911552.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()>1 and eg:IsContains(e:GetHandler())
end
function c9911552.cfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsCanBeEffectTarget(e)
end
function c9911552.fselect(g)
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	return math.abs(lv1-lv2)>1
end
function c9911552.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Filter(c9911552.cfilter,nil,e)
	if chk==0 then return #g>1 and g:CheckSubGroup(c9911552.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=g:SelectSubGroup(tp,c9911552.fselect,false,2,2)
	Duel.SetTargetCard(g1)
	local lv1=g1:GetFirst():GetLevel()
	local lv2=g1:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function c9911552.cfilter2(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c9911552.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9911552.cfilter2,nil,e)
	if #g~=2 then return end
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	if num<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,num,nil)
	if #g>0 then
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c9911552.filter0(c)
	return c:IsSetCard(0x6952) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c9911552.spcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:GetOriginalType()&TYPE_MONSTER>0 and tc:IsRelateToEffect(te)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingMatchingCard(c9911552.filter0,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,tc) then
			return true
		end
	end
	return false
end
function c9911552.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cate=0
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:GetOriginalType()&TYPE_MONSTER>0 and tc:IsRelateToEffect(te)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingMatchingCard(c9911552.filter0,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,tc)
			and tc:IsLocation(LOCATION_GRAVE) then
			cate=CATEGORY_GRAVE_SPSUMMON
		end
	end
	e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+cate)
end
function c9911552.filter1(c,e,tp)
	return c9911552.filter0(c) and (c:IsAbleToGrave() or c9911552.filter2(c,e,tp))
end
function c9911552.filter2(c,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local b1=c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (b1 or b2)
end
function c9911552.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:GetOriginalType()&TYPE_MONSTER>0 and tc:IsRelateToEffect(te) and not aux.NecroValleyNegateCheck(tc)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingMatchingCard(c9911552.filter0,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,tc) then
			g:AddCard(tc)
		end
	end
	if #g==0 then return end
	if g:IsExists(Card.IsFacedown,1,nil) then
		local cg=g:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(tp,cg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	local sc=sg:GetFirst()
	if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local rg=Duel.SelectMatchingCard(tp,c9911552.filter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=rg:GetFirst()
		if tc then
			if tc:IsAbleToGrave() and (not c9911552.filter2(tc,e,tp) or Duel.SelectOption(tp,1191,1152)==0) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			else
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	Duel.SpecialSummonComplete()
end
