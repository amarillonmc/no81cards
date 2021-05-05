--传说究极异兽-光辉之奈克洛兹玛
function c40008620.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,6,c40008620.ovfilter,aux.Stringid(40008620,0),6,c40008620.xyzop)
	c:EnableReviveLimit()  
	--effect gian
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c40008620.efop)
	c:RegisterEffect(e1) 
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c40008620.efilter)
	c:RegisterEffect(e3) 
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008620,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c40008620.rcon)
	e2:SetOperation(c40008620.rop)
	c:RegisterEffect(e2)
end
function c40008620.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
		and re:GetHandler():GetOverlayCount()>=ev-1
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) and ep==e:GetOwnerPlayer()
end
function c40008620.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40008620,2))
	local g=Duel.GetDecktopGroup(tp,1)
	local ct=bit.band(ev,0xffff)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	if ct>1 then
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
end
function c40008620.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c40008620.ovfilter(c)
	return c:IsFaceup() and c:IsCode(40008617) and (c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,40008618) or c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,40008619))
end
function c40008620.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008620)==0 end
	Duel.RegisterFlagEffect(tp,40008620,RESET_PHASE+PHASE_END,0,1)
end
function c40008620.effilter(c)
	return c:IsType(TYPE_MONSTER) 
end
function c40008620.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local ct=c:GetOverlayGroup(tp,1,0)
	local wg=ct:Filter(c40008620.effilter,nil,tp)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
		end 
		wbc=wg:GetNext()
	end  
end