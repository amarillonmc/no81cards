--幻殇·辉骑
function c11180031.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3450),10,true)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c11180031.hspcon)
	e1:SetTarget(c11180031.hsptg)
	e1:SetOperation(c11180031.hspop)
	c:RegisterEffect(e1)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11180031,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetTarget(c11180031.pctg)
	e1:SetOperation(c11180031.pcop)
	c:RegisterEffect(e1)
	--copy self trap
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)   
	e2:SetCondition(c11180031.cpcon)
	e2:SetTarget(c11180031.cptg)
	e2:SetOperation(c11180031.cpop)
	c:RegisterEffect(e2)
	local e3=e2:Clone() 
	e3:SetCode(EVENT_REMOVE) 
	c:RegisterEffect(e3) 
	--lv  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11180031.lvtg)
	e1:SetOperation(c11180031.lvop)
	c:RegisterEffect(e1)
end 
function c11180031.spctfil(c,tp) 
	if not ((c:IsAbleToRemoveAsCost() or c:IsAbleToGraveAsCost()) and c:IsSetCard(0x3450,0x6450)) then return false end 
	return c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) or c:IsFaceup()
end
function c11180031.spctgck(g,e,tp) 
	return g:FilterCount(Card.IsSetCard,nil,0x3450)==1 
	   and g:FilterCount(Card.IsSetCard,nil,0x6450)==1 
	   and Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0 
end 
function c11180031.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c11180031.spctfil,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c11180031.spctgck,2,2,e,tp)
end
function c11180031.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c11180031.spctfil,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local sg=g:SelectSubGroup(tp,c11180031.spctgck,true,2,2,e,tp)
	if sg then 
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11180031.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject() 
	local tc=g:GetFirst() 
	while tc do  
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	tc=g:GetNext() 
	end  
end
function c11180031.pcfilter(c)
	return c:IsSetCard(0x3450) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c11180031.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c11180031.pcfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c11180031.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c11180031.pcfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(11180031,0)) then
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end 
function c11180031.cpcon(e,tp,eg,ep,ev,re,r,rp) 
	local rc=e:GetHandler():GetReasonCard()
	return rc:IsSetCard(0x3450,0x6450) and c:IsPreviousLocation(LOCATION_ONFIELD)
end 
function c11180031.cpfil(c)
	return c:IsSetCard(0x6450) and (c:IsType(TYPE_SPELL) or c:GetType()==TYPE_TRAP) and c:CheckActivateEffect(false,true,false)~=nil
end
function c11180031.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c11180031.filter,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11180031.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c11180031.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local tc=te:GetHandler()
	if not (tc:IsRelateToEffect(e)) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c11180031.filter(c)
	return c:IsFaceup() and c:GetLevel()>0  
end
function c11180031.lvtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11180031.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
end
function c11180031.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c11180031.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then 
		local op=0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		if tc:IsLevel(1) then
			op=Duel.SelectOption(tp,aux.Stringid(11180031,1))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(11180031,1),aux.Stringid(11180031,2))+1
		end 
		if op==1 then 
			lv=Duel.AnnounceLevel(tp,1,10)
		elseif op==2 then 
			local x=tc:GetLevel()-1
			if x>10 then x=10 end 
			lv=Duel.AnnounceLevel(tp,1,x) 
			lv=-lv
		end 
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
	end
end





