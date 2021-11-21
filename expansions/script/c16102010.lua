--SCP-343 神
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102010,"SCP")
function cm.initial_effect(c)
	c:SetUniqueOnField(1,1,m)
	local e1=rscf.SetSummonCondition(c,false)
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.sprcon,cm.sprop)
	local e3=rsef.FTO(c,EVENT_ATTACK_ANNOUNCE,{m,0},nil,"sp",nil,LOCATION_HAND,cm.spcon,nil,rsop.target(cm.spfilter,"sp"),cm.spop)
	local e4,e5=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	--local e6=rsef.FV_LIMIT_PLAYER(c,"res",nil,cm.restg,{1,1})
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=rsef.QO(c,EVENT_CHAINING,{m,3},1,"th","tg",LOCATION_MZONE,nil,nil,rstg.target(cm.ff,"th",LOCATION_GRAVE,LOCATION_GRAVE),cm.tdop)
end
function cm.gfilter(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0 and g:GetClassCount(Card.GetRace)==#g
end
function cm.sprcon(e,c,tp)
	local g=Duel.GetReleaseGroup(tp)
	return g:CheckSubGroup(cm.gfilter,3,3,tp)
end
function cm.sprop(e,tp)
	local g=Duel.GetReleaseGroup(tp)
	rshint.Select(tp,"res")
	local rg=g:SelectSubGroup(tp,cm.gfilter,false,3,3,tp)
	Duel.Release(rg,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.spcon(e,tp)
	return Duel.GetTurnPlayer()~=tp and not Duel.GetAttackTarget() and Duel.GetLP(tp)<=1500
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c and rssf.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
		c:CompleteProcedure()
	end 
	local e1=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"act",cm.val,nil,{1,1},nil,rsreset.pend)
end
function cm.val(e,re)
	return re:GetHandler()~=e:GetHandler()
end
function cm.restg(e,c)
	return c==e:GetHandler()
end
function cm.ff(c)
	return c:IsAbleToHand() or c:IsAbleToDeck()
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
	local tc=rscf.GetTargetCard()
	if tc then 
	local op=Duel.SelectOption(tp,aux.Stringid(16102010,1),aux.Stringid(16102010,2))
	if op==0 then 
	Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	if op==1 then
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) end
	end
end
function cm.repop(e,tp)
	local c=aux.ExceptThisCard(e)
	if Duel.Recover(tp,1000,REASON_EFFECT)>0 and c then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end