--俱舍怒威族·芬里尔狼 “狂野突袭”
function c87493030.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,3)
	c:EnableReviveLimit()  
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetValue(SUMMON_TYPE_XYZ) 
	e1:SetCountLimit(1,87493030+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c87493030.hspcon)
	e1:SetOperation(c87493030.hspop)
	c:RegisterEffect(e1)
	--remove 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c87493030.rmcon)
	e2:SetOperation(c87493030.rmop)
	c:RegisterEffect(e2)
	--up 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87493030,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c87493030.upcon)
	e3:SetTarget(c87493030.uptg)
	e3:SetOperation(c87493030.upop)
	c:RegisterEffect(e3) 
	--remove 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e4:SetCountLimit(1,17493030)
	e4:SetCost(c87493030.xrmcost)
	e4:SetTarget(c87493030.xrmtg)
	e4:SetOperation(c87493030.xrmop) 
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_REMOVE) 
	e5:SetType(EFFECT_TYPE_QUICK_O) 
	e5:SetCode(EVENT_CHAINING) 
	e5:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP) 
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCountLimit(1,17493030)
	e5:SetCondition(c87493030.xrmcon)  
	e5:SetCost(c87493030.xrmcost)
	e5:SetTarget(c87493030.xrmtg)
	e5:SetOperation(c87493030.xrmop) 
	c:RegisterEffect(e5) 
	if not c87493030.global_check then
		c87493030.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING) 
		ge1:SetCondition(c87493030.checkcon)
		ge1:SetOperation(c87493030.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c87493030.checkcon(e,tp,eg,ep,ev,re,r,rp)  
	return re:GetHandler():IsCode(32909498)   
end 
function c87493030.checkop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.RegisterFlagEffect(1-rp,32909498,RESET_PHASE+PHASE_END,0,1) 
	Duel.RegisterFlagEffect(rp,32909498,RESET_PHASE+PHASE_END,0,1) 
end 
function c87493030.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	return Duel.GetFlagEffect(tp,87493030)~=0 and Duel.SelectMatchingCard(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,5,nil) 
end
function c87493030.hspop(e,tp,eg,ep,ev,re,r,rp,c) 
	local tp=c:GetControler() 
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,5,5,nil) 
	Duel.Overlay(c,g) 
end
function c87493030.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle() and e:GetHandler():IsFaceup()
end
function c87493030.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	Duel.Remove(bc,POS_FACEDOWN,REASON_EFFECT) 
end 
function c87493030.cpfil(c)
	return not c:IsType(TYPE_TOKEN)
end
function c87493030.upcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c87493030.cpfil,1,nil)
end
function c87493030.uptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(87493030)==0 end 
	c:RegisterFlagEffect(87493030,RESET_CHAIN,0,1) 
end
function c87493030.upop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=eg:FilterCount(c87493030.cpfil,nil) 
	local ph=Duel.GetCurrentPhase() 
	if c:IsRelateToEffect(e) and x>0 then
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(x*400) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)   
	c:RegisterEffect(e1) 
	if (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1) 
	end 
	end
end 
function c87493030.xrmcon(e,tp,eg,ep,ev,re,r,rp) 
	return re:IsActiveType(TYPE_MONSTER)	  
end  
function c87493030.xrmcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST) 
end 
function c87493030.xrmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,POS_FACEDOWN) end 
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil,POS_FACEDOWN) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
end 
function c87493030.xrmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT) 
	end 
end 





















