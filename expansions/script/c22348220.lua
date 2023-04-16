--祭 铜 的 祈 祷 者
local m=22348220
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL))
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348220,0))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348220.sumcon)
	e1:SetTarget(c22348220.sumtg)
	e1:SetOperation(c22348220.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348220,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c22348220.thcost)
	e3:SetTarget(c22348220.thtg)
	e3:SetOperation(c22348220.thop)
	c:RegisterEffect(e3)
	
end
function c22348220.hdfilter(c)
	return bit.band(c:GetSummonLocation(),LOCATION_HAND)~=0
end
function c22348220.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:IsExists(c22348220.hdfilter,1,nil)
end
function c22348220.smfilter(c,lscale,rscale)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x708) and c:IsAbleToHand() and lv>lscale and lv<rscale
end
function c22348220.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if chk==0 then
	if rpz==nil or lpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	return Duel.IsExistingMatchingCard(c22348220.smfilter,tp,LOCATION_EXTRA,0,1,nil,lscale,rscale)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c22348220.smmfilter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function c22348220.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local counta=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348220.smfilter,tp,LOCATION_EXTRA,0,1,1,nil,lscale,rscale)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,tc)
		if Duel.SelectYesNo(tp,aux.Stringid(22348220,2)) and Duel.IsExistingMatchingCard(c22348220.smmfilter,tp,LOCATION_HAND,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tg=Duel.SelectMatchingCard(tp,c22348220.smmfilter,tp,LOCATION_HAND,0,1,1,nil)
	local ttc=tg:GetFirst()
	if ttc then
		local s1=ttc:IsSummonable(true,nil,1)
		local s2=ttc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,ttc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,ttc,true,nil,1)
		else
			Duel.MSet(tp,ttc,true,nil,1)
		end
	end
	end
	end
end
function c22348220.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c22348220.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c22348220.thfilter(c,lscale,rscale)
	return c:IsSetCard(0x708) and c:IsAbleToHand()
end
function c22348220.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-400)
		tc:RegisterEffect(e1)
	end
		local g=Duel.GetMatchingGroup(c22348220.thfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22348220,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g=g:Select(tp,1,1,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
end
