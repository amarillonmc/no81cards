local m=82224036
local cm=_G["c"..m]
cm.name="天启帝君"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),4)  
	c:EnableReviveLimit() 
	--remove from hand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_TO_HAND)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCondition(cm.hdcon)  
	e1:SetTarget(cm.hdtg)  
	e1:SetOperation(cm.hdop)  
	c:RegisterEffect(e1) 
	--remove from decktop 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetOperation(cm.regop)  
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_CHAIN_SOLVED)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCondition(cm.rmcon)  
	e3:SetOperation(cm.rmop)  
	c:RegisterEffect(e3) 
	--atk up  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e4:SetCode(EFFECT_UPDATE_ATTACK)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetValue(cm.val)  
	c:RegisterEffect(e4)
	--cannot target  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_SINGLE)  
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetCondition(cm.con)
	e5:SetValue(aux.tgoval)  
	c:RegisterEffect(e5)  
	--indes  
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_SINGLE)  
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.con)  
	e6:SetValue(aux.indoval)  
	c:RegisterEffect(e6)
	--remove from field  
	local e7=Effect.CreateEffect(c)  
	e7:SetDescription(aux.Stringid(m,1))  
	e7:SetCategory(CATEGORY_REMOVE)  
	e7:SetType(EFFECT_TYPE_QUICK_O)  
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e7:SetCode(EVENT_FREE_CHAIN)  
	e7:SetRange(LOCATION_MZONE)  
	e7:SetCountLimit(1)  
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e7:SetCondition(cm.rmcon2)
	e7:SetTarget(cm.rmtg2)  
	e7:SetOperation(cm.rmop2)  
	c:RegisterEffect(e7) 
end
function cm.cfilter(c,tp)  
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)  
end  
function cm.hdcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(cm.cfilter,1,nil,1-tp)  
end  
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)  
end  
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)  
	if g:GetCount()>0 then  
		local sg=g:RandomSelect(tp,1)  
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)  
	end  
end  
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	if rp==tp then return end  
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)  
end  
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return ep~=tp and c:GetFlagEffect(m)~=0  
end  
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_CARD,0,m)  
	local g=Duel.GetDecktopGroup(1-tp,2) 
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end  
function cm.val(e,c,tp)  
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)*100  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil) 
	return tc>=5
end
function cm.rmcon2(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil) 
	return tc>=10
end
function cm.rmfilter2(c)  
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)  
end
function cm.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter2,tp,0,LOCATION_ONFIELD,1,nil) end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectTarget(tp,cm.rmfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)  
end  
function cm.rmop2(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)  
	end  
end