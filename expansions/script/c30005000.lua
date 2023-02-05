--误召异神
local m=30005000
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,30005010,30005040,30005045)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.mfilter(c)
	return c:GetLevel()>0 and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.mfilter),tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
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
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		--local fid=c:GetFieldID()
		--tc:RegisterFlagEffect(m,RESET_EVENT+RESET_TODECK,0,1,fid)
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--e1:SetCode(EVENT_LEAVE_FIELD)
		--e1:SetCondition(cm.drcon)
		--e1:SetOperation(cm.drop)
		--e1:SetLabel(fid)
		--e1:SetLabelObject(tc)
		--Duel.RegisterEffect(e1,tp)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffectLabel(m)==e:GetLabel() then
		if not eg:IsContains(tc) then return false end
		tc:ResetFlagEffect(m)
		return true
	else
		e:Reset()
		return false
	end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	--Duel.Hint(HINT_CARD,0,m)
	--Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.thfilter(c)
	return c:IsCode(m,30005010,30005040,30005045) and c:IsAbleToHand()
end
function cm.th(c)
	return c:IsCode(30005003) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)==0 then return false end
	local tc=Duel.GetOperatedGroup():GetFirst() 
	local chk1=tc:IsAttribute(ATTRIBUTE_DARK) and tc:IsType(TYPE_RITUAL)
	local chk2=tc:GetType()==TYPE_SPELL+TYPE_RITUAL 
	local chk3=Duel.IsExistingMatchingCard(cm.th,tp,LOCATION_DECK,0,1,nil)
	local thchk=false
	if (chk1 or chk2) and chk3 then thchk=true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0 then return false end
	Duel.ConfirmCards(1-tp,g)
	if thchk==true and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=Duel.SelectMatchingCard(tp,cm.th,tp,LOCATION_DECK,0,1,1,nil)
		if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0 then return false end
		Duel.ConfirmCards(1-tp,g)
	end
end

