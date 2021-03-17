local m=90700062
local cm=_G["c"..m]
cm.name="阿尔忒弥斯的降诞"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(m)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(0x1ff)
	e4:SetOperation(cm.op)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+90700061)
	c:RegisterEffect(e4)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	_G["aux"].RitualUltimateTarget=function(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),90700062) and bit.band(summon_location,LOCATION_HAND) and bit.band(summon_location,LOCATION_GRAVE)==0 then
			summon_location=summon_location+LOCATION_GRAVE 
		end
		if Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),90700064) and bit.band(summon_location,LOCATION_HAND) and bit.band(summon_location,LOCATION_REMOVED)==0 then
			summon_location=summon_location+LOCATION_REMOVED 
		end
		if chk==0 then
			local mg=Duel.GetRitualMaterial(tp)
			if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp,true) end
			local exg=nil
			if grave_filter then
				exg=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
			end
			return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,summon_location,0,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal,true)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
		if grave_filter then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
		end
	end
	end
	_G["aux"].RitualUltimateOperation=function(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),90700062) and bit.band(summon_location,LOCATION_HAND) and bit.band(summon_location,LOCATION_GRAVE)==0 then
			summon_location=summon_location+LOCATION_GRAVE 
		end
		if Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),90700064) and bit.band(summon_location,LOCATION_HAND) and bit.band(summon_location,LOCATION_REMOVED)==0 then
			summon_location=summon_location+LOCATION_REMOVED 
		end
		local mg=Duel.GetRitualMaterial(tp)
		if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp) end
		local exg=nil
		if grave_filter then
			exg=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,summon_location,0,1,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal)
		local tc=tg:GetFirst()
		if tc then
			local is_can_use_self=false
			if tc:IsLocation(LOCATION_HAND) and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),90700062) then
				is_can_use_self=true
			end
			if tc:IsLocation(LOCATION_GRAVE) and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),90700064) then
				is_can_use_self=true
			end
			mg=mg:Filter(Card.IsCanBeRitualMaterial,nil,tc)
			if exg then
				mg:Merge(exg)
			end
			if tc.mat_filter then
				if not is_can_use_self then
					mg=mg:Filter(tc.mat_filter,tc,tp)
				else
					mg=mg:Filter(tc.mat_filter,nil,tp)
				end
			elseif not is_can_use_self then
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local lv=level_function(tc)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,greater_or_equal)
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,tc,lv,greater_or_equal)
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
	end
	_G["aux"].RitualUltimateFilter=function(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
		local is_can_use_self=false
		if c:IsLocation(LOCATION_HAND) and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),90700062) then
			is_can_use_self=true
		end
		if c:IsLocation(LOCATION_GRAVE) and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),90700064) then
			is_can_use_self=true
		end
		if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
		local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
		if m2 then
			mg:Merge(m2)
		end
		if c.mat_filter then
			if not is_can_use_self then
				mg=mg:Filter(c.mat_filter,c,tp)
			else
				mg=mg:Filter(c.mat_filter,nil,tp)
			end
		elseif not is_can_use_self then
			mg:RemoveCard(c)
		end
		local lv=level_function(c)
		aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
		local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
		aux.GCheckAdditional=nil
		return res
	end
	local all_cards=Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)
	all_cards:ForEach(cm.enum)
end
function cm.enum(c)
	Card.ReplaceEffect(c,90700060,RESET_EVENT,1)
	if not c:IsType(TYPE_NORMAL) then
		_G["c"..c:GetCode()].initial_effect(c)
	end
end
function cm.thfilter(c)
	return c:IsCode(90700063) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local c=g:GetFirst()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end