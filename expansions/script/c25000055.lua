--镜中龙 生存烈火
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000055)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,cm.sfilter,1)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"tg,dis",nil,LOCATION_MZONE,rscon.phmp,nil,rsop.target(Card.IsAbleToGrave,"tg",0,LOCATION_ONFIELD),cm.tgop)
	local e2=rsef.SV_UPDATE(c,"atk",cm.val)
end
function cm.sfilter(c)
	return c:IsRace(RACE_WARRIOR) or c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.tgop(e,tp)
	local ct,og,tc=rsop.SelectToGrave(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil,{})
	if not tc then return end
	if tc:IsPreviousLocation(LOCATION_MZONE) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,tc:GetPreviousAttackOnField(),REASON_EFFECT)
	end
	tc:RegisterFlagEffect(m,rsreset.est_pend,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e1,tp)
	local e1,e2=rscf.QuickBuff({e:GetHandler(),tc},"dis,dise","reset",rsreset.est_pend)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler()==tc and tc:GetFlagEffect(m)>0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(rscf.fufilter(cm.sfilter),e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*500
end