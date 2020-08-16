--虚拟水神战士
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020214,"VrAqua")
function cm.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetValue(1)
	e1:SetCondition(cm.con)
	c:RegisterEffect(e1)   
	local e2=rsef.STF(c,EVENT_SUMMON_SUCCESS,{m,1},{1,m},"tg,atk",nil,nil,nil,rsop.target(cm.tgfilter,"tg",LOCATION_MZONE+LOCATION_HAND,0,1,1,c),cm.tgop)
	local e3=rsef.QO(c,nil,{m,2},{1,m+100},"rec","ptg",LOCATION_MZONE,rscon.phase("mp1_o","mp2_o"),nil,rsop.target(100,"rec"),cm.recop)
end
function cm.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_CYBERSE)
end
function cm.con(e)
	return not Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and rsva.IsSet(c)
end
function cm.tgop(e,tp)
	if rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,aux.ExceptThisCard(e),{})<=0 then return end
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	Duel.BreakEffect()
	local e1,e2=rscf.QuickBuff(c,"atk+,def+",1000,"reset",{rsreset.est_pend+RESET_DISABLE+RESET_SELF_TURN,2})
	local e3=rsef.SV_INDESTRUCTABLE(c,"battle",1,nil,{rsreset.est_pend+RESET_SELF_TURN,2},"cd")
	local e3=rsef.SV_INDESTRUCTABLE(c,"effect",aux.indoval,nil,{rsreset.est_pend+RESET_SELF_TURN,2},"cd")
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
