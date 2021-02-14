local m=15000339
local cm=_G["c"..m]
cm.name="真内核 鬼心川·失效"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,nil,1,4,cm.ovfilter,aux.Stringid(m,6),4,cm.xyzop)
	c:EnableReviveLimit()
	--Overlay(get)
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)  
	e1:SetCost(cm.ovcost) 
	e1:SetTarget(cm.ovtg)
	e1:SetOperation(cm.ovop) 
	c:RegisterEffect(e1)
	--Negate(get)
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetCountLimit(1)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCondition(cm.discon)  
	e2:SetCost(cm.discost)  
	e2:SetTarget(cm.distg)  
	e2:SetOperation(cm.disop)  
	c:RegisterEffect(e2) 
	--Overlay(self)
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)  
	e3:SetCost(cm.ov2cost) 
	e3:SetTarget(cm.ov2tg)
	e3:SetOperation(cm.ov2op) 
	c:RegisterEffect(e3)
	--battle  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)  
	e4:SetValue(1)  
	c:RegisterEffect(e4)  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_SINGLE)  
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e5:SetValue(1)  
	c:RegisterEffect(e5)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:GetRank()==1 and not c:IsCode(m)
end
function cm.xyzop(e,tp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,1,c) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()   
	if chk==0 then return c:GetOverlayGroup():GetCount()~=0 and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,15000340) and Duel.IsExistingTarget(Card.IsCanOverlay,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,Card.IsCanOverlay,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,1,1,c)  
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0) 
	end
end
function cm.ovop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then  
		local og=tc:GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,Group.FromCards(tc))  
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetOverlayGroup():GetCount()~=0 and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,15000341) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)  
end  
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)  
	if re:GetHandler():IsAbleToGrave() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)  
	end  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SendtoGrave(eg,REASON_EFFECT)  
	end  
end

function cm.ov2cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.ov2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()   
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsCanOverlay),tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_EXTRA,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanOverlay),tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_EXTRA,nil)
	if g:IsExists(Card.IsControler,1,nil,tp) and g:IsExists(Card.IsControler,1,nil,1-tp) then c:RegisterFlagEffect(15000339,RESET_CHAIN,0,1) end
	if g:IsExists(Card.IsControler,1,nil,tp) and not g:IsExists(Card.IsControler,1,nil,1-tp) then c:RegisterFlagEffect(15010339,RESET_CHAIN,0,1) end
	if g:IsExists(Card.IsControler,1,nil,1-tp) and not g:IsExists(Card.IsControler,1,nil,tp) then c:RegisterFlagEffect(15020339,RESET_CHAIN,0,1) end
end
function cm.ov2op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tp=c:GetControler() 
	if not c:IsFaceup() then return end
	local x=0
	if c:GetFlagEffect(15000339)~=0 then x=1 end
	if c:GetFlagEffect(15010339)~=0 then x=2 end
	if c:GetFlagEffect(15020339)~=0 then x=3 end
	local p=tp
	if x==1 then
		local y=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
		if y==0 then p=tp end
		if y==1 then p=1-tp end
	end
	if x==2 then p=tp end
	if x==3 then p=1-tp end
	if p==tp then
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsCanOverlay),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil):GetFirst()
		if c:IsFaceup() and not tc:IsImmuneToEffect(e) then  
			local og=tc:GetOverlayGroup()  
			if og:GetCount()>0 then  
				Duel.SendtoGrave(og,REASON_RULE)  
			end  
			Duel.Overlay(c,Group.FromCards(tc))  
		end
	end
	if p==1-tp then
		local tc=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanOverlay),tp,0,LOCATION_EXTRA,nil):RandomSelect(tp,1):GetFirst()
		if c:IsFaceup() then  
			Duel.Overlay(c,Group.FromCards(tc))  
			tc:CancelToGrave()
		end
	end
end