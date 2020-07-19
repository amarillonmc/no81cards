--吞式者的伴兽
local m=14000323
local cm=_G["c"..m]
cm.named_with_Aotual=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
cm.fit_monster={14000324,14000325,14000326}
function cm.AOTU(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Aotual
end
function cm.filter(c,e,tp,m1,ft)
	if not cm.AOTU(c) or not (c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL))
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(cm.rmfilter,c,c)
	if ft>0 then
		return mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
	else
		return false
	end
end
function cm.rmfilter(c,rc)
	return c:IsCanBeRitualMaterial(rc) and not cm.AOTU(c)
end
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 or c:IsLocation(LOCATION_HAND)) then
		Duel.SetSelectedCard(c)
		return mg:IsExists(cm.rmfilter,1,nil,rc)
	else return false end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(function(c) return c:IsReleasable() and not cm.AOTU(c) end,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(function(c) return c:IsReleasable() and not cm.AOTU(c) end,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:Select(tp,1,1,nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,tc)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
			if not tc:IsCode(14000324,14000325,14000326) then return end
			if tc:IsCode(14000324) then
				b1=Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_ONFIELD,1,nil)
			else
				b1=false
			end
			if tc:IsCode(14000325) then
				b2=mat:GetFirst():IsAbleToHand()
			else
				b2=false
			end
			if tc:IsCode(14000326) then
				b3=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
			else
				b3=false
			end
			if (b1 or b2 or b3) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				if b1 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0,LOCATION_ONFIELD,1,1,nil)
					if g:GetCount()>0 then
						Duel.HintSelection(g)
						Duel.Release(g,REASON_EFFECT)
					end
				end
				if b2 then
					Duel.HintSelection(mat)
					Duel.SendtoHand(mat:GetFirst(),nil,REASON_EFFECT)
				end
				if b3 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
					if g:GetCount()>0 then
						Duel.HintSelection(g)
						Duel.SendtoHand(g,nil,REASON_EFFECT)
					end
				end
			end
		end
	end
end