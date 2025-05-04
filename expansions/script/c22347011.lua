--蕾宗忍法·握握手
local cm,m,o=GetID()
function cm.initial_effect(c)
--[[
①：从手卡·卡组把1张「蕾宗忍」卡送去墓地才能发动。选自己场上1张卡回到手卡。
--]]
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
--[[
②：「蕾宗忍法」通常·速攻魔法卡由自己发动的场合，可以把墓地的这张卡除外，给那个效果加上以下效果。
●发动后这张卡不送去墓地，直接盖放。
--]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(22347011)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.chcon)
	c:RegisterEffect(e2)
--[[
③：这张卡从场上回到手卡的场合，直到回合结束得到以下效果。
●手卡的这张卡持续公开。
●这张卡可以在对方回合从手卡发动。
--]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCondition(cm.regcon)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)	
end


function cm.costfilter(c)
	return c:IsSetCard(0x705) and c:IsAbleToGraveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local res=0
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		res=Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local c=e:GetHandler()
	local exc=nil
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) then exc=c end
	local te=Duel.IsPlayerAffectedByEffect(tp,22347011)
	if c:IsSetCard(0x3705) and c:GetType(TYPE_SPELL) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and te and Duel.SelectYesNo(tp,Auxiliary.Stringid(22347011,1)) and c:IsRelateToEffect(e) and c:IsCanTurnSet()
	then
		if res>0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=Duel.SelectMatchingCard(tp,cm.lllfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,22347011)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function cm.lllfilter(c)
	return c:IsCode(22347011) and c:IsAbleToRemoveAsCost()
end


function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAbleToRemoveAsCost()
end



function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--公开
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	c:RegisterEffect(e1)
	--手发
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	e2:SetDescription(aux.Stringid(m,0))
	c:RegisterEffect(e2)
end