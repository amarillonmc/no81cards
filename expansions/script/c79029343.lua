--卡西米尔·近卫干员-鞭刃
function c79029343.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c79029333.lcheck)
	c:EnableReviveLimit() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029343)
	e1:SetCost(c79029343.chcost)
	e1:SetTarget(c79029343.chtg)
	e1:SetOperation(c79029343.chop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c79029343.idtg)
	c:RegisterEffect(e2)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c79029343.idtg)
	e2:SetValue(c79029343.val)
	c:RegisterEffect(e2)
end
function c79029333.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1909)
end
function c79029343.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil,POS_FACEDOWN)==1 end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029343.cfil(c)
	return c:IsSetCard(0xa900) and not c:IsStatus(STATUS_NO_LEVEL)
end
function c79029343.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return lg:IsExists(c79029343.cfil,2,nil) end
	local op=0
	op=Duel.SelectOption(tp,aux.Stringid(79029343,0),aux.Stringid(79029343,1))
	e:SetLabel(op)
	Duel.SetTargetCard(lg)
end
function c79029343.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local op=e:GetLabel()
	if op==0 then
	Duel.SetTargetCard(lg)  
	Debug.Message("打起精神来，该出发了！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029343,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local x=Duel.AnnounceLevel(tp,1,12,lv)
	local tc=lg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(x)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_RANK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(x)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=lg:GetNext()
	end
	else
	Debug.Message("没有忘记自己该做什么吧？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029343,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local x=Duel.AnnounceAttribute(tp,1,0xffff)
	local tc=lg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(x)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=lg:GetNext()
	end
	end 
end
function c79029343.idtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:GetMaterialCount()>=2
end
function c79029343.val(e,c)
	return c:GetAttack()*2
end










