--可可莉柯特·布兰琪
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rsof.DefineCard(33310100,"Cochrot")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rsef.SC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,nil,rscon.sumtype("rit"),cm.atkop)
	local e2,e3=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	local e4=rsef.RegisterClone(c,e3,"code",EFFECT_AVOID_BATTLE_DAMAGE)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(cm.damcon)
	e5:SetOperation(cm.damop)
	c:RegisterEffect(e5)
	local e6=rsef.STO(c,EVENT_REMOVE,{m,0},nil,nil,"de,dsp",nil,nil,rsop.target(cm.actfilter,nil,LOCATION_GRAVE+LOCATION_DECK),cm.actop)
end
function cm.atkop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g<=0 then return end
	Duel.Hint(HINT_CARD,0,m)
	for tc in aux.Next(g) do
		local e1=rsef.SV_SET({e:GetHandler(),tc},"atkf",0,nil,rsreset.est)
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function cm.actfilter(c,e,tp)
	return c:IsCode(33310101) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.actop(e,tp)
	rsof.SelectHint(tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.actfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	te:UseCountLimit(tp,1,true)
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
end