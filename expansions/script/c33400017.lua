--时崎狂三 优雅大小姐
function c33400017.initial_effect(c)
	c:EnableCounterPermit(0x34f)
	 --counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(c33400017.adcost)
	e1:SetTarget(c33400017.addct)
	e1:SetOperation(c33400017.addc)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(33400017,ACTIVITY_SPSUMMON,c33400017.counterfilter)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33400017)
	e3:SetCost(c33400017.setcost)
	e3:SetTarget(c33400017.settg)
	e3:SetOperation(c33400017.setop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(33400017+10000,ACTIVITY_SPSUMMON,c33400017.setcfilter)

	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,33400017+10000)
	e4:SetTarget(c33400017.drtg)
	e4:SetOperation(c33400017.drop)
	c:RegisterEffect(e4)
end
function c33400017.counterfilter(c)
	return c:IsSetCard(0x341)
end
function c33400017.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33400017,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33400017.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c33400017.splimit(e,c)
	return not c:IsSetCard(0x341)
end
function c33400017.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x34f)
end
function c33400017.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34f,4)
	end
end
function c33400017.setcfilter(c)
	return not (c:IsType(TYPE_LINK) and c:IsLinkAbove(3) and c:GetSummonType()==SUMMON_TYPE_LINK) 
end
function c33400017.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST) and Duel.GetCustomActivityCount(33400017+10000,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33400017.splimit2)
	Duel.RegisterEffect(e1,tp)
end
function c33400017.splimit2(e,c,tp,sumtp,sumpos)
	return c:IsType(TYPE_LINK) and c:IsLinkAbove(3) and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c33400017.setfilter(c)
	return c:IsSetCard(0x3340) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and c:IsSSetable()
end
function c33400017.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400017.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c33400017.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c33400017.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33400017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33400017.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end