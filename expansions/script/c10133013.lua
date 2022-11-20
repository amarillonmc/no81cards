--满月夜
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10133001)
	local e1 = rsef.A(c,nil,nil,{1,id,"o"},"sp",nil,nil,
		rscost.setlab(100),s.tg,s.act)
end
function s.rfilter(c,e,tp)
	return c:IsCode(10133001) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,rc)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3334) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,rc,c) > 0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg = Duel.GetReleaseGroup(tp):Filter(Card.IsOnField,nil)
	if chk == 0 then
		if e:GetLabel() ~= 100 then 
			return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		else
			e:SetLabel(0)
			return rg:IsExists(s.rfilter,1,nil,e,tp)
		end
	end
	if e:GetLabel() == 100 then
		e:SetLabel(0)
		rshint.Select(tp,"res")
		local g = rg:FilterSelect(tp,s.rfilter,1,1,nil,e,tp)
		Duel.Release(g,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.act(e,tp)
	local ct,og,tc = rsop.SelectOperate("sp",tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{0,tp,tp,true,false,POS_FACEUP},e,tp)
	if tc then
		local e1 = rsef.FC_PhaseOpearte({e:GetHandler(),tp},tc,1,nil,PHASE_END,nil,s.rfop)
	end
end
function s.spfilter2(c,e,tp)
	return (c:IsCode(10133001) or c:IsHasEffect(10133009)) and rscf.spfilter2()(c,e,tp)
end
function s.rfop(g,e,tp)
	local tc = g:GetFirst()
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) > 0 and tc:IsLocation(LOCATION_EXTRA) then
		rsop.SelectSpecialSummon(tp,s.spfilter2,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,{},e,tp)
	end
end