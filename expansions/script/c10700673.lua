--孽驱君主 别西卜
function c10700673.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--ritual summon activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(10700673,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCost(c10700673.cost)
	e0:SetTarget(c10700673.target)
	e0:SetOperation(c10700673.activate)
	c:RegisterEffect(e0) 
	--Extra Effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1,10700673)
	e1:SetCondition(c10700673.excon)
	e1:SetOperation(c10700673.exop)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700673,5))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,10700674)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c10700673.spcost)
	e2:SetTarget(c10700673.sptg)
	e2:SetOperation(c10700673.spop)
	c:RegisterEffect(e2)  
end
function c10700673.rrfilter(c)
	return c:IsType(TYPE_RITUAL) and (c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_WIND))
end
function c10700673.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	if Duel.SendtoExtraP(e:GetHandler(),nil,REASON_COST)>0 and not Duel.IsExistingMatchingCard(c10700673.rrfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(c10700673.rrfilter,tp,LOCATION_HAND,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10700673.rrfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	end
end
function c10700673.dfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsLevelAbove(1) 
end
function c10700673.filter(c,e,tp)
	return c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_FIRE)
end
function c10700673.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700673.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700673.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local dg=Duel.GetMatchingGroup(c10700673.dfilter,tp,LOCATION_EXTRA,0,nil)
		aux.RCheckAdditional=c10700673.rcheck
		aux.RGCheckAdditional=c10700673.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c10700673.filter,e,tp,mg,dg,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c10700673.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(c10700673.dfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c10700673.rcheck
	aux.RGCheckAdditional=c10700673.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c10700673.filter,e,tp,m,dg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(dg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700673,1))
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		if mat:GetCount()>0 then
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
function c10700673.excon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c10700673.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(10700673)==0 then
			--remove
			local e1=Effect.CreateEffect(rc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0xfe,0xff)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetTarget(c10700673.rmtg)
			rc:RegisterEffect(e1,true)
			--damage
			local e2=Effect.CreateEffect(rc)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_REMOVE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c10700673.operation)
			rc:RegisterEffect(e2,true)
			if not rc:IsType(TYPE_EFFECT) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_ADD_TYPE)
				e3:SetValue(TYPE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e3,true)
			end
			rc:RegisterFlagEffect(10700673,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10700673,2))
		end
		rc=eg:GetNext()
	end
end
function c10700673.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c10700673.dafilter1(c,tp)
	return c:GetOwner()==1-tp
end
function c10700673.dafilter2(c,tp)
	return c:GetOwner()==tp
end
function c10700673.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(c10700673.dafilter1,nil,tp)*300
	local d2=eg:FilterCount(c10700673.dafilter2,nil,tp)*300
	Duel.Damage(1-tp,d1,REASON_EFFECT,true)
	Duel.Damage(1-tp,d2,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c10700673.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10700673.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c10700673.spfilter(c,e,tp,lv)
	local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if c:IsLocation(LOCATION_EXTRA) then res=Duel.GetLocationCountFromEx(tp)>0 end
	return res and c:IsType(TYPE_RITUAL) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c10700673.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(c10700673.cfilter,tp,LOCATION_GRAVE,0,nil)
		return c:IsAbleToRemoveAsCost()
			and Duel.IsExistingMatchingCard(c10700673.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,cg:GetCount())
	end
	local cg=Duel.GetMatchingGroup(c10700673.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c10700673.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp,cg:GetCount())
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
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700673,3))
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
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c10700673.sfilter(c,e,tp,lv)
	return c:IsType(TYPE_RITUAL) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c10700673.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10700673.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
	  Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	  tc:CompleteProcedure()
	end
end