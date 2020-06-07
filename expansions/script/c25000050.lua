--黑暗领域
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000050)
function cm.initial_effect(c)
	local e2=rsef.I(c,{m,0},{1,m+100},"sp",nil,LOCATION_FZONE,nil,cm.spcost,rsop.target(rssb.ssfilter(true),"sp",LOCATION_REMOVED),cm.spop)
	local e3,e4=rsef.FV_UPDATE(c,"atk,def",300,cm.tg,{LOCATION_MZONE,LOCATION_MZONE })
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCondition(cm.btcon)
	e5:SetOperation(cm.btop)
	c:RegisterEffect(e5)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==5 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>5 then ct=5 end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>0 end
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetCard(g)
end
function cm.spop(e,tp)
	local g=rsgf.GetTargetGroup()
	rsgf.SelectSpecialSummon(g,tp,rssb.ssfilter(true),1,1,nil,{0,tp,tp,true,false,POS_FACEUP },e,tp)
end
function cm.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR+RACE_FIEND)
end
function cm.cfilter(c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_DARK) or not c:IsRace(RACE_FIEND+RACE_WARRIOR)
end
function cm.btcon(e,tp,eg,ep,ev,re,r,rp)
	local ac,bc=Duel.GetAttacker(),Duel.GetAttackTarget()
	return cm.cfilter(ac) or cm.cfilter(bc)
end
function cm.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.CreateGroup()
	if cm.cfilter(a) then 
		g:AddCard(a)
	end
	if cm.cfilter(d) then 
		g:AddCard(d)
	end
	for tc in aux.Next(g) do
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_BATTLE_ATTACK)
		e4:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e4:SetValue(tc:GetBaseAttack())
		tc:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_SET_BATTLE_DEFENSE)
		e5:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e5:SetValue(tc:GetBaseDefense())
		tc:RegisterEffect(e5,true) 
	end
end