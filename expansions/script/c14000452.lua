--鱼越龙魂
local m=14000452
local cm=_G["c"..m]
cm.named_with_Goverfish=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.GFish(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Goverfish
end
function cm.dfilter(c)
	return cm.GFish(c) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function cm.filter(c,e,tp,mat,ft)
	if not c:IsAttribute(ATTRIBUTE_WATER) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=mat:Filter(Card.IsCanBeRitualMaterial,c,c)
	local dg=Duel.GetMatchingGroup(cm.dfilter,tp,LOCATION_DECK,0,nil)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil,tp)
		dg=dg:Filter(c.mat_filter,nil,tp)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
			or dg:IsExists(cm.dlvfilter,1,nil,tp,mg,c)
	else
		return ft>-1 and mg:IsExists(cm.mfilterf,1,nil,tp,mg,dg,c)
	end
end
function cm.mfilterf(c,tp,mg,dg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
			or dg:IsExists(cm.dlvfilter,1,nil,tp,mg,rc,c)
	else return false end
end
function cm.dlvfilter(c,tp,mg,rc,mc)
	Duel.SetSelectedCard(Group.FromCards(c,mc))
	return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg1,ft)
	local tc=tg:GetFirst()
	if tc then
		local mat,dmat
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local dg=Duel.GetMatchingGroup(cm.dfilter,tp,LOCATION_DECK,0,nil)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
			dg=dg:Filter(tc.mat_filter,nil,tp)
		end
		if ft>0 then
			local b1=dg:IsExists(cm.dlvfilter,1,nil,tp,mg,tc)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,cm.dlvfilter,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(dmat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(dmat)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,dg,tc)
			local b1=dg:IsExists(cm.dlvfilter,1,nil,tp,mg,tc,mat:GetFirst())
			Duel.SetSelectedCard(mat)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,cm.dlvfilter,1,1,nil,tp,mg,tc,mat:GetFirst())
				mat:Merge(dmat)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			else
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			end
		end
		tc:SetMaterial(mat)
		if dmat then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end