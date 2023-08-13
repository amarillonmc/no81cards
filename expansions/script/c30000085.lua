--终焉邪魂 堕天的使徒 萨利丝
local m=30000085
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e02=Effect.CreateEffect(c)  
	e02:SetCategory(CATEGORY_DRAW)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_HAND)
	e02:SetCountLimit(1,m)
	e02:SetCost(cm.cost)
	e02:SetTarget(cm.tg)
	e02:SetOperation(cm.op)
	c:RegisterEffect(e02)  
	--Effect 2 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(cm.lvtg)
	e3:SetOperation(cm.lvop)
	c:RegisterEffect(e3) 
end
--Effect 1
function cm.cf(c)
	return c:IsAbleToRemove() and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	if chk==0 then return ec:IsAbleToRemove() and Duel.IsExistingMatchingCard(cm.cf,tp,LOCATION_HAND,0,1,ec) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cf,tp,LOCATION_HAND,0,1,1,ec)
	g:AddCard(ec) 
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ckg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	if #ckg>0 then
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(3)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local pc,ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(pc,1,REASON_EFFECT)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(pc,2,REASON_EFFECT)
		Duel.ShuffleHand(pc)
	end
end
--Effect 2
function cm.lf(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.lf,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.lf,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tag=g:Select(tp,1,1,nil)
	if #tag==0 then return end
	Duel.HintSelection(tag)
	local tc=tag:GetFirst()
	local lv=tc:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local cct=Duel.AnnounceLevel(tp,1,8)
	local ct=cct	
	local opt=0
	if cct>=lv then
		opt=Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	end
	if opt==1 then
		ct=-cct
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(ct)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end