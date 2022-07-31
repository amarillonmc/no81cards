--虚无世界的世界
function c6160303.initial_effect(c)
	c:SetUniqueOnField(1,0,6160303)
	--xyz limit  
	c:EnableReviveLimit() 
	--Attribute Dark  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetValue(ATTRIBUTE_DARK)  
	c:RegisterEffect(e2) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(c6160303.indcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3) 
	--activate cost  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c6160303.accon)
	e4:SetCost(c6160303.accost)
	e4:SetOperation(c6160303.acop)
	c:RegisterEffect(e4)
	--copy  
	local e6=Effect.CreateEffect(c)  
	e6:SetDescription(aux.Stringid(6160303,1))  
	e6:SetType(EFFECT_TYPE_QUICK_O) 
	e6:SetCode(EVENT_FREE_CHAIN) 
	e6:SetRange(LOCATION_MZONE)  
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e6:SetCountLimit(1) 
	e6:SetCost(c6160303.cocost) 
	e6:SetTarget(c6160303.copytg)  
	e6:SetOperation(c6160303.copyop)  
	c:RegisterEffect(e6)
end
function c6160303.indcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c6160303.accon(e)  
	c6160303[0]=false  
	return true  
end  
function c6160303.acfilter(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()  
end 
function c6160303.accost(e,te,tp)  
	return Duel.IsExistingMatchingCard(c6160303.acfilter,tp,LOCATION_DECK,0,2,nil)  
end  
function c6160303.acop(e,tp,eg,ep,ev,re,r,rp)  
	if c6160303[0] then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,c6160303.acfilter,tp,LOCATION_DECK,0,2,2,nil)  
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)  
	c6160303[0]=true  
end  
function c6160303.cocost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function c6160303.filter(c)  
	return c:IsSetCard(0x616) and c:IsType(TYPE_MONSTER)  
end  
function c6160303.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c6160303.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c6160303.filter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	Duel.SelectTarget(tp,c6160303.filter,tp,LOCATION_GRAVE,0,1,1,nil)  
end  
function c6160303.copyop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then  
		local code=tc:GetOriginalCode()  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_CODE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetValue(code)  
		e1:SetLabel(tp)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		c:RegisterEffect(e1)  
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)  
		local e2=Effect.CreateEffect(c)  
		e2:SetDescription(aux.Stringid(6160303,2))  
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)   
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
		e2:SetRange(LOCATION_MZONE)  
		e2:SetCondition(c6160303.rstcon)  
		e2:SetOperation(c6160303.rstop)  
		e2:SetLabel(cid)  
		e2:SetLabelObject(e1)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		c:RegisterEffect(e2)  
	end  
end  
function c6160303.rstcon(e,tp,eg,ep,ev,re,r,rp)  
	local e1=e:GetLabelObject()  
	return Duel.GetTurnPlayer()~=e1:GetLabel()  
end  
function c6160303.rstop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local cid=e:GetLabel()  
	c:ResetEffect(cid,RESET_COPY)  
	local e1=e:GetLabelObject()  
	e1:Reset()  
	Duel.HintSelection(Group.FromCards(c))  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())  
end  