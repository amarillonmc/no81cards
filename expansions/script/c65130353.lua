--自然体伊吕波
local s,id,o=GetID()
function s.initial_effect(c)
	--change target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg:GetCount()==1 and c:IsFacedown()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=ev
	local label=Duel.GetFlagEffectLabel(0,id)
	if label then
		if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
	end
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() end
	Duel.SetTargetCard(c)
	local val=ct+bit.lshift(ev+1,16)
	if label then
		Duel.SetFlagEffectLabel(0,id,val)
	else
		Duel.RegisterFlagEffect(0,id,RESET_CHAIN,0,1,val)
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP_DEFENSE)>0 and Duel.CheckChainTarget(ev,c) then
		Duel.ChangeTargetCard(ev,Group.FromCards(c))		
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	local tgs=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local ex1,tg1=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex2,tg2=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex3,tg3=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	local b1= ex1 and tg1:IsContains(c)
	local b2= ex2 and tg2:IsContains(c)
	local b3= ex3 and tg3:IsContains(c)
	local b4= (ex1 and tg1~=nil or ex2 and tg2~=nil or ex3 and tg3~=nil) and tgs and tgs:IsContains(c)
	if Duel.IsChainDisablable(ev) and (b1 or b2 or b3 or b4) then 
		if Duel.NegateEffect(ev,true) and ec:IsRelateToEffect(re) then
			ec:CancelToGrave()
			Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end