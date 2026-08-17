--『凯旋之歌』黎塞留
function c9911768.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c9911768.mfilter,nil,2,99)
	c:EnableReviveLimit()
	--RPS
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9911768.rpscon)
	e1:SetTarget(c9911768.rpstg)
	e1:SetOperation(c9911768.rpsop)
	c:RegisterEffect(e1)
end
function c9911768.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,8) or c:IsXyzLevel(xyzc,9) or c:IsXyzLevel(xyzc,10)
end
function c9911768.rpscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9911768.rpstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function c9911768.rpsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local ct=c:GetOverlayCount()
	if ct>5 then ct=5 end
	local win=0
	local draw=0
	local loss=0
	for i=1,ct do
		local res=Duel.RockPaperScissors(false)
		if res==tp then win=win+1
		elseif res==PLAYER_NONE then draw=draw+1
		elseif res==1-tp then loss=loss+1 end
	end
	if win>=1 and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(tp,aux.Stringid(9911768,0)) then
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
	if draw>=1 and Duel.IsPlayerCanDraw(tp,draw) and Duel.SelectYesNo(tp,aux.Stringid(9911768,1)) then
		Duel.Draw(tp,draw,REASON_EFFECT)
	end
	if loss>=2 then
		local rt=c:RemoveOverlayCard(tp,1,99,REASON_EFFECT)
		if rt>0 and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(rt*1900)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
end
