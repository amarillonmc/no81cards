--魔雷冥
local m=40011645
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,70781052)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)

end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(70781052) 
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.NegateSummonCondition() and rp==1-tp and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_GRAVE)>0
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,eg:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)

	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(tp,ct*100,REASON_EFFECT)
		Duel.Remove(Duel.GetFieldGroup(tp,0,LOCATION_GRAVE),POS_FACEUP,REASON_EFFECT)
	end
end
function cm.filter(c,type)
	return c:IsCode(70781052) and c:IsType(type) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	local ct=0
	for i,type in ipairs({TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ}) do
		if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,type) then
			ct=ct+1
		end
	end
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=0
	for i,type in ipairs({TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ}) do
		if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,type) then
			ct=ct+1
		end
	end
	Duel.Draw(p,ct,REASON_EFFECT)
end