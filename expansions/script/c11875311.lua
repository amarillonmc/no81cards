--回声纹章士 阿鲁姆
function c11875311.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11875300,aux.FilterBoolFunction(function(c) return c.SetCard_tt_FireEmblem end),1,true,true) 
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE+LOCATION_HAND,0,Duel.Release,REASON_COST+REASON_MATERIAL) 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION end) 
	c:RegisterEffect(e1) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(function(e,c)
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	c:RegisterEffect(e1)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE) 
	e1:SetTarget(function(e,c) 
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	e1:SetValue(function(e,c)
	return c==e:GetHandler() end)
	c:RegisterEffect(e1) 
	--to grave 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11875311,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_MOVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11875311)  
	e2:SetCondition(c11875311.tgcon)
	e2:SetTarget(c11875311.tgtg)  
	e2:SetOperation(c11875311.tgop) 
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(function(e,c)
	return c:IsType(TYPE_MONSTER) and c.SetCard_tt_FireEmblem and c:GetEquipGroup():IsContains(e:GetHandler()) end) 
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
end
c11875311.SetCard_tt_FireEmblem=true   
function c11875311.mckfil(c) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_ONFIELD)  
end 
function c11875311.tgcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c11875311.mckfil,1,nil)  
end 
function c11875311.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c11875311.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c11875311.xtgcon)
	e1:SetOperation(c11875311.xtgop) 
	Duel.RegisterEffect(e1,tp)
end 
function c11875311.xtgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel() 
end 
function c11875311.xtgop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset() 
	if Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) then  
		Duel.Hint(HINT_CARD,0,11875311)   
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT)   
	end 
end 







