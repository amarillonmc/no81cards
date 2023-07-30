--咒箱女王·娜哈特·娜哈特
function c11560323.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,function(c) return c.SetCard_XdMcy end,8,3) 
	c:EnableReviveLimit() 
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)   
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCountLimit(1,11560323+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c11560323.xxcon) 
	e1:SetOperation(c11560323.xxop) 
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21560323)
	e2:SetTarget(c11560323.rmtg)
	e2:SetOperation(c11560323.rmop)
	c:RegisterEffect(e2)
end
c11560323.SetCard_XdMcy=true  
function c11560323.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()	
end 
function c11560323.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.ConfirmCards(1-tp,c) 
	Duel.Hint(HINT_CARD,0,11560323) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_REMOVE) 
	e1:SetRange(0xff) 
	e1:SetOperation(c11560323.imop) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e2:SetTargetRange(0xff,0) 
	e2:SetTarget(function(e,c) 
	return c:IsType(TYPE_MONSTER) and c.SetCard_XdMcy end)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end  
function c11560323.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end  
function c11560323.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	end 
end 
function c11560323.imop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetRange(0xff)
	e1:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end)  
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
end 







