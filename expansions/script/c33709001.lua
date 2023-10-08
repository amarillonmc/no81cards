--『研究者』的 WAKABA
local m=33709001
local cm=_G["c"..m]
function cm.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--add
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	--Dont use this card.
	return false
	--return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local card=Duel.CreateToken(tp,m+1)
	Duel.SendtoDeck(card,tp,0,REASON_EFFECT)
	if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then
		local card1=Duel.CreateToken(tp,33709010)
		local card2=Duel.CreateToken(tp,33709011)
		local card3=Duel.CreateToken(tp,33709012)
		local card4=Duel.CreateToken(tp,33709013)
		local card5=Duel.CreateToken(tp,33709014)
		local card6=Duel.CreateToken(tp,33709015)
		local group1=Group.FromCards(card1,card2,card3)
		local group2=Group.FromCards(card4,card5,card6)
		group1:KeepAlive()
		group2:KeepAlive()
		if Duel.SendtoDeck(group1,tp,2,REASON_EFFECT)==3 then
			Duel.BreakEffect()
			if Duel.SendtoGrave(group2,REASON_EFFECT)==3 then
				group1:Merge(group2)
				group1:KeepAlive()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
				e1:SetTargetRange(0,1)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e2:SetCode(EVENT_ADJUST)
				e2:SetLabelObject(group1)
				e2:SetCondition(cm.changecon)
				e2:SetOperation(cm.changeop)
				Duel.RegisterEffect(e2,tp)
			end
		end 
	end
end
function cm.changecon(e,tp)
	local rg=e:GetLabelObject()
	return Duel.GetLP(1-tp)==0 or rg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)==rg:GetCount()
end
function cm.changeop(e,tp)
	local rg=e:GetLabelObject()
	local a=Duel.GetLP(1-tp)==0
	local b=rg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)==rg:GetCount()
	if a then
		Duel.SetLP(1-tp,10)
	end
	if b then
		Duel.Win(1-tp,0x10)
	end
end