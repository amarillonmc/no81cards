--蕾宗忍法·影分身十字斩
local s,id,o=GetID()
function s.initial_effect(c)
	--[[
①：以自己场上1只「蕾宗忍者」怪兽为对象才能发动。以下效果重复自己手卡持续公开的「蕾宗忍」卡数量+1次。
●对方场上随机1只怪兽的攻击力下降这张卡攻击力一半的数值。为0的场合破坏。
	--]]
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)	
	--②：卡的效果发动的场合，把墓地的这张卡除外才能发动。自己场上「蕾宗忍者」怪兽的攻击力上升500。
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.atktg2)
	e2:SetOperation(s.atkop2)
	c:RegisterEffect(e2)	
	--[[
③：这张卡从场上回到手卡的场合，直到回合结束得到以下效果。
●手卡的这张卡持续公开。
●这张卡可以在对方回合从手卡发动。
	--]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCondition(s.regcon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5705)
end
function s.pfilter(c)
	return c:IsPublic() and c:IsSetCard(0x705)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.atkop(e,tp)
	local tc=Duel.GetFirstTarget()
	local res=0
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end   
	local count=Duel.GetMatchingGroupCount(s.pfilter,tp,LOCATION_HAND,0,nil)+1
	local res=count
	for i=1,count do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if #g==0 then return end
		local sg=g:RandomSelect(tp,1)
		local sc=sg:GetFirst()
		local atk=math.floor(tc:GetAttack()/2)
		if atk>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			if sc:GetAttack()==0 then
				Duel.Destroy(sc,REASON_EFFECT)
			end
		else
			Duel.Destroy(sc,REASON_EFFECT)
		end
	end
	local c=e:GetHandler()
	local exc=nil
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) then exc=c end
	local te=Duel.IsPlayerAffectedByEffect(tp,22347011)
	if c:IsSetCard(0x3705) and c:GetType(TYPE_SPELL) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and te and Duel.SelectYesNo(tp,Auxiliary.Stringid(22347011,1)) and c:IsRelateToEffect(e) and c:IsCanTurnSet()
	then
		if res>0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=Duel.SelectMatchingCard(tp,s.lllfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,22347011)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function s.lllfilter(c)
	return c:IsCode(22347011) and c:IsAbleToRemoveAsCost()
end


function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_MZONE,0,nil)>0 end
end
function s.atkop2(e,tp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.regop(e,tp)
	local c=e:GetHandler()
	--公开
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
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
	e2:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e2)
end
