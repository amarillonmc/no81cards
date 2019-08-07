--量子驱动组装
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130012
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"sp")
	e1:RegisterSolve(nil,nil,cm.tg,cm.act)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsSetCard(0xa336)
end
function cm.resfilter(c,tp)
	return c:IsSetCard(0xa336) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.CheckReleaseGroupEx(tp,cm.resfilter,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local op=rsof.SelectOption(tp,b1,{m,0},b2,{m,1})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function cm.actfilter(c,e,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xa336) and c:GetActivateEffect():IsActivatable(tp)
end
function cm.act(e,tp)
	local op=e:GetLabel()
	if op==1 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		rsof.SelectHint(tp,"sp")
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,math.min(2,ft),nil,e,tp)
		if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
			Duel.ConfirmCards(1-tp,sg)
		end
	else
		local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.CheckReleaseGroupEx(tp,cm.resfilter,1,nil,tp)
		if not b2 then return end
		local rg=Duel.SelectReleaseGroupEx(tp,cm.resfilter,1,1,nil,tp)
		if Duel.Release(rg,REASON_EFFECT)<=0 then return end
		rsof.SelectHint(tp,"sp")
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
			Duel.ConfirmCards(1-tp,sg)
			if Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				rsof.SelectHint(tp,rshint.act)
				local tc=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
				if not tc then return end
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			end
		end
	end
end