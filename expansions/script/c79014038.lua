--迷幻贝斯手
function c79014038.initial_effect(c) 
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c79014038.ttcon)
	e1:SetOperation(c79014038.ttop) 
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c79014038.setcon)
	c:RegisterEffect(e2) 
	--remove 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetTarget(c79014038.rmtg) 
	e1:SetOperation(c79014038.rmop) 
	c:RegisterEffect(e1) 
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE) 
	e2:SetCountLimit(1)
	e2:SetCondition(c79014038.atkcon)
	e2:SetCost(c79014038.atkcost)
	e2:SetOperation(c79014038.atkop)
	c:RegisterEffect(e2)
end 
function c79014038.sthfil(c) 
	return c:IsAbleToHandAsCost() and c:IsType(TYPE_SPIRIT) 
end 
function c79014038.ttcon(e,c,minc)
	if c==nil then return true end 
	local g=Duel.GetMatchingGroup(c79014038.sthfil,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c79014038.sthgck,3,3,tp)
end
function c79014038.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79014038.sthfil,tp,LOCATION_MZONE,0,nil)
	local sg=g:SelectSubGroup(tp,c79014038.sthgck,false,3,3,tp)
	Duel.SendtoHand(sg,nil,REASON_SUMMON+REASON_MATERIAL)
end
function c79014038.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c79014038.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,3,nil,POS_FACEDOWN) end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
end 
function c79014038.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,nil,POS_FACEDOWN) 
	if g:GetCount()>=3 then 
		local rg=g:RandomSelect(tp,3) 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	end
end 
function c79014038.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return true 
end 
function c79014038.pbfil(c) 
	return c:IsType(TYPE_SPIRIT) and not c:IsPublic()   
end  
function c79014038.atkcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c79014038.pbfil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79014038.pbfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)  
	e:SetLabel(g:GetCount())
end
function c79014038.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel()  
	if x>0 and Duel.Recover(tp,x*500,REASON_EFFECT)~=0 and c:IsRelateToBattle() and c:IsFaceup() then		 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(x*500) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end






