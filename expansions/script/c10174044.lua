--冷箭
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174044)
function cm.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1) 
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)   
	local e3 = rsef.STO(c,EVENT_DESTROYED,"tg",nil,"tg","de",cm.tgcon,nil,
		rsop.target(Card.IsAbleToGrave,"tg",LOCATION_ONFIELD,LOCATION_ONFIELD),
		cm.tgop)
	local e4 = rsef.RegisterClone(c,e3,"code",EVENT_REMOVE)
end
function cm.tgcon(e,tp)
	local c = e:GetHandler()
	return c:GetReasonPlayer() ~= tp and c:IsReason(REASON_EFFECT)
end
function cm.tgop(e,tp)
	rsop.SelectOperate("tg",tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc = Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return Duel.IsChainNegatable(ev) and (re:IsHasCategory(CATEGORY_DESTROY) or re:IsHasCategory(CATEGORY_REMOVE)) and loc & LOCATION_ONFIELD ~= 0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.actcon(e)
	local c=e:GetHandler()
	local seq1=aux.SZoneSequence(c:GetSequence())
	local res,eg,ep,ev,re,r,rp=Duel.CheckEvent(EVENT_CHAINING,true)
	if res and ev then
		local loc,seq2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
		seq2=aux.MZoneSequence(seq2)
		if seq1==4-seq2 then 
			return true
		end
	else
		return false
	end
end