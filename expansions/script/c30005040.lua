--异神 格
local m=30005040
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e0=Effect.CreateEffect(c)
	--e0:SetDescription(aux.Stringid(m,1))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,m)
	e0:SetTarget(cm.target)
	e0:SetOperation(cm.operation)
	c:RegisterEffect(e0)
	--ritual oblation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(cm.rlevel)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e2:SetValue(cm.mtval)
	c:RegisterEffect(e2)
	--ritual summon garve
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.rtg)
	e3:SetOperation(cm.rtop)
	c:RegisterEffect(e3)
end
--ritual summon
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,c,c)
		local ft=Duel.GetMZoneCount(tp)
		if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
		if ft>0 then
			return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
		else
			return mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetMZoneCount(tp)
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		Duel.BreakEffect()
		if tc:IsOnField() and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
			local mg=Duel.GetRitualMaterial(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND,0,1,1,nil,nil,e,tp,mg,mg2,Card.GetLevel,"Greater")
			local tc1=tg:GetFirst()
			if tc1 then
				mg=mg:Filter(Card.IsCanBeRitualMaterial,tc1,tc1)
			if tc1.mat_filter then
				mg=mg:Filter(tc1.mat_filter,tc1,tp)
			else
				mg:RemoveCard(tc1)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc1,tc1:GetLevel(),"Greater")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc1:GetLevel(),tp,tc1,tc1:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat or mat:GetCount()==0 then return end
			tc1:SetMaterial(mat) 
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc1,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc1:CompleteProcedure()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e1)
			end 
		end
	end
end
--ritual oblation
function cm.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsType(TYPE_RITUAL) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function cm.mtval(e,c)
	return c:IsType(TYPE_RITUAL)
end
--ritual summon garve
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)  
		return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,nil,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,nil,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat) 
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end   
end