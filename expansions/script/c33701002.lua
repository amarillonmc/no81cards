--残星倩影 阅遍三界
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701002
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x144d),aux.NonTuner(nil),1)
	local e1=rsef.STF(c,EVENT_ATTACK_ANNOUNCE,{m,0},nil,"atk,def","tg")
	rsef.RegisterSolve(e1,nil,nil,rstg.target({cm.cfilter,nil,LOCATION_MZONE,0,1,1,c }),cm.op)
	local e2=rsef.STF(c,EVENT_BE_BATTLE_TARGET,{m,0},nil,"atk,def","tg")
	rsef.RegisterSolve(e1,nil,nil,rstg.target({cm.cfilter,nil,LOCATION_MZONE,0,1,1,c }),cm.op)
	local e3=rsef.STF(c,EVENT_ATTACK_ANNOUNCE,{m,0},nil,"tg")
	rsef.RegisterSolve(e1,cm.tgcon,nil,cm.tgtg,cm.tgop) 
	local e4=rsef.STF(c,EVENT_BE_BATTLE_TARGET,{m,0},nil,"tg")
	rsef.RegisterSolve(e1,cm.tgcon,nil,cm.tgtg,cm.tgop)  
end
function cm.cfilter(c)
	return c:IsSetCard(0x144d) and c:IsFaceup()
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard()
	if not tc then return end
	local e1=rsef.SV_INDESTRUCTABLE({c,tc},"effect",1,nil,rsreset.est_pend)
	if tc:IsType(TYPE_MONSTER) and tc:IsFaceup() then
		local e2,e3=rsef.SV_UPDATE({c,tc},"atk,def",5000,nil,rsreset.est_pend)
	end
end
function cm.tgcon(e,tp)
	return not Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),33701004)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.tgop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then Duel.SendtoGrave(c,REASON_EFFECT) end
end