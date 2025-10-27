local m=15000069
local cm=_G["c"..m]
cm.name="色带神·克赛克修克鲁斯"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c)
	--change Pscale
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_CHANGE_LSCALE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.cpcon)
	e1:SetValue(cm.p1val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(cm.p2val)
	c:RegisterEffect(e2)
	--des
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_SPSUMMON_PROC)  
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e4:SetRange(LOCATION_HAND)  
	e4:SetCountLimit(1,m+1)  
	e4:SetCondition(cm.sd2con) 
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m+3)  
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
end
function cm.cpcon(e)  
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	return g:GetCount()~=0 and (g:GetFirst():GetLeftScale()~=e:GetHandler():GetLeftScale() or g:GetFirst():GetRightScale()~=e:GetHandler():GetRightScale())
end
function cm.p1val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x3f33) then return 4 end
	return tc:GetLeftScale()
end
function cm.p2val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x3f33) then return 4 end
	return tc:GetRightScale()
end
function cm.rpfilter(c,e,tp,b1,b2)
	return c:IsLevel(3) and c:IsSetCard(0xf33) and c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
		and (b1 or (b2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil,e,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)>0 and g:GetFirst():IsType(TYPE_PENDULUM) then
		local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Duel.SelectMatchingCard(tp,cm.rpfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp,b1,b2)
		local tc=g:GetFirst()
		if not tc then return end
		b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,0)},
		{b2,aux.Stringid(m,1)})
		if op==1 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.sd2filter(c)
	return c:IsSetCard(0x3f33) and c:IsFaceup()
end
function cm.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function cm.sd2con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(cm.sd2filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove() and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_CONTINUOUS))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and cm.filter(chkc) end
	local debug=1
	local o=0
	if debug==1 then o=LOCATION_ONFIELD end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,o,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,o,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end