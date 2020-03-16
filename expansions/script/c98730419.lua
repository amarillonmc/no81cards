function c98730419.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98730419,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98731419)
	e1:SetCost(c98730419.shcost)
	e1:SetTarget(c98730419.shtg)
	e1:SetOperation(c98730419.shop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98731419)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98730419.tgtg)
	e2:SetOperation(c98730419.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,98731419)
	e3:SetCost(c98730419.rmcost)
	e3:SetTarget(c98730419.rmtg)
	e3:SetOperation(c98730419.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetCondition(c98730419.discon)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(c98730419.disable)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,98730419)
	e5:SetTarget(c98730419.sptg)
	e5:SetOperation(c98730419.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetValue(aux.TRUE)
	e6:SetTarget(c98730419.reptg)
	c:RegisterEffect(e6)
end
function c98730419.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98730419.shfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c98730419.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98730419.shfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c98730419.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98730419.shfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98730419.tgfilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_EARTH)) and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function c98730419.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98730419.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c98730419.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98730419.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c98730419.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,nil,REASON_COST)
end
function c98730419.rmfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_RITUAL) and c:IsAbleToRemove()
end
function c98730419.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98730419.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c98730419.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98730419.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c98730419.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 and Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_PZONE,0,1,e:GetHandler(),ATTRIBUTE_EARTH)
end
function c98730419.disable(e,c)
	return not (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_EARTH))
end
function c98730419.filter(c,e,tp,m,ft)
	if not (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_EARTH)) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return ft>-1 and mg:IsExists(c98730419.mfilterf,1,nil,tp,mg,c)
	end
end
function c98730419.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function c98730419.matfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_RITUAL) and c:IsReleasableByEffect()
end
function c98730419.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c98730419.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c98730419.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c98730419.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c98730419.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg=Duel.GetMatchingGroup(c98730419.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectMatchingCard(tp,c98730419.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	local tc=g:GetFirst()
	if tc==nil then return end
	mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
	local mat=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:FilterSelect(tp,c98730419.mfilterf,1,1,nil,tp,mg,tc)
		Duel.SetSelectedCard(mat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
		mat:Merge(mat2)
	end
	tc:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
	mg:RemoveCard(tc)
	if Duel.IsExistingMatchingCard(c98730419.scfilter,tp,LOCATION_PZONE,0,1,e:GetHandler()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		mg=Duel.GetMatchingGroup(c98730419.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsExistingMatchingCard(c98730419.filter,tp,LOCATION_DECK,0,1,nil,e,tp,mg,ft) and Duel.SelectYesNo(tp,aux.Stringid(98730419,1)) then
			g=Duel.SelectMatchingCard(tp,c98730419.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg,ft)
			tc=g:GetFirst()
			if tc then
				mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				mat=nil
				if ft>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					mat=mg:FilterSelect(tp,c98730419.mfilterf,1,1,nil,tp,mg,tc)
					Duel.SetSelectedCard(mat)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
					mat:Merge(mat2)
				end
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
				mg:RemoveCard(tc)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		mg=Duel.GetMatchingGroup(c98730419.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsExistingMatchingCard(c98730419.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg,ft) and Duel.SelectYesNo(tp,aux.Stringid(98730419,2)) then
			g=Duel.SelectMatchingCard(tp,c98730419.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg,ft)
			tc=g:GetFirst()
			if tc then
				mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				mat=nil
				if ft>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					mat=mg:FilterSelect(tp,c98730419.mfilterf,1,1,nil,tp,mg,tc)
					Duel.SetSelectedCard(mat)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
					mat:Merge(mat2)
				end
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
				mg:RemoveCard(tc)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		mg=Duel.GetMatchingGroup(c98730419.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsExistingMatchingCard(c98730419.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp,mg,ft) and Duel.SelectYesNo(tp,aux.Stringid(98730419,3)) then
			g=Duel.SelectMatchingCard(tp,c98730419.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,mg,ft)
			tc=g:GetFirst()
			if tc then
				mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				mat=nil
				if ft>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					mat=mg:FilterSelect(tp,c98730419.mfilterf,1,1,nil,tp,mg,tc)
					Duel.SetSelectedCard(mat)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
					mat:Merge(mat2)
				end
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
				mg:RemoveCard(tc)
			end
		end
	end
end
function c98730419.repfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_RITUAL)
end
function c98730419.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsSummonType(SUMMON_TYPE_RITUAL) and Duel.IsExistingMatchingCard(c98730419.repfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp,tp,c)>0 end
	if Duel.SelectYesNo(tp,aux.Stringid(98730419,4)) then
		if Duel.SendtoDeck(c,nil,nil,REASON_EFFECT)~=1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98730419.repfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,nil,tp,tp,false,false,POS_FACEUP)
		end
		return true
	end
	return false
end