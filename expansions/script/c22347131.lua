--蕾宗忍法·欧内死手
function c22347131.initial_effect(c)
	--[[
①：宣言「我夺取心脏」才能发动。从以下效果选1个适用。
●给与对方为对方手卡数量×350伤害。
●对方场上1只表侧表示的怪兽破坏，给与对方那个原本攻击力数值的伤害。
	--]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22347131,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22347131+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22347131.cost)
	e1:SetTarget(c22347131.target)
	e1:SetOperation(c22347131.activate)
	c:RegisterEffect(e1)
	--[[
②：这张卡从场上回到手卡的场合，直到回合结束得到以下效果。
●手卡的这张卡持续公开。
●这张卡可以在对方回合从手卡发动。
	--]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c22347131.regcon)
	e2:SetOperation(c22347131.regop)
	c:RegisterEffect(e2)
end
function c22347131.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c22347131.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return true end
end
function c22347131.activate(e,tp,eg,ep,ev,re,r,rp,op)
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	local res=0
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(22347131,1)},
		{b2,aux.Stringid(22347131,2)})
	if op==1 then
		res=Duel.Damage(1-tp,Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*350,REASON_EFFECT)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			local atk=g:GetFirst():GetTextAttack()
			if atk<0 then atk=0 end
			Duel.HintSelection(g)
			res=Duel.Destroy(g,REASON_EFFECT)
			if res~=0 then
				Duel.Damage(1-tp,atk,REASON_EFFECT)
			end
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
		g=Duel.SelectMatchingCard(tp,c22347131.lllfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,22347011)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function c22347131.lllfilter(c)
	return c:IsCode(22347011) and c:IsAbleToRemoveAsCost()
end


function c22347131.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c22347131.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--公开
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22347131,4))
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
	e2:SetDescription(aux.Stringid(22347131,3))
	c:RegisterEffect(e2)
end