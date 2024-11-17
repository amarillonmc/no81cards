--觉醒·孟婆
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410013)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(cm.drcon)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,23410013)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(23410013)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	Duel.RegisterEffect(e2,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local gnum=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)
	if gnum<10 then return end
	local num=0
	while gnum>=10 do
		gnum=gnum-10
		num=num+1
	end
	Duel.Draw(tp,num,REASON_EFFECT)
end

function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,3,nil)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=1
	if Duel.IsPlayerAffectedByEffect(tp,23410013) then
		Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetDecktopGroup(1-tp,num):FilterCount(Card.IsAbleToRemove,nil)==num end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,num,1-tp,LOCATION_DECK)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local num=1
	if Duel.IsPlayerAffectedByEffect(tp,23410013) then
		Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	local rg=Duel.GetDecktopGroup(1-tp,num)
	if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end