--辉石再诞
local s, id = GetID()

function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920940,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98920940)
	e2:SetTarget(c98920940.target)
	e2:SetOperation(c98920940.operation)
	c:RegisterEffect(e2)
		--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetOperation(c98920940.desop)
	c:RegisterEffect(e3)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920940,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,98930940)
	e1:SetTarget(c98920940.atktg)
	e1:SetOperation(c98920940.atkop)
	c:RegisterEffect(e1)
end
function s.filter1(c,e)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1047) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsType,1,nil,TYPE_FUSION)
end
function c98920940.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
		aux.FCheckAdditional=s.fcheck
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		aux.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98920940.operation(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter1),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	aux.FCheckAdditional=s.fcheck
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		::cancel::
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			if #mat==0 then goto cancel end
			tc:SetMaterial(mat)
			if mat:IsExists(Card.IsFacedown,1,nil) then
				local cg=mat:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(1-tp,cg)
			end
			if mat:Filter(s.cfilter,nil):GetCount()>0 then
				local cg=mat:Filter(s.cfilter,nil)
				Duel.HintSelection(cg)
			end
			Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			if #mat2==0 then goto cancel end
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		e:GetHandler():SetCardTarget(tc)
	end
	aux.FCheckAdditional=nil
end
function c98920940.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())
end
function s.sfilter(c)
	return c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function s.ssfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAttackAbove(1550)
end
function c98920940.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(s.ssfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.ssfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c98920940.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1550)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg==0 then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end