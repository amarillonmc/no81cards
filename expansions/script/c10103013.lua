--冥魂龙 墨该拉
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103013
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND+LOCATION_MZONE,nil,nil,cm.linktg,cm.linkop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"th","de,tg",nil,nil,rstg.target(cm.thfilter,"th",LOCATION_GRAVE+LOCATION_REMOVED),cm.thop)
	cm.rs_ghostdom_dragon_effect={e1,e2}
end
function cm.thfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x337) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.matfilter(c)
	return not c:IsRace(RACE_DRAGON)
end
function cm.lkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function cm.reg(mg,e,tp)
	local c=e:GetHandler()
	local list={}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetValue(aux.TRUE)
	Duel.RegisterEffect(e1,tp)
	table.insert(list,e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCode(EFFECT_MUST_BE_LMATERIAL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	table.insert(list,e2)
	for tc in aux.Next(mg) do 
		if not tc:IsRace(RACE_DRAGON) or (tc:IsOnField() and tc:IsFacedown()) then
			local e3=rsef.SV_CANNOT_BE_MATERIAL({c,tc},"link")
			table.insert(list,e2)
		end
	end
	return list
end
function cm.linktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
		local list=cm.reg(mg,e,tp)
		local res=Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
		for _,effect in pairs(list) do
			effect:Reset()
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	local list=cm.reg(mg,e,tp)
	rsof.SelectHint(tp,"sp")
	local tc=Duel.SelectMatchingCard(tp,cm.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then
		Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
	end
	for _,effect in ipairs(list) do
		effect:Reset()
	end
end
