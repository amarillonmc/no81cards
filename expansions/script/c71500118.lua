--守护之风
function c71500118.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x78f1)
	--act in h
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(71500109,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c71500118.aihcost)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71500118+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(c71500118.cost)
	e1:SetTarget(c71500118.target)
	e1:SetOperation(c71500118.activate)
	c:RegisterEffect(e1)
	--sort decktop
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c71500118.thcost)
	e2:SetTarget(c71500118.thtg)
	e2:SetOperation(c71500118.thop)
	c:RegisterEffect(e2)
end 
function c71500118.pbfil(c)  
	return not c:IsPublic() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) 
end 
function c71500118.aihcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71500118.pbfil,tp,LOCATION_HAND,0,1,nil) end
	local pg=Duel.SelectMatchingCard(tp,c71500118.pbfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,pg) 
	Duel.ShuffleHand(tp) 
end
function c71500118.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x78f1,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x78f1,3,REASON_COST)
end 
function c71500118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c71500118.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--half damage
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c71500118.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE) 
	e1:SetCondition(c71500118.reccon)
	e1:SetOperation(c71500118.recop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then 
		--indes
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(function(e,c) 
		return c:GetCounter(0x78f1) end)
		e2:SetValue(1) 
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)  
	end 
end
function c71500118.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then 
		return val/2 
	end
	return val
end
function c71500118.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c71500118.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,71500118) 
	Duel.Recover(tp,ev/2,REASON_EFFECT) 
end
function c71500118.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x78f1,1,REASON_COST) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1) 
	Duel.RemoveCounter(tp,1,1,0x78f1,1,REASON_COST) 
end
function c71500118.sthfil(c) 
	return c:IsAbleToHand() and (aux.IsSetNameMonsterListed(c,0x78f1) and c:IsType(TYPE_SPELL+TYPE_TRAP)) 
end 
function c71500118.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71500118.sthfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end
function c71500118.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,c71500118.sthfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if tc then 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc) 
	end 
end 

