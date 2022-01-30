--炼狱骑士团 魔剑处刑龙 
if not pcall(function() require("expansions/script/c40008677") end) then require("script/c40008677") end
local m=40008693
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()  
	local e1=rsef.SC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,"cd",rscon.sumtype("syn"),cm.regop)
	local e2=rsef.STO(c,EVENT_TO_GRAVE,{m,4},nil,"sp","de,dsp",cm.spcon,nil,rsop.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	if not cm.gbl then
		cm.gbl=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.resetcount)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.material_type=TYPE_SYNCHRO
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mat0=c:GetMaterial()
	local mat=mat:Filter(Card.IsType,nil,TYPE_SYNCHRO)
	if #mat>=3 then
		local e1=rsef.QO(c,nil,{m,0},1,"dis",nil,LOCATION_MZONE,nil,nil,nil,cm.disop,nil,rsreset.est)
	end
	if #mat>=4 then
		local e2=rsef.SV_SET(c,"batk",c:GetBaseAttack()*2,nil,rsreset.est_d)
	end
	if #mat>=5 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EXTRA_ATTACK)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(rsreset.est_d)
		e3:SetValue(#mat0-1)
		c:RegisterEffect(e3)
	end
	if #mat>=6 then
		local e4=rsef.QO(c,nil,{m,1},1,"td",nil,LOCATION_MZONE,nil,nil,rsop.target(Card.IsAbleToDeck,"td",0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,true),cm.tdop)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	cm[tp]=cm[tp]+1
	if cm[tp]>1 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.discon2)
	e1:SetOperation(cm.disop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and rp~=tp and cm[tp]>0
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,3))
		cm[tp]=cm[tp]-1
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.tdop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function cm.spcon(e,tp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x10c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.HintSelection(sg)
		rssf.SpecialSummon(sg)
	end
end