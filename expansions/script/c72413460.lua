--恒久的冰晶之光 艾琳
function c72413460.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(c72413460.sfilter),1,99)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72413460,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,72413460)
	e1:SetCondition(c72413460.drcon)
	e1:SetTarget(c72413460.drtg)
	e1:SetOperation(c72413460.drop)
	c:RegisterEffect(e1)	
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c72413460.actlimit)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72413460,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,72413461)
	e3:SetCondition(c72413460.thcon)
	e3:SetTarget(c72413460.thtg)
	e3:SetOperation(c72413460.thop)
	c:RegisterEffect(e3)
end
function c72413460.sfilter(c)
	return c:IsSetCard(0x5727)  and c:IsType(TYPE_SYNCHRO)
end
function c72413460.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc~=e:GetHandler() and tc:IsSummonType(SUMMON_TYPE_SYNCHRO) and tc:IsSummonPlayer(tp)
		and tc:IsAttribute(ATTRIBUTE_WATER)
end
function c72413460.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c72413460.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function c72413460.actlimit(e,re,tp)
	local loc=re:GetActivateLocation()
	local c=re:GetHandler()
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)  and c:GetSummonLocation()==LOCATION_EXTRA and c:IsLocation(LOCATION_MZONE) and c:GetAttackAnnouncedCount()==0
end

function c72413460.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) 
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function c72413460.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function c72413460.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72413460.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72413460.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72413460.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
