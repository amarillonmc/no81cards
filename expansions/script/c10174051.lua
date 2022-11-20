--骤雨疾风拳
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174051)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,nil,"tg",cm.con,nil,rstg.target(cm.tgfilter,"dum",LOCATION_MZONE,LOCATION_MZONE),cm.act)
end
function cm.con()
	return Duel.GetCurrentPhase() == PHASE_MAIN1
end	
function cm.tgfitler(c,e,tp)
	return c:IsAttackPos() and c:IsAttackable() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e)
end 
function cm.cfilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function cm.act(e,tp)
	local c,tc=e:GetHandler(),rscf.GetTargetCard(Card.IsAttackPos)
	if not tc then return end
	rshint.Select(tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,e)
	if #g<=0 then return end
	Duel.HintSelection(g)
	local bc=g:GetFirst()
	local ct=0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(100)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.indtg(tc,bc))
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)  
	repeat 
		ct=ct+1
		Duel.CalculateDamage(tc,bc,true)
	until ct==10 or not Duel.SelectYesNo(tp,aux.Stringid(m,1))
	e1:Reset()
	e2:Reset()
end
function cm.indtg(c1,c2)
	return function(e,c)
		return c==c1 or c==c2
	end
end
