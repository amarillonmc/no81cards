--双生少女 奇迹时雨
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010103
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,8,2)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target(cm.spfilter,"sp",LOCATION_EXTRA),cm.spop)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCountFromEx(1-tp)>0 and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP,1-tp) and not c:IsType(TYPE_XYZ)
end
function cm.spfilter2(c,e,tp)
	return Duel.GetLocationCountFromEx(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")
	local sc1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not sc1 or rssf.SpecialSummon(sc1,0,1-tp,1-tp,false,false,POS_FACEUP)<=0 then return end 
	cm.buffop(sc1,e) 
	if Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 and Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(cm.spfilter2,tp,0,LOCATION_EXTRA,nil,e,tp)
		local sc2=g:RandomSelect(tp,1):GetFirst()
		if sc2 and rssf.SpecialSummon(sc2,0,tp,tp,true,false,POS_FACEUP)>0 then
			cm.buffop(sc2,e)
		end
	end 
end
function cm.buffop(tc,e)
	local c=e:GetHandler()
	local e1=rsef.SV_LIMIT({c,tc},"atk",nil,nil,rsreset.est)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_DECK)
	tc:RegisterEffect(e1)
	return true
end