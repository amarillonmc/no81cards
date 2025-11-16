--幻想魔杖·华丽融合
function c22024900.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22024900+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22024900.target)
	e1:SetOperation(c22024900.activate)
	c:RegisterEffect(e1)
end
function c22024900.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c22024900.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:CheckFusionMaterial(m,nil,chkf)
end
function c22024900.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c22024900.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c22024900.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
end
function c22024900.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp):Filter(c22024900.filter1,nil,e)
	local sg=Duel.GetMatchingGroup(c22024900.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local code=tc:GetCode()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg)
		mat:KeepAlive()
		if Duel.SendtoGrave(mat,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.ShuffleExtra(tp)
			local tg=g:RandomSelect(1-tp,1)
			Duel.ConfirmCards(1-tp,tg)
				if tg:IsExists(c22024900.filter,1,nil,e,tp,c) then
				local tc=tg:GetFirst()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
function c22024900.filter(c,e,tp,mc)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end