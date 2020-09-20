--N 光之纽带
function c9950712.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
  --Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9950712)
	e3:SetTarget(c9950712.drtg)
	e3:SetOperation(c9950712.drop)
	c:RegisterEffect(e3)
--mzone limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_MAX_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c9950712.value)
	c:RegisterEffect(e2)
	--advance summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(c9950712.sumlimit)
	c:RegisterEffect(e3)
	--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,99507120)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c9950712.thtg)
	e4:SetOperation(c9950712.thop)
	c:RegisterEffect(e4)
end
function c9950712.drfilter(c)
	return c:IsSetCard(0x3bd3) and c:IsAbleToRemove()
end
function c9950712.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c9950712.drfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9950712.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950712.drfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c9950712.value(e,fp,rp,r)
	if rp==e:GetHandlerPlayer() or r~=LOCATION_REASON_TOFIELD then return 7 end
	local limit=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return limit>0 and limit or 7
end
function c9950712.sumlimit(e,c)
	local tp=e:GetHandlerPlayer()
	if c:IsControler(1-tp) then
		local mint,maxt=c:GetTributeRequirement()
		local x=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		local y=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local ex=Duel.GetMatchingGroupCount(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,EFFECT_EXTRA_RELEASE)
		local exs=Duel.GetMatchingGroupCount(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,EFFECT_EXTRA_RELEASE_SUM)
		if ex==0 and exs>0 then ex=1 end
		return y-maxt+ex+1 > x-ex
	else
		return false
	end
end
function c9950712.thfilter(c)
	return c:IsSetCard(0x3bd3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9950712.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9950712.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950712.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9950712.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9950712.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
