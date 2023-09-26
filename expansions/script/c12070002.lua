--永燃的薪炎 遗世火鸟的燃羽
function c12070002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,12070002)
	e1:SetCost(c12070002.cost)
	e1:SetTarget(c12070002.target)
	e1:SetOperation(c12070002.operation)
	c:RegisterEffect(e1)	
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12070002,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCost(c12070002.rmcost)
	e2:SetTarget(c12070002.rmtg)
	e2:SetOperation(c12070002.rmop)
	c:RegisterEffect(e2) 
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c12070002.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c12070002.damcon)
	e4:SetOperation(c12070002.damop)
	c:RegisterEffect(e4)
end  
c12070002.SetCard_NeoK_Flame=true 
function c12070002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c12070002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c12070002.filter(c)
	return c.SetCard_NeoK_Flame and c:IsAbleToHand() 
end
function c12070002.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5) 
	local g=Duel.GetDecktopGroup(tp,5):Filter(c12070002.filter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12070002,0)) then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)  
	end
	Duel.ShuffleDeck(tp)
end 
function c12070002.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12070002.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and c:IsAbleToRemove() and c:GetFlagEffect(12070002)==0 and Duel.IsPlayerCanDraw(tp,1) end 
	c:RegisterFlagEffect(12070002,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end
function c12070002.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then 
		local pos=c:GetPosition()
		Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c) 
		e1:SetLabel(pos)
		e1:SetCountLimit(1)
		e1:SetOperation(c12070002.xretop)
		Duel.RegisterEffect(e1,tp)
		if Duel.IsPlayerCanDraw(tp,1) then 
		Duel.BreakEffect() 
		Duel.Draw(tp,1,REASON_EFFECT)
		end 
	end
end 
function c12070002.xretop(e,tp,eg,ep,ev,re,r,rp) 
	local pos=e:GetLabel()
	Duel.Hint(HINT_CARD,0,12070002)  
	Duel.MoveToField(e:GetLabelObject(),tp,tp,LOCATION_MZONE,pos,true)
end
function c12070002.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(12070002,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c12070002.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(12070002)~=0 and e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ)
end
function c12070002.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,12070002)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end






