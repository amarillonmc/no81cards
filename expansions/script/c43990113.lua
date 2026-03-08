--黑兽-巳
local m=43990113
local cm=_G["c"..m]
function cm.initial_effect(c)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Removerm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990113,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,43990113)
	e2:SetCondition(c43990113.rmcon)
	e2:SetTarget(c43990113.rmtg)
	e2:SetOperation(c43990113.rmop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c43990113.rmop2)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(43990113,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,43900113)
	e4:SetCondition(c43990113.drcon)
	e4:SetTarget(c43990113.drtg)
	e4:SetOperation(c43990113.drop)
	c:RegisterEffect(e4)
	if not c43990113.global_check then
		c43990113.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetCondition(c43990113.checkcon)
		ge1:SetOperation(c43990113.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
	end
	
end
function c43990113.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp
end
function c43990113.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=Duel.GetFlagEffectLabel(tp,43990113)
	return c:IsDefensePos() and flag and flag>0
end
function c43990113.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x6510) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c43990113.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsFaceup,nil)
	local tc=tg:GetFirst()
	while tc do
		local ac=bit.band(tc:GetType(),0x7)
		local flag1=Duel.GetFlagEffectLabel(tp,43990113)
		if (not flag1) or bit.band(flag1,ac)==0 then
			if flag1 then
				Duel.SetFlagEffectLabel(tp,43990113,flag1+ac)
			else
				Duel.RegisterFlagEffect(tp,43990113,RESET_PHASE+PHASE_END,0,1,ac)
			end
		end
		tc=eg:GetNext()
	end
end
function c43990113.rmfilter(c)
	return c:IsSetCard(0x6510) and c:IsAbleToRemove() and not c:IsCode(43990113)
end
function c43990113.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c43990113.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c43990113.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c43990113.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c43990113.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==43990113 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c43990113.retop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c43990113.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c43990113.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

function c43990113.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag=Duel.GetFlagEffectLabel(tp,43990113)
	local dc=0
	while flag and flag~=0 do
		if flag&0x1~=0 then dc=dc+1 end
		flag=flag>>1
	end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,dc) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dc)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dc)
end
function c43990113.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,dc=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,dc,REASON_EFFECT)
end
