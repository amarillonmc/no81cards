--祭礼游侠 露西·新叶
function c3060.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c3060.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3060,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,3060)
	e2:SetCondition(c3060.spcon)
	e2:SetOperation(c3060.spop)
	c:RegisterEffect(e2)
	--lv change and spsummon
	--[[local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3060,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,3061)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c3060.lvcost)
	e3:SetTarget(c3060.lvtg)
	e3:SetOperation(c3060.lvop)
	c:RegisterEffect(e3)]]--
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3060,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,3061)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c3060.spcost2)
	e3:SetTarget(c3060.sptg2)
	e3:SetOperation(c3060.spop2)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3060,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,3062)
	e4:SetCost(c3060.recost)
	e4:SetTarget(c3060.retg)
	e4:SetOperation(c3060.reop)
	c:RegisterEffect(e4)
end 
function c3060.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x851)
end
function c3060.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)
end
function c3060.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c3060.cfilter(c)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c3060.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3060.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c3060.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c3060.filter(c,e,tp)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3060.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3060.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
end
function c3060.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3060.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--[[function c3060.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3060.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c3060.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c3060.filter(c)
	return c:IsFaceup()
end
function c3060.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c3060.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c3060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local c=e:GetHandler()
		local val=Duel.GetMatchingGroupCount(c3060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*1
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,3061,0,0x851,0,800,-2,RACE_PLANT,ATTRIBUTE_EARTH) then return end
		local token=Duel.CreateToken(tp,3061)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(val)
		e2:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e2)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end 
end]]--
function c3060.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c3060.refilter(c,e,tp)
	return c:IsSetCard(0x851) and c:IsAbleToRemoveAsCost() 
end
function c3060.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3060.refilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c3060.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c3060.refilter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	--[[if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end]]--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	e1:SetCondition(c3060.thcon)
	e1:SetOperation(c3060.thop)
	e1:SetLabel(0)
	tg:RegisterEffect(e1)
end
function c3060.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c3060.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else e:SetLabel(1) end
end