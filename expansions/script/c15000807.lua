local m=15000807
local cm=_G["c"..m]
cm.name="在漆黑的尽头守望希冀"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000798)
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.RitualUltimateTarget(aux.FilterBoolFunction(Card.IsCode,15000798),Card.GetOriginalLevel,"Greater",LOCATION_HAND,cm.tdfilter,cm.rfilter))
	e1:SetOperation(cm.RitualUltimateOperation(aux.FilterBoolFunction(Card.IsCode,15000798),Card.GetOriginalLevel,"Greater",LOCATION_HAND,cm.tdfilter,cm.rfilter))
	c:RegisterEffect(e1)
end
function cm.tdfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.rfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER)
end
function cm.RitualExtraFilter(c,f)
	return c:GetLevel()>0 and f(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.RitualUltimateTarget(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp,true) end
					local exg=nil
					if grave_filter then
						exg=Duel.GetMatchingGroup(cm.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
					end
					return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,summon_location,0,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal,true)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
				if grave_filter then
					Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
				end
			end
end
function cm.RitualUltimateOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp)
				if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp) end
				local exg=nil
				if grave_filter then
					exg=Duel.GetMatchingGroup(cm.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,summon_location,0,1,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal)
				local tc=tg:GetFirst()
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					if exg then
						mg:Merge(exg)
					end
					if tc.mat_filter then
						mg=mg:Filter(tc.mat_filter,tc,tp)
					else
						mg:RemoveCard(tc)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local lv=level_function(tc)
					aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,greater_or_equal)
					local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,tc,lv,greater_or_equal)
					aux.GCheckAdditional=nil
					tc:SetMaterial(mat)
					local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
					mat:Sub(mat2)
					Duel.ConfirmCards(1-tp,mat2)
					Duel.ReleaseRitualMaterial(mat)
					Duel.SendtoDeck(mat2,nil,1,REASON_EFFECT+REASON_MATERIAL)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
					Duel.ShuffleDeck(tp)
				end
			end
end