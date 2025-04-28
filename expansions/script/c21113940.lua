--芳青之梦 念夜绪
function c21113940.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc914),4,2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e0:SetCondition(c21113940.discon)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c21113940.con)
	e2:SetTarget(c21113940.splimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,21113940)
	e3:SetCost(c21113940.cost3)
	e3:SetTarget(c21113940.tg3)
	e3:SetOperation(c21113940.op3)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCost(c21113940.cost5)
	e5:SetOperation(c21113940.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(21113940,ACTIVITY_SPSUMMON,c21113940.counter)
	if not _c21113940 then
		_21113940 = true
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ce1:SetCode(EVENT_CHAINING)
	ce1:SetOperation(c21113940.op0)
	Duel.RegisterEffect(ce1,0)
	end	
end
function c21113940.op0(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local p=re:GetHandlerPlayer()
	if Duel.GetFlagEffect(p,21113940)<=5 then
	Duel.RegisterFlagEffect(p,21113940,RESET_PHASE+PHASE_END,0,1)
	end
end
function c21113940.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113940.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113940.con(e)
	local p=1-e:GetHandlerPlayer()
	return Duel.GetFlagEffect(p,21113940)<=4
end
function c21113940.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA+LOCATION_DECK)
end
function c21113940.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetOperation(c21113940.opq)
	Duel.RegisterEffect(e1,tp)
	c:CreateEffectRelation(e1)
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c21113940.q(c)
	return c:IsCanOverlay()
end
function c21113940.opq(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()	
	if c and c:IsFaceup() and c:IsRelateToEffect(e) and Duel.GetFlagEffect(tp,21113940+1)==0 and Duel.IsExistingMatchingCard(c21113940.q,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113940,0)) then
	Duel.Hint(3,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,c21113940.q,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil):GetFirst()
		if tc then 
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		end
	end
	Duel.ResetFlagEffect(tp,21113940)
	e:Reset()
end
function c21113940.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_EXTRA,0,1,nil) end
end
function c21113940.w(c)
	local atk=c:GetBaseAttack()
	local def=c:GetBaseDefense()
	return (atk+def)>0
end
function c21113940.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113940+1,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g<=0 then return end	
	Duel.ConfirmCards(tp,g)
	local rg=g:Filter(c21113940.w,nil)
	if #rg>0 then
	Duel.Hint(3,tp,HINTMSG_OPPO)
	local tc=rg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(10,1-tp,tc)
	local atk=tc:GetBaseAttack()
	local def=tc:GetBaseDefense()
		if Duel.Recover(tp,atk+def,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(21113940,1)) and Duel.DiscardHand(tp,nil,1,1,REASON_DISCARD+REASON_EFFECT,nil)>0 then
		Duel.BreakEffect()
		Duel.Destroy(tc,REASON_EFFECT)		
		end
	end
end
function c21113940.cost5(e,c,tp)
	return Duel.GetCustomActivityCount(21113940,tp,ACTIVITY_SPSUMMON)==0
end
function c21113940.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113940.ssplimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c21113940.ssplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end