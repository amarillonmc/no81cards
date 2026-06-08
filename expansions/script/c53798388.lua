local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.lv_func(c)
	return 8
end
function s.rit_filter(c,e,tp)
	return c:IsCode(id+4)
end
function s.deck_mat_filter(c,attr)
	return c:GetLevel()>0 and c:IsAttribute(attr) and c:IsReleasable(REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL)
end
function s.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)<=1
end
function s.rgcheck(g,ec)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)<=1
end
function s.check_attr(tp,attr,e)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(s.deck_mat_filter,tp,LOCATION_DECK,0,nil,attr)
	aux.RCheckAdditional=s.rcheck
	aux.RGCheckAdditional=s.rgcheck
	local res=Duel.IsExistingMatchingCard(s.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,s.rit_filter,e,tp,mg1,mg2,s.lv_func,"Greater")
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	return res
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local attr_list={ATTRIBUTE_EARTH,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_WIND,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_DIVINE}
		for _,attr in ipairs(attr_list) do
			if s.check_attr(tp,attr,e) then return true end
		end
		return false
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local attr=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(attr)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
end
function s.thsp_filter(c,e,tp,attr)
	if not c:IsAttribute(attr) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local attr=e:GetLabel()
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(s.deck_mat_filter,tp,LOCATION_DECK,0,nil,attr)
	aux.RCheckAdditional=s.rcheck
	aux.RGCheckAdditional=s.rgcheck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,s.rit_filter,e,tp,mg1,mg2,s.lv_func,"Greater")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,8,"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,8,tp,tc,8,"Greater")
		aux.GCheckAdditional=nil
		if not mat then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
			tc:CompleteProcedure()
			
			local b1=true
			local b2=Duel.IsExistingMatchingCard(s.thsp_filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,attr)
			local op=0
			if b2 then
				op=aux.SelectFromOptions(1-tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
			else
				op=aux.SelectFromOptions(1-tp,{b1,aux.Stringid(id,1)})
			end
			
			if op==1 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetTargetRange(1,1)
				e1:SetLabel(attr)
				e1:SetValue(s.aclimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1,true)
			elseif op==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thsp_filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,attr)
				local sc=sg:GetFirst()
				if sc then
					local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
					if sc:IsAbleToHand() and (not sc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
						Duel.SendtoHand(sc,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,sc)
					else
						Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
					end
				end
			end
		end
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
function s.aclimit(e,re,tp)
	return not re:GetHandler():IsAttribute(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function s.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetOriginalType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
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
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end