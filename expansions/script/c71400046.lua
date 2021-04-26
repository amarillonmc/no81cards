--黑白异梦少女-黑白江
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400046.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,yume.YumeCheck(c),aux.NonTuner(yume.YumeCheck(c)),1)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400046,0))
	e1:SetCountLimit(1,71400046)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c71400046.con1)
	e1:SetTarget(c71400046.tg1)
	e1:SetOperation(c71400046.op1)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c71400046.val)
	c:RegisterEffect(e2)
	--self banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400046,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCondition(c71400046.con3)
	e3:SetTarget(c71400046.tg3)
	e3:SetOperation(c71400046.op3)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3a)
end
function c71400046.filter1(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsAbleToDeck() and c:IsLocation(LOCATION_MZONE)
end
function c71400046.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c71400046.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c71400046.filter1,nil,tp)
	local ct=g:GetCount()
	if chk==0 then return ct>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,ct,0,0)
end
function c71400046.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c71400046.filter1,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c71400046.val(e,c)
	return Duel.GetMatchingGroupCount(c71400046.filter2,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)*300
end
function c71400046.filter2(c)
	return c:IsSetCard(0x717) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c71400046.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c71400046.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c71400046.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c71400046.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c71400046.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end