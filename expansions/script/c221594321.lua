--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=aux.AddRitualProcUltimate(c,aux.FilterBoolFunction(Card.IsSetCard,0xc97),Card.GetLevel,"Greater",LOCATION_HAND+LOCATION_GRAVE,aux.FilterBoolFunction(aux.AND(Card.IsFaceup,Card.IsSetCard),0xc97),cid.mfilter)
	e1:SetOperation(cid.RitualUltimateOperation(aux.FilterBoolFunction(Card.IsSetCard,0xc97),Card.GetLevel,"Greater",LOCATION_HAND+LOCATION_GRAVE,aux.FilterBoolFunction(aux.AND(Card.IsFaceup,Card.IsSetCard),0xc97),cid.mfilter))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(2,id)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCondition(function(e,tp,eg,ep,ev,re) return re and re:GetHandler():IsSetCard(0xc97) and e:GetHandler():IsReason(REASON_EFFECT) end)
	e2:SetCost(cid.cost)
	e2:SetTarget(cid.tg)
	e2:SetOperation(cid.op)
	c:RegisterEffect(e2)
end
function cid.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)
end
function cid.RitualUltimateOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsOnField,nil)
				if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp) end
				local exg=nil
				if grave_filter then
					exg=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_REMOVED,0,nil,grave_filter)
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
					Duel.SendtoGrave(mat:Filter(Card.IsLocation,nil,LOCATION_REMOVED),REASON_RETURN+REASON_MATERIAL+REASON_RITUAL+REASON_EFFECT)
					Duel.ReleaseRitualMaterial(mat:Filter(Card.IsOnField,nil))
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Damage(tp,500,REASON_COST)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
