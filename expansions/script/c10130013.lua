--量子驱动 Δ构筑
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130013
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.lfilter,1,1)
	c:EnableReviveLimit()
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_HAND),cm.op)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	cm.QuantumDriver_EffectList={nil,e1}
end
function cm.lfilter(c)
	return c:IsLinkType(TYPE_FLIP) and c:IsSetCard(0xa336)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xa336) and c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	rsof.SelectHint(tp,"sp")
	local sc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)<=0 then return end
	Duel.ConfirmCards(1-tp,sc)
	local effectlist=sc.QuantumDriver_EffectList
	if not effectlist or not effectlist[1] then return end
	local te=effectlist[1]
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	local op=te:GetOperation()
	op(e,tp,eg,ep,ev,re,r,rp) 
end
