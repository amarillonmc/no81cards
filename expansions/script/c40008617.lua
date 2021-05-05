--传说究极异兽-黑暗之奈克洛兹玛
function c40008617.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,11,5,c40008617.ovfilter,aux.Stringid(40008617,0),5,c40008617.xyzop)
	c:EnableReviveLimit()  
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008617,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c40008617.sptg1)
	e1:SetOperation(c40008617.spop1)
	c:RegisterEffect(e1)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c40008617.spcost)
	e3:SetTarget(c40008617.sptg)
	e3:SetOperation(c40008617.spop)
	c:RegisterEffect(e3)
end
function c40008617.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(10) and c:GetOverlayCount()>1
end
function c40008617.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008617)==0 end
	Duel.RegisterFlagEffect(tp,40008617,RESET_PHASE+PHASE_END,0,1)
end
function c40008617.spfilter1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c40008617.spfilter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function c40008617.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local res=Duel.IsExistingMatchingCard(c40008617.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c40008617.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40008617.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(c40008617.spfilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c40008617.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c40008617.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c40008617.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetFlagEffect(tp,40008617)==0 end
	Duel.RegisterFlagEffect(tp,40008617,RESET_CHAIN,0,1)
end
function c40008617.spfilter(c,g,tp)
	return (c:IsCode(40008618) or c:IsCode(40008619)) and c:IsFaceup() and c:IsCanBeXyzMaterial(g) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c40008617.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008617.spfilter,tp,LOCATION_ONFIELD,0,1,nil,e:GetHandler(),tp) 
	 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
	 Duel.ConfirmCards(tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c40008617.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) 
end
function c40008617.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then return end
   local g=Duel.SelectMatchingCard(tp,c40008617.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e:GetHandler(),tp)
   local t=g:GetFirst()
   if t  and not t:IsImmuneToEffect(e) then
		local mg=t:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(e:GetHandler(),mg)
		end
		e:GetHandler():SetMaterial(Group.FromCards(t))
		Duel.Overlay(e:GetHandler(),Group.FromCards(t))
		Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		e:GetHandler():CompleteProcedure()
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40008617,3))
			local tg=Duel.SelectMatchingCard(tp,c40008617.xyzfilter,tp,LOCATION_GRAVE,0,10,10,nil)
			Duel.Overlay(c,tg)
		end
end
end