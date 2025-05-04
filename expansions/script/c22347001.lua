--蕾宗忍法贴
local cm,m,o=GetID()
function cm.initial_effect(c)
--[[
①：从以下效果选1个适用。
●自己墓地·除外状态的1张「蕾宗忍法」魔法卡在自己场上盖放。
●自己场上1张卡回到持有者手卡
--]]
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
--[[
②：自己发动的魔法卡的效果的处理时，可以把墓地的这张卡除外。那个场合，那个效果变成「从卡组把1张「蕾宗忍法」魔法卡在自己场上盖放」。
--]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.chcon)
	e2:SetOperation(cm.chop)
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


function cm.filter(c)
	return c:IsSetCard(0x3705) and c:IsType(TYPE_SPELL) and c:IsSSetable() and c:IsFaceup()
end
function cm.spfilter(c,e,tp)
	return c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local b1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+2
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			res=Duel.SSet(tp,sg)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp):GetFirst()
		res=Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
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
	local rc=re:GetHandler()
	local c=e:GetHandler()
	return ep==tp and re:IsActiveType(TYPE_SPELL) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost()
end
function cm.thfilter(c)
	return c:IsSetCard(0x3705) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetLocation()==LOCATION_GRAVE and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.repop)
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local res=0
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		res=Duel.SSet(tp,g,tp,true)
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



function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--公开
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
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