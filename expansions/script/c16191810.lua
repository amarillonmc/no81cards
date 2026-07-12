--此碑乃界-虎·伏·龙·潜
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--连接召唤	
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsDefensePos),4,4)
    c:EnableReviveLimit()
	--抗性    
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.immcon)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--选择效果发动    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.efcon)
    e2:SetTarget(s.eftg)
	e2:SetOperation(s.efop)
	c:RegisterEffect(e2)
	--攻守上升	
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
function s.immcon(e)
	return Duel.GetMatchingGroupCount(Card.IsDefensePos,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)>0
end    
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_DEFENSE) and c:GetReasonPlayer()==1-tp
		and not c:IsReason(REASON_RULE)
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.posfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
    local b2=Duel.IsPlayerCanDraw(tp,1)
    local b3=Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return (b1 or b2 or b3) end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2),1},
		{b2,aux.Stringid(id,3),2},
        {b3,aux.Stringid(id,4),3})
	e:SetLabel(op)
    if op==1 then
    	e:SetCategory(CATEGORY_TOGRAVE)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
    elseif op==2 then
    	e:SetCategory(CATEGORY_DRAW)
        Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    elseif op==3 then
    	e:SetCategory(CATEGORY_POSITION)
    	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,PLAYER_ALL,LOCATION_MZONE)
    end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
    if op==1 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
            Duel.SendtoGrave(g,REASON_EFFECT)
    	end
    elseif op==2 then
    	Duel.Draw(tp,1,REASON_EFFECT)    
    elseif op==3 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=Duel.SelectMatchingCard(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if sg:GetCount()>0 then
			Duel.HintSelection(sg)
            Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
    	end
    end
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local ct=Duel.GetMatchingGroupCount(Card.IsDefensePos,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if c:IsRelateToEffect(e) and c:IsFaceup() then
    	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(ct*500)
		c:RegisterEffect(e1)
    end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct*500)
		tc:RegisterEffect(e1)
	end    
end