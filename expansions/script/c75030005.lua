--苍炎解放者 艾琳西亚
function c75030005.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),4,2)
	c:EnableReviveLimit()
	--ov  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75030005)
	e1:SetCondition(function(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e1:SetTarget(c75030005.ovtg)
	e1:SetOperation(c75030005.ovop)
	c:RegisterEffect(e1)
	--rec 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,25030005)
	e2:SetTarget(c75030005.rectg)
	e2:SetOperation(c75030005.recop)
	c:RegisterEffect(e2)
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15030005+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75030005)>=6 end)
	e2:SetTarget(c75030005.xxtg)
	e2:SetOperation(c75030005.xxop)
	c:RegisterEffect(e2)
	if not c75030005.global_check then
		c75030005.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c75030005.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c75030005.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsSetCard(0x5751) then
		Duel.RegisterFlagEffect(tc:GetControler(),75030005,0,0,1)
	end
end
function c75030005.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,nil) end
end
function c75030005.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if c:IsRelateToEffect(e) and g:GetCount()>=2 then
		local og=g:Select(tp,2,2,nil)
		Duel.Overlay(c,og)
	end
end
function c75030005.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local x=e:GetHandler():RemoveOverlayCard(tp,1,99,REASON_COST)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(x*1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,x*1000)
end
function c75030005.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c75030005.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c75030005.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75030005,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(75030005)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	--draw count
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	Duel.RegisterEffect(e2,tp)
end




