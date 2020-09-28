--真红眼黑鳞兽
function c10700250.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3,c10700250.ovfilter,aux.Stringid(10700250,0),3,c10700250.xyzop)
	c:EnableReviveLimit() 
	--xyz
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e0:SetCondition(c10700250.xyzcon2)  
	e0:SetOperation(c10700250.xyzop2)  
	c:RegisterEffect(e0) 
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73964868,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c10700250.descost)
	e1:SetTarget(c10700250.destg)
	e1:SetOperation(c10700250.desop)
	c:RegisterEffect(e1) 
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c10700250.dcscon)
	e3:SetOperation(c10700250.dcsop)
	c:RegisterEffect(e3)
end
function c10700250.xyzcon2(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)  
end  
function c10700250.xyzop2(e,tp,eg,ep,ev,re,r,rp)  
	Debug.Message("被地狱之火环绕的邪恶之龙 展现完全姿态 逆转命运吧")
	Debug.Message("阶级8  真红眼黑鳞兽-深渊之龙！")
end
function c10700250.ovfilter(c)
	return c:IsFaceup() and c:IsRankBelow(7) and (c:IsSetCard(0x3b) or c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x3b))
end
function c10700250.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10700250)==0 end
	Duel.RegisterFlagEffect(tp,10700250,RESET_PHASE+PHASE_END,0,1)
end
function c10700250.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10700250.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c10700250.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   if Duel.Destroy(tc,REASON_EFFECT)>0 and tc:IsType(TYPE_MONSTER)  and tc:GetTextAttack()>0 then 
		 Duel.Damage(1-tp,math.floor(tc:GetBaseAttack()/2),REASON_EFFECT)
	   end
	end
end
function c10700250.desfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==1-tp 
end
function c10700250.dcscon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return eg:IsExists(c10700250.desfilter,1,nil,tp)
end
function c10700250.dcsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	local g=eg:Filter(c10700250.desfilter,nil,tp)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(c10700250.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetCondition(c10700250.discon)
		e3:SetOperation(c10700250.disop)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		tc=g:GetNext()
	end
end
function c10700250.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c10700250.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c10700250.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end