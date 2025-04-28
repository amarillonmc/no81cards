--半龙女仆·回廊龙女
local m=11561061
local cm=_G["c"..m]
function cm.initial_effect(c)
	--seach
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11561061)
	e1:SetTarget(c11561061.rhtg)
	e1:SetOperation(c11561061.rhop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11561061,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11560061)
	e3:SetTarget(c11561061.sptg)
	e3:SetOperation(c11561061.spop)
	c:RegisterEffect(e3)
	
end
function c11561061.rhfilter(c,e,tp)
	return c:IsSetCard(0x133) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c11561061.filter0(c)
	return c:IsOnField() and c:IsAbleToHand()
end
function c11561061.filter1(c,e)
	return c:IsOnField() and c:IsAbleToHand() and not c:IsImmuneToEffect(e)
end
function c11561061.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_DRAGON) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c11561061.disfilter(c)
	return c:IsDiscardable() and (c:IsSetCard(0x133) or c:IsRace(RACE_DRAGON))
end
function c11561061.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11561061.rhfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c11561061.filter0,nil)
	local b2=Duel.IsExistingMatchingCard(c11561061.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not b2 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			b2=Duel.IsExistingMatchingCard(c11561061.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
	if chk==0 then return b1 or b2 end
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11561061.rhop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c11561061.rhfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c11561061.filter0,nil)
	local b2=Duel.IsExistingMatchingCard(c11561061.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not b2 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			b2=Duel.IsExistingMatchingCard(c11561061.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(11561061,0)},
		{b2,aux.Stringid(11561061,1)})
	if op==1 then
		c11561061.spop2(e,tp,eg,ep,ev,re,r,rp)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c11561061.filter0,nil)
		local b2=Duel.IsExistingMatchingCard(c11561061.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not b2 then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				b2=Duel.IsExistingMatchingCard(c11561061.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		if Duel.IsExistingMatchingCard(c11561061.disfilter,tp,LOCATION_HAND,0,1,nil) and b2 and Duel.SelectYesNo(tp,aux.Stringid(11561061,2)) then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,c11561061.disfilter,1,1,REASON_EFFECT+REASON_DISCARD)
			c11561061.fsop(e,tp,eg,ep,ev,re,r,rp)
		end
	else
		c11561061.fsop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsExistingMatchingCard(c11561061.disfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c11561061.rhfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11561061,2)) then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,c11561061.disfilter,1,1,REASON_EFFECT+REASON_DISCARD)
			c11561061.spop2(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function c11561061.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c11561061.rhfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11561061.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c11561061.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c11561061.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c11561061.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoHand(mat1,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
















function c11561061.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetOperation(c11561061.thop2)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE_START)
	Duel.RegisterEffect(e1,tp)
end
function c11561061.thfilter1(c)
	return c:IsSetCard(0x133) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function c11561061.tgcfilter(c)
	return c:IsSetCard(0x133) and c:IsLevelBelow(4) and c:IsFaceup()
end
function c11561061.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tgc=Duel.GetMatchingGroupCount(c11561061.tgcfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.GetMatchingGroupCount(c11561061.thfilter1,tp,LOCATION_DECK,0,nil)>=tgc then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11561061.thfilter1,tp,LOCATION_DECK,0,tgc,tgc,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local ug=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,tgc-1,tgc-1,nil)
			if #ug>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(ug,REASON_EFFECT)
			end
	end
	end
end
function c11561061.spfilter(c,e,tp)
	return c:IsSetCard(0x133) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11561061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c11561061.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c11561061.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11561061.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end