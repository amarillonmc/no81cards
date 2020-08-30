local m=82228605
local cm=_G["c"..m]
cm.name="荒兽 戾"
function cm.initial_effect(c)
	--atk&def down  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1) 
	--activate limit  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetHintTiming(0,TIMING_DRAW_PHASE)  
	e2:SetCountLimit(1)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)  
	e2:SetOperation(cm.operation)  
	c:RegisterEffect(e2)  
end
function cm.filter(c)  
	return c:IsFaceup()  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(-1000)  
		e1:SetReset(RESET_EVENT+0x1fe0000)  
		tc:RegisterEffect(e1)  
		local e2=e1:Clone()  
		e2:SetCode(EFFECT_UPDATE_DEFENSE)  
		tc:RegisterEffect(e2)  
	end  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSetCard(0x2299)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end 
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	--cannot remove  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_CANNOT_REMOVE)   
	e4:SetTargetRange(LOCATION_GRAVE,0)  
	e4:SetCondition(cm.contp)  
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)  
	local e5=e4:Clone()  
	e5:SetTargetRange(0,LOCATION_GRAVE)  
	e5:SetCondition(cm.conntp)  
	Duel.RegisterEffect(e5,tp)   
	--necro valley  
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_FIELD)  
	e6:SetCode(EFFECT_NECRO_VALLEY) 
	e6:SetTargetRange(LOCATION_GRAVE,0)  
	e6:SetCondition(cm.contp)  
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp) 
	local e7=e6:Clone()  
	e7:SetTargetRange(0,LOCATION_GRAVE)  
	e7:SetCondition(cm.conntp)  
	Duel.RegisterEffect(e7,tp)  
	local e8=Effect.CreateEffect(c)  
	e8:SetType(EFFECT_TYPE_FIELD)  
	e8:SetCode(EFFECT_NECRO_VALLEY)  
	e8:SetRange(LOCATION_FZONE)  
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e8:SetTargetRange(1,0)  
	e8:SetCondition(cm.contp)  
	Duel.RegisterEffect(e8,tp)  
	local e9=e8:Clone()  
	e9:SetTargetRange(0,1)  
	e9:SetCondition(cm.conntp)  
	Duel.RegisterEffect(e9,tp)  
	--disable  
	local e10=Effect.CreateEffect(c)  
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e10:SetCode(EVENT_CHAIN_SOLVING)  
	e10:SetOperation(cm.disop)  
	e10:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e10,tp) 
end
function cm.contp(e)  
	return not Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),EFFECT_NECRO_VALLEY_IM)  
end  
function cm.conntp(e)  
	return not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_NECRO_VALLEY_IM)  
end  
function cm.disfilter(c,im0,im1)  
	if c:IsControler(0) then return im0 and c:IsHasEffect(EFFECT_NECRO_VALLEY)  
	else return im1 and c:IsHasEffect(EFFECT_NECRO_VALLEY) end  
end  
function cm.discheck(ev,category,re,im0,im1)  
	local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,category)  
	if not ex then return false end  
	if v==LOCATION_GRAVE then  
		if p==0 then return im0  
		elseif p==1 then return im1  
		elseif p==PLAYER_ALL then return im0 and im1  
		end  
	end  
	if tg and tg:GetCount()>0 then  
		return tg:IsExists(cm.disfilter,1,nil,im0,im1)  
	end  
	return false  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=re:GetHandler()  
	if not Duel.IsChainDisablable(ev) or tc:IsHasEffect(EFFECT_NECRO_VALLEY_IM) then return end  
	local res=false  
	local im0=not Duel.IsPlayerAffectedByEffect(0,EFFECT_NECRO_VALLEY_IM)  
	local im1=not Duel.IsPlayerAffectedByEffect(1,EFFECT_NECRO_VALLEY_IM)  
	if not res and cm.discheck(ev,CATEGORY_SPECIAL_SUMMON,re,im0,im1) then res=true end  
	if not res and cm.discheck(ev,CATEGORY_REMOVE,re,im0,im1) then res=true end  
	if not res and cm.discheck(ev,CATEGORY_TOHAND,re,im0,im1) then res=true end  
	if not res and cm.discheck(ev,CATEGORY_TODECK,re,im0,im1) then res=true end  
	if not res and cm.discheck(ev,CATEGORY_TOEXTRA,re,im0,im1) then res=true end  
	if not res and cm.discheck(ev,CATEGORY_LEAVE_GRAVE,re,im0,im1) then res=true end  
	if res then Duel.NegateEffect(ev) end  
end  