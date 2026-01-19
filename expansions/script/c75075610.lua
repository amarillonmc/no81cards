--噩梦的女王 神阶芙蕾娜
function c75075610.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c75075610.filter0,2,127,true)
    --cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c75075610.con1)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
    local e3=e1:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetValue(c75075610.val1)
	c:RegisterEffect(e4)
    --synchro summon success
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(75075610,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,75075608)
    e5:SetTarget(c75075610.con5)
    e5:SetCost(c75075610.cost5)
	e5:SetOperation(c75075610.op5)
	c:RegisterEffect(e5)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(75075610,1))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,75075609)
	e6:SetCost(c75075610.cost6)
	e6:SetTarget(c75075610.tg6)
	e6:SetOperation(c75075610.op6)
	c:RegisterEffect(e6)
    --play fieldspell
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(75075610,2))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,75075610)
	e7:SetCost(c75075610.cost7)
	e7:SetTarget(c75075610.tg7)
	e7:SetOperation(c75075610.op7)
	c:RegisterEffect(e7)
end
-- 融合
function c75075610.filter0(c,fc)
	return c:IsFusionSetCard(0x5754)
end
-- 1
function c75075610.filter1(c,tp)
	return Duel.GetFieldCard(tp,LOCATION_FZONE,0)~=nil
end
function c75075610.con1(e)
	return Duel.IsExistingMatchingCard(c75075610.filter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c75075610.val1(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end
-- 2
function c75075610.con5(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c75075610.costfilter5(c)
	return c:IsAbleToGraveAsCost()
end
function c75075610.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75075610.costfilter5,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75075610.costfilter5,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c75075610.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
-- 3
function c75075610.filter6(c,ft,tp)
	return c:IsSetCard(0x5754)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c75075610.filter66(c)
    return c:IsFaceup() and c:IsAbleToRemove() and not c:IsAttack(c:GetBaseAttack())
end
function c75075610.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        return Duel.IsExistingMatchingCard(c75075610.filter66,tp,0,LOCATION_MZONE,1,nil) 
    end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end
function c75075610.op6(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c75075610.filter66,tp,0,LOCATION_MZONE,1,1,nil)
    if #g>0 then
        Duel.HintSelection(g)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
-- 4
function c75075610.cost7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c75075610.filter7(c,tp)
	return c:IsSetCard(0x5754) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true) and c:IsType(TYPE_FIELD)
end
function c75075610.tg7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75075610.filter7,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function c75075610.op7(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75075610.filter7),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local field=tc:IsType(TYPE_FIELD)
		if field then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		if field then
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
