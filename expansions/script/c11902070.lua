--十七驱 谷风
local s,id,o=GetID()
function s.initial_effect(c)
    --ReGrave(0x20)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(0x06)
	e1:SetCountLimit(1,id)
    e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	    if chk==0 then return e:GetHandler():IsReleasable() end
	    Duel.Release(e:GetHandler(),REASON_COST) end)
	e1:SetTarget(s.rgtg)
	e1:SetOperation(s.rgop)
	c:RegisterEffect(e1)
    --spsummon
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,id+1)
    e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) end)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.rgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x20) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0x20,0x20,1,nil,TYPE_MONSTER) end
	Duel.Hint(3,tp,504)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0x20,0x20,1,1,nil,TYPE_MONSTER)
end
function s.rgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,nil,REASON_EFFECT+REASON_RETURN)
	end
end
function s.ckfil(c,tp) 
	return c:IsControler(tp) and c:IsFaceup()
        and c:IsSetCard(0x340b) and c:IsLevelBelow(4)
end 
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ckfil,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.filter1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x340b) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then 
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,0x40,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,0x40,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		if res and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            s.fusion(e,tp,eg,ep,ev,re,r,rp)
        end
	end
end
function s.fusion(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,0x40,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,0x40,0,nil,e,tp,mg2,mf,c,chkf)
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