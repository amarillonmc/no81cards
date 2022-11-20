--喜剧小丑的副手
function c10173053.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173053,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,10173053)
	e1:SetTarget(c10173053.sptg)
	e1:SetOperation(c10173053.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173053,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,10173153)
	e3:SetTarget(c10173053.thtg)
	e3:SetOperation(c10173053.thop)
	c:RegisterEffect(e3)
end
function c10173053.thfilter(c)
	return c:IsSetCard(0xa332) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10173053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173053.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10173053.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10173053.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10173053.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c10173053.spfilter(c,e,tp,g,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and g:IsExists(c10173053.spfilter2,1,nil,c,chkf,e:GetHandler())
end
function c10173053.spfilter2(c,fusc,chkf,rc)
	return fusc:CheckFusionMaterial(Group.FromCards(c,rc),c,chkf)
end
function c10173053.cfilter(c,tp,e)
	return c:IsControler(tp) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c10173053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=eg:Filter(Card.IsControler,nil,tp)
		if g:GetCount()==0 then return false end
		local chkf=tp
		local res=Duel.IsExistingMatchingCard(c10173053.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10173053.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,mf,chkf)
			end
		end
		return res
	end
	local g=eg:Filter(Card.IsControler,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10173053.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c10173053.cfilter,nil,tp,e)
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or g:GetCount()<=0 then return end
	local chkf=tp
	local sg1=Duel.GetMatchingGroup(c10173053.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,g,nil,chkf)
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10173053.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,g,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local ec=g:FilterSelect(tp,c10173053.spfilter2,1,1,nil,tc,chkf,c):GetFirst()
		local mat1=Group.FromCards(c,ec)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat1)
		end
		tc:CompleteProcedure()
	end
end