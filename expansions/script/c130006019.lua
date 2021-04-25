--反转世界的希冀 卡莉
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006019,"FanZhuanShiJie")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(rsfz.IsFusSet),2,true)
	local e1 = rsef.FV_Player(c,"sp~",nil,cm.limittg,{1,1},nil,LOCATION_MZONE)
	local e2 = rsef.STO(c,EVENT_TO_GRAVE,"sp",nil,"sp","de,tg",nil,nil,rstg.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return rsfz.IsSet(c) and rscf.spfilter2()(c,e,tp)
end
function cm.spop(e,tp)
	local tc = rscf.GetTargetCard()
	if tc then
		rssf.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,nil,{ "rlve",LOCATION_REMOVED })
	end
end
function cm.tgfilter(c,tc)
	return tc:GetColumnGroup():IsContains(c)
end
function cm.adjustop(e,tp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e:GetHandler())
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Readjust()
	end
end
function cm.afilter(c,race,att)
	return c:IsFaceup() and c:IsRace(race) and c:IsAttribute(att)
end
function cm.limittg(e,c)
	return not Duel.IsExistingMatchingCard(cm.afilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetRace(),c:GetAttribute())
end