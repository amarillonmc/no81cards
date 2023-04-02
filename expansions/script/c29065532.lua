--方舟骑士源石秘仪
local m=29065532
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--toextra
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)  
end
function cm.mfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsLevelAbove(2)
end
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and not c:IsType(TYPE_TOKEN) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),c)
	else return false end
end
function cm.lvfun(c,rc)
	if c:GetRitualLevel(rc)>0 and not c:IsType(TYPE_TOKEN) then
		return c:GetRitualLevel(rc)
	else
		return c:GetLevel()-1
	end
end
function cm.extra(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
end
function cm.check(c,e)
	local flag = true
	if e then
		flag = not c:IsImmuneToEffect(e)
	end
	return not c:IsType(TYPE_TOKEN) and flag
end
function cm.dfilter(c)
	return c:IsReleasable() and c:GetOriginalLevel()>0
end
function cm.filter(c,e,tp)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsRace(RACE_SPELLCASTER)
end
function cm.gfilter(g,c)
	local rg = g:Filter(cm.check,nil)
	local lv=0
	local lv2 = 0
	if rg:GetCount()>0 then
		lv = rg:GetSum(Card.GetRitualLevel,c)
		_flag,lv2 = rg:GetMinGroup(Card.GetRitualLevel,c)
	end
	return Duel.GetMZoneCount(c:GetControler(),g)>0 and g:CheckWithSumGreater(cm.lvfun,c:GetLevel(),c) and ((g:FilterCount(cm.mfilter,nil)+lv) <=c:GetLevel() or (rg:CheckWithSumGreater(cm.lvfun,c:GetLevel(),c) and (rg:GetSum(Card.GetRitualLevel,c) - lv2)<c:GetLevel() and g:FilterCount(cm.mfilter,nil)==0))
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if (bit.band(c:GetType(),0x81)~=0x81) or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	local res=mg:CheckSubGroup(cm.gfilter,1,#mg,c)
	return res
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ft=Duel.GetMZoneCount(tp)
		local mg=Duel.GetRitualMaterial(tp):Filter(cm.check,nil)
		local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,e:GetHandler())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	local dm=Duel.GetRitualMaterial(tp):Filter(cm.check,nil,e)
	local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil,tp,c)
	local tg=Duel.SelectMatchingCard(tp,cm.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler(),cm.filter,e,tp,dm,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=dm:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,cm.gfilter,false,1,#mg,tc)
		tc:SetMaterial(mat)
		local rls = mat:Filter(cm.check,nil,e)
		local token = Group.__sub(mat,rls)
		local level = tc:GetLevel() - rls:GetSum(Card.GetRitualLevel,tc)
		if rls:GetCount()>0 then
			Duel.ReleaseRitualMaterial(rls)
		end
		Duel.AdjustAll()
		if token:GetCount()>0 then
			local finish = false
			while not finish do
				local tc = token:FilterSelect(tp,cm.filterdo,1,1,nil,level,token):GetFirst()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(-1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1) 
				tc:RegisterFlagEffect(m,0,0,0)
				level = level - 1
				finish = level == 0
				if finish then
					for dc in aux.Next(token) do
						dc:ResetFlagEffect(m)
					end
				end
				Duel.AdjustAll()
			end
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.flagcheck(c)
	return c:GetFlagEffect(m)<=0
end
function cm.filterdo(c,lv,g)
	return g:FilterCount(cm.flagcheck,c)<lv and c:IsLevelAbove(2)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(cm.lvcheckc,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.lvcheckc(c)
	return c:IsType(TYPE_TOKEN) and c:IsLevelAbove(5)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local sg=Duel.SelectMatchingCard(tp,cm.lvcheckc,tp,LOCATION_MZONE,0,1,1,nil)
		if sg:GetCount()>0 then
			local tc = sg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-4)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1) 
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		end
	end
end