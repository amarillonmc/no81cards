--双生少女 奇迹夕立
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010104
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target(cm.spfilter,"sp",LOCATION_HAND+LOCATION_GRAVE),cm.spop)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP,1-tp)
end
function cm.spfilter2(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.check(e,tp)
	local b1= Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter2),tp,0,LOCATION_GRAVE,1,nil,e,tp)
	local b2= Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	return b1 or b2,b2,b1
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")
	local sc1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not sc1 or rssf.SpecialSummon(sc1,0,1-tp,1-tp)<=0 then return end
	cm.buffop(sc1,e) 
	if cm.check(e,tp) and Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local _,b2,b1=cm.check(e,tp)
		local op=rsof.SelectOption(tp,b1 or b2,{m,1},b2,{m,2},b1,{m,3})
		if op~=0 then Duel.BreakEffect() end
		local sc2=nil
		if op==2 then 
			local g=Duel.GetMatchingGroup(cm.spfilter2,tp,0,LOCATION_HAND,nil,e,tp)
			if #g<=0 then return end
			sc2=g:RandomSelect(tp,1):GetFirst()
		elseif op==3 then
			sc2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,0,LOCATION_GRAVE,1,1,nil,e,tp):GetFirst()
		end
		if sc2 and rssf.SpecialSummon(sc2)>0 then
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