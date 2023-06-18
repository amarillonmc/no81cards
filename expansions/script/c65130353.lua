--自然体伊吕波
function c65130353.initial_effect(c)
	--flip
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FLIP)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c65130353.flipop)
	c:RegisterEffect(e0)
	--turn set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65130353,2))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65130353)
	e1:SetTarget(c65130353.postg)
	e1:SetOperation(c65130353.posop)
	c:RegisterEffect(e1)
	--change target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65130353,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65130353.tgcon)
	e2:SetTarget(c65130353.tgtg)
	e2:SetOperation(c65130353.tgop)
	c:RegisterEffect(e2)
end
function c65130353.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(65130353,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c65130353.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and (c:GetFlagEffect(65130353)==0 or Duel.IsPlayerCanDraw(tp,1)) end
	if c:GetFlagEffect(65130353)>0 then
		e:SetCategory(CATEGORY_POSITION+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_POSITION)
		e:SetLabel(0)
	end	
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c65130353.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE) and e:GetLabel()==1 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c65130353.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg:GetCount()==1 and c:IsFacedown()
end
function c65130353.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=ev
	local label=Duel.GetFlagEffectLabel(0,65130354)
	if label then
		if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
	end
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() end
	Duel.SetTargetCard(c)
	local val=ct+bit.lshift(ev+1,16)
	if label then
		Duel.SetFlagEffectLabel(0,65130354,val)
	else
		Duel.RegisterFlagEffect(0,65130354,RESET_CHAIN,0,1,val)
	end
end
function c65130353.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP_DEFENSE)>0 and Duel.CheckChainTarget(ev,c) then
		Duel.ChangeTargetCard(ev,Group.FromCards(c))		
	end
end