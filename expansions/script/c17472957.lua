--解放合并
function c17472957.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(17472957,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_RELEASE) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,17472957)  
	e1:SetTarget(c17472957.actg1)
	e1:SetOperation(c17472957.acop1)
	c:RegisterEffect(e1)	
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(17472957,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,17472957)  
	e1:SetTarget(c17472957.actg2)
	e1:SetOperation(c17472957.acop2)
	c:RegisterEffect(e1)   
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17472957,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,17472957)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c17472957.spcost)
	e2:SetTarget(c17472957.sptg)
	e2:SetOperation(c17472957.spop)
	c:RegisterEffect(e2)
end 
function c17472957.mgfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_MZONE)
end 
function c17472957.spfil(c,e,tp,mg) 
	local tc=mg:GetFirst() 
	while tc do 
	if not c:CheckFusionMaterial(mg,tc,chkf) then 
		return false 
	end 
	tc=mg:GetNext() 
	end   
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0   
end
function c17472957.actg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	local mg=eg:Filter(c17472957.mgfil,nil)
	if chk==0 then return mg:GetCount()>0 and Duel.IsExistingMatchingCard(c17472957.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c17472957.acop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local mg=eg:Filter(c17472957.mgfil,nil) 
	if Duel.IsExistingMatchingCard(c17472957.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,tp) then 
		local sc=Duel.SelectMatchingCard(tp,c17472957.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst()
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end 
end   
function c17472957.actg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local mg=eg:Filter(c17472957.mgfil,nil):Filter(Card.IsReason,nil,REASON_EFFECT)
	if chk==0 then return mg:GetCount()>0 and Duel.IsExistingMatchingCard(c17472957.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c17472957.acop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local mg=eg:Filter(c17472957.mgfil,nil):Filter(Card.IsReason,nil,REASON_EFFECT) 
	if Duel.IsExistingMatchingCard(c17472957.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,tp) then 
		local sc=Duel.SelectMatchingCard(tp,c17472957.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst()
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end 
end  
function c17472957.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c17472957.cfilter(c)
	return (c:IsSetCard(0x46) or c:IsType(TYPE_FUSION)) and c:IsAbleToRemoveAsCost()
end
function c17472957.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end
function c17472957.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(c17472957.cfilter,tp,LOCATION_GRAVE,0,nil)
		return c:IsAbleToRemoveAsCost()
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c17472957.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,cg:GetCount())
	end
	local cg=Duel.GetMatchingGroup(c17472957.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c17472957.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,cg:GetCount())
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17472957,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg1=Group.CreateGroup()
	if lv>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=cg:Select(tp,lv-1,lv-1,c)
		rg1:Merge(rg2)
	end
	rg1:AddCard(c)
	Duel.Remove(rg1,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c17472957.sfilter(c,e,tp,lv)
	return c:IsType(TYPE_FUSION) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17472957.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17472957.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(17472957,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c17472957.descon)
		e1:SetOperation(c17472957.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c17472957.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(17472957)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c17472957.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end







