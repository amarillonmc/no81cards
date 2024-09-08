--水之女演员 枯叶鱼
function c33718007.initial_effect(c)
--展示你的手上1体「水族馆 / Aquarium」卡
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c33718007.condition1)
	e1:SetTarget(c33718007.target)
	e1:SetOperation(c33718007.activate)
	c:RegisterEffect(e1)
--直到本回合结束阶段，你控制的全部「水族馆 / Aquarium」卡得到这个效果展示的卡的效果。

--水再演
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c33718007.condition2)
	c:RegisterEffect(e2)
--唐鱼
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c33718007.condition3)
	c:RegisterEffect(e3)
end
function c33718007.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718007.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718007.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718001) and not Duel.IsPlayerAffectedByEffect(tp,33718017)
end
function c33718007.filter(c)
	return c:IsSetCard(0xce) and c:IsType(TYPE_SPELL)
end
function c33718007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingTarget(c33718007.filter,tp,LOCATION_HAND,0,1,nil)
	end
end
function c33718007.allfilter(c)
	return c:IsSetCard(0xce) and c:IsLocation(LOCATION_SZONE)
end
function c33718007.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEFENSE)
	local g=Duel.SelectMatchingCard(tp,c33718007.filter,tp,LOCATION_HAND,0,1,nil)
	local all=Duel.SelectMatchingCard(tp,c33718007.allfilter,tp,LOCATION_SZONE,0,1,nil)
	local gone=g:GetFirst()
	local allone=all:GetFirst()
	if Duel.ConfirmCards(1-tp,gone)~=0 then
		local code=gone:GetOriginalCodeRule()
		while allone do
			local cid=allone:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(aux.Stringid(33718007,0))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c33718007.copyoperation)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			allone:RegisterEffect(e1)
			allone=all:GetNext()
		end
	end
end
function c33718007.copyperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end


