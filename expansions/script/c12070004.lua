--永燃的薪炎 烈焰圣歌的誓约
function c12070004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,12070004)
	e1:SetCost(c12070004.cost)
	e1:SetTarget(c12070004.target)
	e1:SetOperation(c12070004.operation)
	c:RegisterEffect(e1)	 
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c12070004.reptg)
	c:RegisterEffect(e2)	
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c12070004.atkcon)
	e3:SetValue(c12070004.atkval) 
	c:RegisterEffect(e3)
end  
c12070004.SetCard_NeoK_Flame=true 
function c12070004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c12070004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c12070004.filter(c)
	return c.SetCard_NeoK_Flame and c:IsAbleToHand() 
end
function c12070004.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5) 
	local g=Duel.GetDecktopGroup(tp,5):Filter(c12070004.filter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12070004,0)) then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)  
	end
	Duel.ShuffleDeck(tp)
end 
function c12070004.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end 
function c12070004.atkcon(e) 
	local tp=e:GetHandlerPlayer() 
	return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) and Duel.GetLP(tp)<=Duel.GetLP(1-tp) 
end 
function c12070004.atkval(e,c)
	return c:GetOverlayCount()*500
end







