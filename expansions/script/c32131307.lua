--空梦的凡人 帕朵菲莉丝
function c32131307.initial_effect(c)
	aux.AddCodeList(c,32131306)
	aux.AddMaterialCodeList(c,32131306)
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(32131306) 
	c:RegisterEffect(e0)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c32131307.lcheck)
	c:EnableReviveLimit()   
	--Draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,32131307) 
	e1:SetCondition(c32131307.drcon) 
	e1:SetCost(c32131307.drcost)
	e1:SetTarget(c32131307.drtg) 
	e1:SetOperation(c32131307.drop)  
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,23131307) 
	e2:SetCondition(c32131307.xdrcon)
	e2:SetTarget(c32131307.xdrtg)
	e2:SetOperation(c32131307.xdrop)
	c:RegisterEffect(e2)
end
c32131307.SetCard_HR_flame13=true 
c32131307.HR_Flame_CodeList=32131306 
function c32131307.lcheck(g)
	return g:IsExists(Card.IsLinkCode,1,nil,32131306)
end
function c32131307.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131307.drcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c32131307.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 
function c32131307.drcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end 
function c32131307.drtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function c32131307.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if Duel.IsPlayerCanDraw(tp,1) then 
	   Duel.Draw(tp,1,REASON_EFFECT) 
	   if tc:IsType(TYPE_MONSTER) then
	   if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(32131307,0)) then 
	   Duel.ConfirmCards(1-tp,tc) 
	   Duel.Draw(tp,1,REASON_EFFECT) 
	   end 
	   else 
	   Duel.SendtoDeck(tc,nil,1,REASON_EFFECT) 
	   end 
	end 
end 
function c32131307.xdrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c32131307.xdrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c32131307.xdrop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end




