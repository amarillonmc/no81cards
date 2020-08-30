function c82228514.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x291),8,3)  
	c:EnableReviveLimit()
	--ri yue gui hun guang
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228514,0)) 
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)   
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e1:SetCountLimit(1,82228514+EFFECT_COUNT_CODE_DUEL)  
	e1:SetCondition(c82228514.con)
	e1:SetCost(c82228514.cost)
	e1:SetTarget(c82228514.tg)
	e1:SetOperation(c82228514.op)  
	c:RegisterEffect(e1)  
end
function c82228514.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x291)  and Duel.GetLP(1-tp)>3500
end
function c82228514.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=e:GetHandler():GetOverlayGroup()
	local ct=g:GetCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
end  
function c82228514.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLP(1-tp)>3500 end  
	Duel.SetTargetPlayer(1-tp) 
end  
function c82228514.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	if Duel.GetLP(p)>3500 then
	Duel.SetLP(p,3500)
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CHANGE_DAMAGE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(0,1) 
	e1:SetValue(c82228514.damval)  
	e1:SetReset(RESET_PHASE+PHASE_END,3)  
	Duel.RegisterEffect(e1,tp)  
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)  
	e2:SetReset(RESET_PHASE+PHASE_END,3)  
	Duel.RegisterEffect(e2,tp)  
	end
end
function c82228514.damval(e,re,val,r,rp,rc)  
	if bit.band(r,REASON_EFFECT)~=0 then return 0  
	else return val end  
end  
	